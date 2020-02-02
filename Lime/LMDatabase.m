//
//  LMDatabase.m
//  Lime
//
//  Created by PixelOmer on 2.02.2020.
//  Copyright © 2020 Citrusware. All rights reserved.
//

#import "LMDatabase.h"

@implementation LMDatabase

static NSArray<NSString *> *fieldsInDatabase;

+ (void)load {
	if (self == [LMDatabase class]) {
		fieldsInDatabase = @[
			@"package",
			@"version",
			@"description",
			@"name",
			@"sileoDepiction",
			@"depiction",
			@"md5",
			@"sha1",
			@"sha256"
		];
	}
}

+ (NSArray<NSString *> *)fieldsInDatabase {
	return fieldsInDatabase;
}

+ (instancetype)alloc {
	[NSException raise:NSInvalidArgumentException format:@"Do not use +[LMDatabase alloc]."];
	return nil;
}

+ (instancetype)sharedInstance {
	static dispatch_once_t onceToken;
	static LMDatabase *sharedInstance;
	dispatch_once(&onceToken, ^{
		sharedInstance = [super alloc];
		sharedInstance->initToken = calloc(1, sizeof(*sharedInstance->initToken));
		sharedInstance = [sharedInstance init];
	});
	return sharedInstance;
}

+ (NSString *)rootPath {
	static dispatch_once_t onceToken;
	static NSString *rootPath;
	dispatch_once(&onceToken, ^{
		NSString *documentsDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
		if (!documentsDir) [NSException raise:NSInternalInconsistencyException format:@"Could not get the documents directory."];
		rootPath = [documentsDir stringByAppendingPathComponent:@"Lime"];
		BOOL isDir;
		if (![NSFileManager.defaultManager fileExistsAtPath:rootPath isDirectory:&isDir] || !isDir) {
			[NSFileManager.defaultManager removeItemAtPath:rootPath error:nil];
			[NSFileManager.defaultManager createDirectoryAtPath:rootPath withIntermediateDirectories:YES attributes:nil error:nil];
		}
	});
	return rootPath;
}

- (instancetype)init {
	dispatch_once(initToken, ^{
		if (![super init]) [NSException raise:NSInternalInconsistencyException format:@"-[NSObject init] returned null."];
		sqlite3 *db;
		NSString *databasePath = [[self.class rootPath] stringByAppendingPathComponent:@"db.sqlite"];
		int status = sqlite3_open(databasePath.UTF8String, &db);
		if (status != SQLITE_OK) {
			[NSException raise:NSInternalInconsistencyException format:@"sqlite3_open(\"%@\") failed: %s", databasePath, (sqlite3_errmsg(db) ?: sqlite3_errstr(status))];
		}
		NSMutableString *optionalPackageFields = [NSMutableString new];
		for (int i=2; i<fieldsInDatabase.count; i++) {
			[optionalPackageFields appendFormat:@"`FIELD_%@` TEXT NULL, ", fieldsInDatabase[i]];
		}
		NSArray *queries = @[
			#if DEBUG
			@(
				"DROP TABLE IF EXISTS `REPOSITORIES`"
			),
			@(
				"DROP TABLE IF EXISTS `PACKAGES`"
			),
			#endif
			@(
				"PRAGMA foreign_keys = ON"
			),
			@(
				"CREATE TABLE IF NOT EXISTS `REPOSITORIES` ("
				"    `REPO_ID` INTEGER PRIMARY KEY AUTOINCREMENT,"
				"    `PACKAGES` TEXT NOT NULL,"
				"    `RELEASE` TEXT NOT NULL,"
				"    `URL` TEXT NOT NULL,"
				"    `COMPONENTS` TEXT NULL,"
				"    `DISTRIBUTION` TEXT NULL,"
				"    `ARCH` TEXT NOT NULL,"
				"    `LOCKED` INTEGER NOT NULL"
				")"
			),
			[NSString stringWithFormat:@(
				"CREATE TABLE IF NOT EXISTS `PACKAGES` ("
				"    `REPO_ID` INTEGER NOT NULL,"
				"    `PACKAGE_ID` INTEGER PRIMARY KEY AUTOINCREMENT,"
				"    `FIELD_PACKAGE` TEXT NOT NULL,"
				"    `FIELD_VERSION` TEXT NOT NULL, %@"
				"    FOREIGN KEY (`REPO_ID`) REFERENCES REPOSITORIES (`REPO_ID`) ON DELETE CASCADE"
				")"
			), optionalPackageFields]
		];
		for (NSString *query in queries) {
			char *errmsg = NULL;
			if (sqlite3_exec(db, query.UTF8String, NULL, NULL, &errmsg) != SQLITE_OK) {
				[NSException raise:NSInternalInconsistencyException format:@"sqlite3_exec() failed: %s", errmsg];
			}
			if (errmsg) sqlite3_free(errmsg);
		}
		self->_databaseHandle = db;
	});
	return self;
}

- (BOOL)executeQuery:(NSString *)query
	parameters:(NSArray<__kindof NSObject *> *)params
	block:(BOOL(^)(NSArray<NSString *> *, NSArray *))block
{
	sqlite3_stmt *stmt = NULL;
	int status = sqlite3_prepare_v2(_databaseHandle, query.UTF8String, -1, &stmt, NULL);
	if (status != SQLITE_OK) {
		if (stmt) sqlite3_finalize(stmt);
		return NO;
	}
	int i=1;
	for (__kindof NSObject *object in params) {
		if ([object isKindOfClass:[NSString class]]) {
			sqlite3_bind_text(stmt, i++, [(NSString *)object UTF8String], -1, SQLITE_TRANSIENT);
		}
		else if ([object isKindOfClass:[NSNumber class]]) {
			sqlite3_bind_int(stmt, i++, [(NSNumber *)object intValue]);
		}
		else if ([object isKindOfClass:[NSNull class]]) {
			sqlite3_bind_null(stmt, i++);
		}
		else {
			[NSException
				raise:NSInvalidArgumentException
				format:@"An unsupported object was passed to -[%@ %@]: %@",
				NSStringFromClass(self.class),
				NSStringFromSelector(_cmd),
				object
			];
		}
	}
	__kindof NSArray *columns = [NSMutableArray new];
	NSMutableArray *row = [NSMutableArray new];
	if (block) {
		while ((status = sqlite3_step(stmt)) == SQLITE_ROW) {
			for (i=0; i<sqlite3_column_count(stmt); i++) {
				switch (sqlite3_column_type(stmt, i)) {
					case SQLITE_TEXT:
						[row addObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, i)]];
						break;
					case SQLITE_INTEGER:
						[row addObject:@(sqlite3_column_int(stmt, i))];
						break;
					case SQLITE_NULL:
						[row addObject:NSNull.null];
						break;
					default:
						[NSException
							raise:NSInternalInconsistencyException
							format:@"Received an unknown type of object from query: %@",
							query
						];
						break;
				}
				if ([columns isKindOfClass:[NSMutableArray class]]) {
					[(NSMutableArray *)columns addObject:@(sqlite3_column_name(stmt, i))];
				}
			}
			if ([columns isKindOfClass:[NSMutableArray class]]) {
				columns = columns.copy;
			}
			if (!block(columns, (id)row)) break;
		}
	}
	status = sqlite3_finalize(stmt);
	return (status == SQLITE_OK);
}

@end
