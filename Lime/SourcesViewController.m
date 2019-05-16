//
//  SearchViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "SourcesViewController.h"

@interface SourcesViewController ()

@end

NSString *sourcesPath = @"/var/mobile/Documents/Lime/sources.list";
NSString *limePath = @"/var/mobile/Documents/Lime";

@implementation SourcesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(![[NSFileManager defaultManager] fileExistsAtPath:limePath isDirectory:nil]) [[NSFileManager defaultManager] createDirectoryAtPath:limePath withIntermediateDirectories:YES attributes:nil error:nil];
    if(![[NSFileManager defaultManager] fileExistsAtPath:sourcesPath isDirectory:nil]) [[NSFileManager defaultManager] createFileAtPath:sourcesPath contents:nil attributes:nil];
    UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"a" message:[NSString stringWithFormat:@"%ld",[self statusCodeOfFileAtURL:@"https://google.com"]] delegate:nil cancelButtonTitle:@"a" otherButtonTitles:nil];
    [a show];
}

- (void)addRepoToListWithURLString:(NSString *)string {
    if(![[string substringFromIndex:string.length - 1] isEqualToString:@"/"]) string = [string stringByAppendingString:@"/"];
    NSString *formatted = [NSString stringWithFormat:@"deb %@ ./\n",string];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:sourcesPath];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[formatted dataUsingEncoding:NSUTF8StringEncoding]];
}

// Method to check the response code of a URL, we'll need that when checking if the URL the user's trying to add returns some sorta error

- (NSInteger)statusCodeOfFileAtURL:(NSString *)url {
    // 999 would mean the method failed as there's no such http code
    NSInteger __block responseCode = 999;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    /*[mutableRequest setValue:@"Telesphoreo APT-HTTP/1.0.592" forHTTPHeaderField:@"User-Agent"];
     [mutableRequest setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"X-Firmware"];
     [mutableRequest setValue:[DeviceInfo getDeviceName] forHTTPHeaderField:@"X-Machine"];
     [mutableRequest setValue:[DeviceInfo getUDID] forHTTPHeaderField:@"X-Unique-ID"];*/
    __block BOOL completed = NO;
    [[[NSURLSession sharedSession] dataTaskWithRequest:mutableRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        responseCode = httpResponse.statusCode;
        if(error) {
            NSLog(@"Status code: %ld\nError: %@",(long)httpResponse.statusCode,[error localizedDescription]);
            responseCode = 1000;
        }
        completed = YES;
    }] resume];
    while (CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true) && !completed){};
    return responseCode;
}


@end
