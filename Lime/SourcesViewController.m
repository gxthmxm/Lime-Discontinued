//
//  SearchViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "SourcesViewController.h"
#import "Settings.h"

@interface SourcesViewController ()

@end

NSString *sourcesPath = @"/var/mobile/Documents/Lime/sources.list";
NSString *limePath = @"/var/mobile/Documents/Lime";

@implementation SourcesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(![[NSFileManager defaultManager] fileExistsAtPath:limePath isDirectory:nil]) [[NSFileManager defaultManager] createDirectoryAtPath:limePath withIntermediateDirectories:YES attributes:nil error:nil];
    if(![[NSFileManager defaultManager] fileExistsAtPath:sourcesPath isDirectory:nil]) [[NSFileManager defaultManager] createFileAtPath:sourcesPath contents:nil attributes:nil];
    // [self addRepoToListWithURLString:@"https://artikushg.github.io"] will add the repo to the list if it's valid; so even, when you have the UI fixed just do this with the textfield text
}

- (BOOL)repoIsValid:(NSString *)repoURL {
    if(![[repoURL substringFromIndex:repoURL.length - 1] isEqualToString:@"/"]) repoURL = [repoURL stringByAppendingString:@"/"];
    NSLog(@"%@",repoURL);
    NSString *packages = [repoURL stringByAppendingString:@"Packages.bz2"];
    NSString *release = [repoURL stringByAppendingString:@"Release"];
    if([self statusCodeOfFileAtURL:packages] == 200 && [self statusCodeOfFileAtURL:release] == 200) return YES;
    return NO;
}

- (void)addRepoToListWithURLString:(NSString *)urlString {
    if(![self repoIsValid:urlString]) {
        if(@available(iOS 8.0, *)) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"The \"%@\" can not be added to your list because it does not appear to be a valid repo. This may be caused by your internet connection or by an issue on the repo owner's side. Please try again later.",urlString] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"The \"%@\" can not be added to your list because it does not appear to be a valid repo. This may be caused by your internet connection or by an issue on the repo owner's side. Please try again later.",urlString] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    if(![[urlString substringFromIndex:urlString.length - 1] isEqualToString:@"/"]) urlString = [urlString stringByAppendingString:@"/"];
    NSString *formatted = [NSString stringWithFormat:@"deb %@ ./\n",urlString];
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
    [mutableRequest setValue:@"Telesphoreo APT-HTTP/1.0.592" forHTTPHeaderField:@"User-Agent"];
     [mutableRequest setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"X-Firmware"];
     [mutableRequest setValue:[DeviceInfo deviceName] forHTTPHeaderField:@"X-Machine"];
     [mutableRequest setValue:[DeviceInfo getUDID] forHTTPHeaderField:@"X-Unique-ID"];
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
