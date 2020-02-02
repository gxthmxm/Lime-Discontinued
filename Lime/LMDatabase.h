//
//  LMDatabase.h
//  Lime
//
//  Created by PixelOmer on 2.02.2020.
//  Copyright © 2020 Citrusware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMDatabase : NSObject {
	dispatch_once_t *initToken;
}
@property (nonatomic, assign, readonly) sqlite3 *databaseHandle;
+ (instancetype)alloc;
+ (instancetype)sharedInstance;
+ (NSString *)rootPath;
@end

NS_ASSUME_NONNULL_END
