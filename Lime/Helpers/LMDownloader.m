//
//  LMDownloader.m
//  Lime
//
//  Created by Even Flatabø on 27/12/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMDownloader.h"

@implementation LMDownloader

-(void)downloadFileWithURLString:(nonnull NSString *)url toFile:(nonnull NSString *)file completionHandler:(nullable void (^)(NSError * _Nullable))completion {
    self.completionBlock = completion;
    self.filePath = file;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    NSURLSessionDownloadTask *releaseTask = [session downloadTaskWithRequest:[LimeHelper mutableURLRequestWithHeadersWithURLString:url]];
    [releaseTask resume];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    if (self.progressBlock) {
        self.progressBlock(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    }
}

- (void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location {
    NSString *path = [[NSString stringWithFormat:@"%@", location] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    NSError *fileError;
    if ([NSFileManager.defaultManager fileExistsAtPath:path]) [NSFileManager.defaultManager moveItemAtPath:path toPath:self.filePath error:&fileError];
    if (self.completionBlock) {
        if (fileError) self.completionBlock(fileError);
        else (self.completionBlock(nil));
    }
}

@end
