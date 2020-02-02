//
//  LMRepository.m
//  Lime
//
//  Created by PixelOmer on 2.02.2020.
//  Copyright © 2020 Citrusware. All rights reserved.
//

#import "LMRepository.h"
#import "LMDatabase.h"

@implementation LMRepository

- (instancetype)initWithURL:(NSURL *)url
	distribution:(NSString *)dist
	components:(NSArray<NSString *> *)components
	architecture:(NSString *)architecture
{
	if (!url || !architecture) return nil;
	if ((self = [super init])) {
		_URL = url;
		_distribution = dist;
		_components = components;
		_architecture = architecture;
	}
	return self;
}

- (instancetype)initWithURLString:(NSString *)urlString
	distribution:(NSString *)dist
	spaceSeparatedComponents:(NSString *)components
	architecture:(NSString *)architecture
{
	if (!urlString || !architecture) return nil;
	NSURL *URL = [NSURL URLWithString:urlString];
	NSArray *componentsArray = [components componentsSeparatedByString:@" "];
	return [self initWithURL:URL distribution:dist components:componentsArray architecture:architecture];
}

- (instancetype)initWithRepositoryID:(NSInteger)repoID {
	NSArray * __block data = nil;
	BOOL success = [LMDatabase.sharedInstance
		executeQuery:@"SELECT `PACKAGES`, `RELEASE`, `URL`, `COMPONENTS`, `DISTRIBUTION`, `ARCH`, `LOCKED` FROM `REPOSITORIES` WHERE `REPO_ID`=?"
		parameters:@[@(repoID)]
		block:^BOOL(NSArray<NSString *> * _Nonnull columns, NSArray * _Nonnull rowData) {
			data = rowData;
			return NO;
		}
	];
	if (!success || !data) return nil;
	self = [self
		initWithURLString:data[2]
		distribution:([data[4] isKindOfClass:[NSNull class]] ? nil : data[4])
		spaceSeparatedComponents:([data[3] isKindOfClass:[NSNull class]] ? nil : data[3])
		architecture:data[5]
	];
	if (!self) return nil;
	_isLocked = [(NSNumber *)data[6] boolValue];
	_packagesFilename = data[0];
	_releaseFilename = data[1];
	return self;
}


@end
