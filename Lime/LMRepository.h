//
//  LMRepository.h
//  Lime
//
//  Created by PixelOmer on 2.02.2020.
//  Copyright © 2020 Citrusware. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMRepository : NSObject
@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, strong, readonly) NSArray *components;
@property (nonatomic, strong, readonly) NSURL *URL;
@property (nonatomic, strong, readonly) NSString *architecture;
@property (nonatomic, strong, readonly) NSString *distribution;
@property (nonatomic, strong, readonly) NSString *packagesFilename;
@property (nonatomic, strong, readonly) NSString *releaseFilename;
@property (nonatomic, assign, readonly) int databaseID;
@property (nonatomic, strong, readonly) NSFileHandle *packagesFileHandle;
@property (nonatomic, strong, readonly) NSFileHandle *releaseFileHandle;
- (nullable instancetype)initWithRepositoryID:(int)repoID;
- (nullable instancetype)initWithURLString:(NSString *)urlString
	distribution:(NSString * _Nullable)dist
	spaceSeparatedComponents:(NSString * _Nullable)components
	architecture:(NSString *)architecture;
- (nonnull instancetype)initWithURL:(NSURL *)url
	distribution:(NSString * _Nullable)dist
	components:(NSArray<NSString *> * _Nullable)components
	architecture:(NSString *)architecture;
@end

NS_ASSUME_NONNULL_END
