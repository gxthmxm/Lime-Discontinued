//
//  LMSourceDownloader.m
//  Lime
//
//  Created by Even Flatabø on 17/12/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMSourceDownloader.h"

@implementation LMSourceDownloader

- (id)initWithRepo:(LMRepo *)repo {
    self = [LMSourceDownloader new];
    if (self) {
        self.repo = repo;
    }
    return self;
}

-(void)downloadRepoAndIcon:(BOOL)icon completionHandler:(void (^)(void))completion {
    __block int tasks = icon ? 3 : 2;
    __block int completedTasks = 0;
    __block float progress = 0;
    
    if (self.sourceController) {
        NSUInteger repoIndex = [[LMSourceManager.sharedInstance sources] indexOfObject:self.repo];
        self.cell = [self.sourceController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:repoIndex inSection:0]];
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
    NSMutableURLRequest *releaseRequest = [self mutableURLRequestWithHeadersWithURLString:self.repo.rawRepo.releaseURL];
    NSURLSessionDownloadTask *releaseTask = [session downloadTaskWithRequest:releaseRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (self.sourceController) {
                    progress += 1 / (float)tasks;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.cell.progressView setProgress:progress animated:YES];
                    });
                }
                [NSFileManager.defaultManager removeItemAtPath:self.repo.rawRepo.releasePath error:nil];
                [[NSFileManager defaultManager] moveItemAtPath:[location.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""] toPath:self.repo.rawRepo.releasePath error:nil];
                NSLog(@"[SourceManager] Downloaded %@ to %@", self.repo.rawRepo.releaseURL, self.repo.rawRepo.releasePath);
                completedTasks++;
                if (completedTasks == tasks) completion();
           }];
    releaseTask.taskDescription = [self.repo.rawRepo.repoURL stringByAppendingString:@"_Release"];
    [releaseTask resume];
    
    NSMutableURLRequest *packagesRequest = [self mutableURLRequestWithHeadersWithURLString:[self.repo.rawRepo.packagesURL stringByAppendingFormat:@".bz2"]];
    NSURLSessionDownloadTask *packagesTask = [session downloadTaskWithRequest:packagesRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (self.sourceController) {
                    progress += 1 / (float)tasks;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.cell.progressView setProgress:progress animated:YES];
                    });
                }
                [NSFileManager.defaultManager removeItemAtPath:self.repo.rawRepo.packagesPath error:nil];
                [[NSFileManager defaultManager] moveItemAtPath:[location.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""] toPath:self.repo.rawRepo.packagesPath error:nil];
                int bunzip_one = [self bunzip_one:self.repo.rawRepo.packagesPath];
                // To hide the warning
                bunzip_one = bunzip_one;
                [[NSFileManager defaultManager] moveItemAtPath:[self.repo.rawRepo.packagesPath substringToIndex:self.repo.rawRepo.packagesPath.length - 4] toPath:self.repo.rawRepo.packagesPath error:nil];
                NSLog(@"[SourceManager] Downloaded %@ to %@", self.repo.rawRepo.packagesURL, self.repo.rawRepo.packagesPath);
                completedTasks++;
                if (completedTasks == tasks) completion();
           }];
    packagesTask.taskDescription = [self.repo.rawRepo.repoURL stringByAppendingString:@"_Packages"];
    [packagesTask resume];
    
    if (icon) {
        if (self.sourceController) {
            progress += 1 / (float)tasks;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.cell.progressView setProgress:progress animated:YES];
            });
        }
        NSMutableURLRequest *iconRequest = [self mutableURLRequestWithHeadersWithURLString:self.repo.rawRepo.imageURL];
        NSURLSessionDownloadTask *iconTask = [session downloadTaskWithRequest:iconRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            [NSFileManager.defaultManager removeItemAtPath:self.repo.rawRepo.imagePath error:nil];
            [[NSFileManager defaultManager] moveItemAtPath:[location.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""] toPath:self.repo.rawRepo.imagePath error:nil];
            NSLog(@"[SourceManager] Downloaded %@ to %@", self.repo.rawRepo.imageURL, self.repo.rawRepo.imagePath);
            completedTasks++;
            if (completedTasks == tasks) completion();
        }];
        iconTask.taskDescription = [self.repo.rawRepo.repoURL stringByAppendingString:@"_Icon"];
        [iconTask resume];
    }
}

- (NSMutableURLRequest *)mutableURLRequestWithHeadersWithURLString:(NSString *)URLString {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0];
    [request setValue:@"Cydia/0.9 CFNetwork/978.0.7 Darwin/18.7.0" forHTTPHeaderField:@"User-Agent"];
    [request setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"X-Firmware"];
    [request setValue:[LMDeviceInfo deviceName] forHTTPHeaderField:@"X-Machine"];
    [request setValue:[LMDeviceInfo udid] forHTTPHeaderField:@"X-Unique-ID"];
    return request;
}

// code reuse is amazing and this piece of stackoverflow "why does it work" magic actually works and i even have a clue how
// originally from my broken icy btw
- (int)bunzip_one:(NSString *)filepathString {
    const char *file = [filepathString UTF8String];
    const char *output = [[filepathString substringToIndex:filepathString.length - 4] UTF8String];
    FILE *f = fopen(file, "r+b");
    FILE *outfile = fopen(output, "w");
    fprintf(outfile, "");
    outfile = fopen(output, "a");
    int bzError;
    BZFILE *bzf;
    // it used to be char buf[4096] but @CodeLabyrinth aka a guy quite experienced with C told me this would be better for memory
    unsigned short buf[4096];
    bzf = BZ2_bzReadOpen(&bzError, f, 0, 0, NULL, 0);
    if (bzError != BZ_OK) {
        printf("E: BZ2_bzReadOpen: %d\n", bzError);
        [[NSFileManager defaultManager] removeItemAtPath:filepathString error:nil];
        return -1;
    }
    while (bzError == BZ_OK) {
        int nread = BZ2_bzRead(&bzError, bzf, buf, sizeof buf);
        if (bzError == BZ_OK || bzError == BZ_STREAM_END) {
            size_t nwritten = fwrite(buf, 1, nread, outfile);
            if (nwritten != (size_t) nread) {
                printf("E: short write\n");
                [[NSFileManager defaultManager] removeItemAtPath:filepathString error:nil];
                return -1;
            }
        }
    }
    if (bzError != BZ_STREAM_END) {
        printf("E: bzip error after read: %d\n", bzError);
        [[NSFileManager defaultManager] removeItemAtPath:filepathString error:nil];
        return -1;
    }
    BZ2_bzReadClose(&bzError, bzf);
    fclose(outfile);
    fclose(f);
    [[NSFileManager defaultManager] removeItemAtPath:filepathString error:nil];
    return 0;
}

@end
