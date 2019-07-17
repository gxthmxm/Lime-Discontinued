//
//  SearchViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "SourcesViewController.h"
#import "Settings.h"
#import "SourcesBackend.h"
#import <Foundation/Foundation.h>

@implementation SourcesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"load" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    NSString *limePath = @"/var/mobile/Documents/Lime/";
    NSString *sourcesPath = @"/var/mobile/Documents/Lime/sources.list";
    NSString *listsPath = @"/var/mobile/Documents/Lime/lists/";
    if(![[NSFileManager defaultManager] fileExistsAtPath:limePath isDirectory:nil]) [[NSFileManager defaultManager] createDirectoryAtPath:limePath withIntermediateDirectories:YES attributes:nil error:nil];
    if(![[NSFileManager defaultManager] fileExistsAtPath:listsPath isDirectory:nil]) [[NSFileManager defaultManager] createDirectoryAtPath:listsPath withIntermediateDirectories:YES attributes:nil error:nil];
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
    //[self downloadRepoIcons];
    [self downloadRepos];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        self.tableView.backgroundColor = [UIColor blackColor];
        self.tableView.separatorColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        self.navigationController.navigationBar.barStyle = 1;
    }
}

- (void)downloadRepoIcons {
    for (NSString *name in self.sortedRepoNames) {
        NSString *filename = [SourcesBackend iconFilenameForName:name];
        NSString *urlString = [@"http://" stringByAppendingString:[self.repoNames objectForKey:name]];
        [self downloadRepoIconForURLString:urlString name:filename];
    }
}

- (void)downloadRepoIconForURLString:(NSString *)urlString name:(NSString *)name {
    if(![[urlString substringFromIndex:urlString.length - 1] isEqualToString:@"/"]) urlString = [urlString stringByAppendingString:@"/"];
    urlString = [urlString stringByAppendingString:@"CydiaIcon.png"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setValue:@"Telesphoreo APT-HTTP/1.0.592" forHTTPHeaderField:@"User-Agent"];
    [request setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"X-Firmware"];
    [request setValue:[DeviceInfo deviceName] forHTTPHeaderField:@"X-Machine"];
    [request setValue:[DeviceInfo getUDID] forHTTPHeaderField:@"X-Unique-ID"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200) [data writeToFile:name atomically:YES];
        [self.tableView reloadData];
    }] resume];
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
    cell.detailTextLabel.alpha = 0.5;
    NSString *filename = [SourcesBackend iconFilenameForName:cell.textLabel.text];
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
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (void)downloadRepos {
    NSMutableArray *fileLines = [[[NSString stringWithContentsOfFile:@"/var/mobile/Documents/Lime/sources.list" encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"] mutableCopy];
    for (NSString *fileLine in fileLines) {
        NSString *strippedFileLine = [fileLine substringFromIndex:4]; // removes "deb "
        // i separate the string into two parts: "https://an.example.repourl/" and "./" (or some kinda "stable main" like bigboss and modmyi do)
        NSInteger locationOfSpace = [strippedFileLine rangeOfString:@" "].location;
        // the actual url
        NSString *repoURL = [strippedFileLine substringToIndex:locationOfSpace];
        // either the "./" or "stable main" etc at the end
        NSString *repoDirectory = [strippedFileLine substringFromIndex:locationOfSpace + 1];
        if(![repoDirectory isEqualToString:@"./"]) {
            NSString *repoDirectoryWithoutSpaces = [repoDirectory stringByReplacingOccurrencesOfString:@" " withString:@"/"]; // spaces to slashes for url
            repoDirectory = [@"dists/" stringByAppendingString:repoDirectoryWithoutSpaces];
        }
        repoURL = [repoURL stringByAppendingString:repoDirectory];
        if(![[repoURL substringFromIndex:repoURL.length - 1] isEqualToString:@"/"]) repoURL = [repoURL stringByAppendingString:@"/"];
        [self downloadRepoAtURL:repoURL];
    }
}

- (void)downloadRepoAtURL:(NSString *)url {
    if(![[url substringFromIndex:url.length - 1] isEqualToString:@"/"]) url = [url stringByAppendingString:@"/"];
    NSString *strippedURL = url;
    NSUInteger location = [url rangeOfString:@"://"].location;
    if(location != NSNotFound) strippedURL = [strippedURL substringFromIndex:location + 3];
    strippedURL = [strippedURL stringByReplacingOccurrencesOfString:@"www." withString:@""];
    NSString *releaseURL = [url stringByAppendingString:@"Release"];
    NSString *packagesURL = [url stringByAppendingString:@"Packages.bz2"];
    NSString *baseFilename = [strippedURL stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *fullPathFilename = [@"/var/mobile/Documents/Lime/lists/" stringByAppendingString:baseFilename];
    NSString *releaseFilename = [fullPathFilename stringByAppendingString:@"Release"];
    NSString *packagesFilename = [fullPathFilename stringByAppendingString:@"Packages.bz2"];
    [self downloadFileAtURL:releaseURL writeToPath:releaseFilename];
    [self downloadFileAtURL:packagesURL writeToPath:packagesFilename];
}

// For downloading files;
- (NSInteger)downloadFileAtURL:(NSString *)url writeToPath:(NSString *)path {
    __block NSInteger responseCode;
    __block BOOL completed = NO;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setValue:@"Telesphoreo APT-HTTP/1.0.592" forHTTPHeaderField:@"User-Agent"];
    [request setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"X-Firmware"];
    [request setValue:[DeviceInfo deviceName] forHTTPHeaderField:@"X-Machine"];
    [request setValue:[DeviceInfo getUDID] forHTTPHeaderField:@"X-Unique-ID"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        responseCode = httpResponse.statusCode;
        if(error || responseCode != 200) {
            NSLog(@"Status code: %ld\nError: %@",responseCode,[error localizedDescription]);
            // VERY VERY GOOD ERROR MESSAGE FOR THE USER SAYING THE REPOS MESSED UP GOES HERE
            // HOPE I DONT FORGET TO IMPLEMENT IT YES
        } else {
            // download the source prolly
            [data writeToFile:path atomically:YES];
        }
        completed = YES;
    }] resume];
    while (CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true) && !completed) {};
    return responseCode;
}

@end
