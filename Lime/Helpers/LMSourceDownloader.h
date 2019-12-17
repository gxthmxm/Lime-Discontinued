//
//  LMSourceDownloader.h
//  Lime
//
//  Created by Even Flatabø on 17/12/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "../Objects/LMRepo.h"
#import "LMDeviceInfo.h"
#import <bzlib.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMSourceDownloader : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate>

@property (nonatomic, retain) LMRepo *repo;
@property (nonatomic) NSInteger tasks;
@property (nonatomic) NSInteger completedTasks;

- (id)initWithRepo:(LMRepo *)repo;
- (void)downloadRepoAndIcon:(BOOL)icon completionHandler:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
