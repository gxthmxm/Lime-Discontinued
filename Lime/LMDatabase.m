//
//  LMDatabase.m
//  Lime
//
//  Created by PixelOmer on 2.02.2020.
//  Copyright © 2020 Citrusware. All rights reserved.
//

#import "LMDatabase.h"

@implementation LMDatabase

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
		sqlite3 *db;
		NSString *databasePath = [[self.class rootPath] stringByAppendingPathComponent:@"db.sqlite"];
		int status = sqlite3_open(databasePath.UTF8String, &db);
		if (status != SQLITE_OK) {
			[NSException raise:NSInternalInconsistencyException format:@"sqlite3_open(\"%@\") failed: %s", databasePath, (sqlite3_errmsg(db) ?: sqlite3_errstr(status))];
		}
		NSArray *queries = @[
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
			@(
				"CREATE TABLE IF NOT EXISTS `PACKAGES` ("
				"    `REPO_ID` INTEGER NOT NULL,"
				"    `PACKAGE_ID` INTEGER PRIMARY KEY AUTOINCREMENT,"
				"    `FIELD_PACKAGE` TEXT NOT NULL,"
				"    `FIELD_VERSION` TEXT NOT NULL,"
				"    `FIELD_NAME` TEXT NULL,"
				"    `FIELD_SILEODEPICTION` TEXT NULL,"
				"    FOREIGN KEY (`REPO_ID`) REFERENCES REPOSITORIES (`REPO_ID`) ON DELETE CASCADE"
				")"
			)
		];
		for (NSString *query in queries) {
			char *errmsg = NULL;
			if (sqlite3_exec(db, query.UTF8String, NULL, NULL, &errmsg) != SQLITE_OK) {
				[NSException raise:NSInternalInconsistencyException format:@"sqlite3_exec() failed: %s", errmsg];
			}
			if (errmsg) sqlite3_free(errmsg);
		}
	});
	return self;
}

@end
