//
//  SourcesBackend.m
//  Lime
//
//  Created by ArtikusHG on 5/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "SourcesBackend.h"

@implementation SourcesBackend

NSString *limePath = @"/var/mobile/Documents/Lime/";
NSString *sourcesPath = @"/var/mobile/Documents/Lime/sources.list";
NSString *listsPath = @"/var/mobile/Documents/Lime/lists/";

+ (NSString *)iconFilenameForName:(NSString *)name {
    NSString *fixedName = [name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    fixedName = [fixedName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *filename = [[limePath stringByAppendingString:fixedName] stringByAppendingString:@".png"];
    return filename;
}

/*- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 [self performSegueWithIdentifier:@"packageInfo" sender:self];
 }*/

+ (BOOL)repoIsValid:(NSString *)repoURL {
    if(![[repoURL substringFromIndex:repoURL.length - 1] isEqualToString:@"/"]) repoURL = [repoURL stringByAppendingString:@"/"];
    NSString *packages = [repoURL stringByAppendingString:@"Packages.bz2"];
    NSString *release = [repoURL stringByAppendingString:@"Release"];
    if([self statusCodeOfFileAtURL:packages] == 200 && [self statusCodeOfFileAtURL:release] == 200) return YES;
    return NO;
}

// apt-get update -o "Dir::Etc::SourceParts=/var/mobile/Documents/Lime/lists/" -o "Dir::Etc::SourceList=/var/mobile/Documents/Lime/sources.list" -o "Dir::State::Lists=/var/mobile/Documents/Lime/lists/"

// Method to check the response code of a URL, we'll need that when checking if the URL the user's trying to add returns some sorta error

+ (NSInteger)statusCodeOfFileAtURL:(NSString *)url {
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
