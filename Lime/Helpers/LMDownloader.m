//
//  LMDownloader.m
//  Lime
//
//  Created by Even Flatabø on 27/12/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMDownloader.h"

@implementation LMDownloader

-(void)downloadFileWithURLString:(nonnull NSString *)url toFile:(nonnull NSString *)file progressView:(nullable UIProgressView *)progressView completionHandler:(nullable void (^)(NSError * _Nullable error))completion {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    NSURLSessionDownloadTask *releaseTask = [session downloadTaskWithRequest:[LimeHelper mutableURLRequestWithHeadersWithURLString:url] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *path = [[NSString stringWithFormat:@"%@", location] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        NSError *fileError;
        if ([NSFileManager.defaultManager fileExistsAtPath:path]) [NSFileManager.defaultManager moveItemAtPath:path toPath:file error:&fileError];
        else if (completion) completion(error);
        if (fileError) completion(fileError);
        else (completion(nil));
    }];
    [releaseTask resume];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    self.expectedLength = totalBytesExpectedToWrite;
    self.bytesDownloaded += bytesWritten;
    if (self.progressView) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressView setProgress:(float)self.bytesDownloaded / self.expectedLength];
        });
    }
}

- (void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location {
    // idk
}

@end
