//
//  LMDownloader.h
//  Lime
//
//  Created by Even Flatabø on 27/12/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LimeHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMDownloader : NSObject <NSURLSessionDownloadDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>

-(void)downloadFileWithURLString:(nonnull NSString *)url toFile:(nonnull NSString *)file progressView:(nullable UIProgressView *)progressView completionHandler:(nullable void (^)(NSError * _Nullable error))completion;

@property (nonatomic, strong, nullable) UIProgressView *progressView;

@property (nonatomic) long long int expectedLength;
@property (nonatomic) long long int bytesDownloaded;

@end

NS_ASSUME_NONNULL_END
