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

NSString *limePath = @"/var/mobile/Documents/Lime/";
NSString *sourcesPath = nil;
NSString *listsPath = @"/var/mobile/Library/Caches/com.saurik.Cydia/lists/";

@implementation SourcesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sourcesPath = [limePath stringByAppendingString:@"sources.list"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:limePath isDirectory:nil]) [[NSFileManager defaultManager] createDirectoryAtPath:limePath withIntermediateDirectories:YES attributes:nil error:nil];
    if(![[NSFileManager defaultManager] fileExistsAtPath:sourcesPath isDirectory:nil]) [[NSFileManager defaultManager] createFileAtPath:sourcesPath contents:nil attributes:nil];
    // [self addRepoToListWithURLString:@"https://artikushg.github.io"] will add the repo to the list if it's valid; so even, when you have the UI fixed just do this with the textfield text
    self.repoNames = [[NSMutableDictionary alloc] init];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:listsPath error:nil];
    for (NSString *filename in files) {
        NSRange range = [filename rangeOfString:@"_" options:NSBackwardsSearch];
        if(range.location != NSNotFound && [[filename substringFromIndex:range.location + 1] isEqualToString:@"Release"]) {
            NSString *fullFilename = [listsPath stringByAppendingString:filename];
            NSArray *lines = [[NSString stringWithContentsOfFile:fullFilename encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];
            for (NSString *line in lines) {
                if(line.length > 7 && [[line substringToIndex:7] isEqualToString:@"Label: "]) {
                    NSString *link = [[filename substringToIndex:[filename rangeOfString:@"_" options:NSBackwardsSearch].location] stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
                    if([[link substringFromIndex:link.length - 2] isEqualToString:@"/."]) link = [link substringToIndex:link.length - 2];
                    [self.repoNames setObject:link forKey:[line substringFromIndex:7]];
                    break;
                }
            }
        } else continue;
    }
    self.sortedRepoNames = [[NSMutableArray alloc] initWithArray:self.repoNames.allKeys];
    [self.sortedRepoNames sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    /*UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"a" message:filename delegate:nil cancelButtonTitle:@"a" otherButtonTitles:nil];
    [a show];*/
    [self downloadRepoIcons];
}

- (NSString *)iconFilenameForName:(NSString *)name {
    NSString *fixedName = [name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    fixedName = [fixedName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *filename = [[limePath stringByAppendingString:fixedName] stringByAppendingString:@".png"];
    return filename;
}

- (void)downloadRepoIcons {
    for (NSString *name in self.sortedRepoNames) {
        NSString *filename = [self iconFilenameForName:name];
        NSString *urlString = [@"http://" stringByAppendingString:[self.repoNames objectForKey:name]];
        NSData *iconData = [self repoIconForURLString:urlString];
        if(iconData) [iconData writeToFile:filename atomically:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.repoNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.textLabel.text = [self.sortedRepoNames objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.repoNames objectForKey:cell.textLabel.text];
    NSString *filename = [self iconFilenameForName:cell.textLabel.text];
    UIImage *icon;
    if([[NSFileManager defaultManager] fileExistsAtPath:filename isDirectory:nil]) icon = [UIImage imageWithContentsOfFile:filename];
    else icon = [UIImage imageNamed:@"sections/Unknown.png"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(35,35), NO, [UIScreen mainScreen].scale);
    [icon drawInRect:CGRectMake(0,0,35,35)];
    icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 10;
    cell.imageView.image = icon;
    return cell;
}

- (NSData *)repoIconForURLString:(NSString *)urlString {
    if(![[urlString substringFromIndex:urlString.length - 1] isEqualToString:@"/"]) urlString = [urlString stringByAppendingString:@"/"];
    urlString = [urlString stringByAppendingString:@"CydiaIcon.png"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setValue:@"Telesphoreo APT-HTTP/1.0.592" forHTTPHeaderField:@"User-Agent"];
    [request setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"X-Firmware"];
    [request setValue:[DeviceInfo deviceName] forHTTPHeaderField:@"X-Machine"];
    [request setValue:[DeviceInfo getUDID] forHTTPHeaderField:@"X-Unique-ID"];
    __block BOOL completed = NO;
    __block NSData *blockData = nil;
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        completed = YES;
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200) blockData = data;
    }] resume];
    while (CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true) && !completed){};
    return blockData;
}

/*- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"packageInfo" sender:self];
}*/

- (BOOL)repoIsValid:(NSString *)repoURL {
    if(![[repoURL substringFromIndex:repoURL.length - 1] isEqualToString:@"/"]) repoURL = [repoURL stringByAppendingString:@"/"];
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
