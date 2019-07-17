//
//  SearchViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "SourcesViewController.h"
#import "Settings.h"
#import <Foundation/Foundation.h>
#include <bzlib.h>

@implementation SourcesViewController

int amountOfFilesToDownload = 0;
int downloadedFiles = 0;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        self.tableView.backgroundColor = [UIColor blackColor];
        self.tableView.separatorColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        self.navigationController.navigationBar.barStyle = 1;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *limePath = @"/var/mobile/Documents/Lime/";
    NSString *sourcesPath = @"/var/mobile/Documents/Lime/sources.list";
    NSString *listsPath = @"/var/mobile/Documents/Lime/lists/";
    NSString *iconsPath = @"/var/mobile/Documents/Lime/icons/";
    if(![[NSFileManager defaultManager] fileExistsAtPath:limePath isDirectory:nil]) [[NSFileManager defaultManager] createDirectoryAtPath:limePath withIntermediateDirectories:YES attributes:nil error:nil];
    if(![[NSFileManager defaultManager] fileExistsAtPath:listsPath isDirectory:nil]) [[NSFileManager defaultManager] createDirectoryAtPath:listsPath withIntermediateDirectories:YES attributes:nil error:nil];
    if(![[NSFileManager defaultManager] fileExistsAtPath:iconsPath isDirectory:nil]) [[NSFileManager defaultManager] createDirectoryAtPath:iconsPath withIntermediateDirectories:YES attributes:nil error:nil];
    if(![[NSFileManager defaultManager] fileExistsAtPath:sourcesPath isDirectory:nil]) [[NSFileManager defaultManager] createFileAtPath:sourcesPath contents:nil attributes:nil];
    // [self addRepoToListWithURLString:@"https://artikushg.github.io"] will add the repo to the list if it's valid; so even, when you have the UI fixed just do this with the textfield text
    self.repoNames = [[NSMutableDictionary alloc] init];
    [self grabRepoNames];
    /*UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"a" message:filename delegate:nil cancelButtonTitle:@"a" otherButtonTitles:nil];
    [a show];*/
    //[self downloadRepos];
    [self downloadEverything];
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
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (void)grabRepoNames {
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Documents/Lime/lists/" error:nil];
    for (NSString *filename in files) {
        NSRange range = [filename rangeOfString:@"_" options:NSBackwardsSearch];
        if(range.location != NSNotFound && [[filename substringFromIndex:range.location + 1] isEqualToString:@"Release"]) {
            NSString *fullFilename = [@"/var/mobile/Documents/Lime/lists/" stringByAppendingString:filename];
            NSArray *lines = [[NSString stringWithContentsOfFile:fullFilename encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];
            for (NSString *line in lines) {
                if(line.length > 6 && [[line substringToIndex:6] isEqualToString:@"Label:"]) {
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
}

- (void)downloadEverything {
    [self downloadRepos];
    while (CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true) && amountOfFilesToDownload != downloadedFiles) {};
    [self downloadRepoIcons];
    downloadedFiles = 0;
}

// Icons

- (void)downloadRepoIcons {
    for (NSString *name in self.sortedRepoNames) {
        NSString *filename = [self iconFilenameForName:name];
        NSString *urlString = [@"http://" stringByAppendingString:[self.repoNames objectForKey:name]];
        [self downloadRepoIconForURLString:urlString filename:filename];
    }
}

- (NSString *)iconFilenameForName:(NSString *)name {
    NSString *fixedName = [name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    fixedName = [fixedName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *filename = [NSString stringWithFormat:@"/var/mobile/Documents/Lime/icons/%@.png",fixedName];
    return filename;
}

- (void)downloadRepoIconForURLString:(NSString *)urlString filename:(NSString *)filename {
    if(![[urlString substringFromIndex:urlString.length - 1] isEqualToString:@"/"]) urlString = [urlString stringByAppendingString:@"/"];
    urlString = [urlString stringByAppendingString:@"CydiaIcon.png"];
    [self downloadFileAtURL:urlString writeToPath:filename];
}

// Repos backend

- (void)downloadRepos {
    // clean up the repos dir just in case
    for (NSString *filename in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Documents/Lime/lists/" error:nil]) [[NSFileManager defaultManager] removeItemAtPath:[@"/var/mobile/Documents/Lime/lists/" stringByAppendingString:filename] error:nil];
    for (NSString *filename in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Documents/Lime/icons/" error:nil]) [[NSFileManager defaultManager] removeItemAtPath:[@"/var/mobile/Documents/Lime/icons/" stringByAppendingString:filename] error:nil];
    
    NSMutableArray *fileLines = [[[NSString stringWithContentsOfFile:@"/var/mobile/Documents/Lime/sources.list" encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"] mutableCopy];
    amountOfFilesToDownload = (int)fileLines.count * 2;
    for (NSString *fileLine in fileLines) {
        NSString *strippedFileLine = [fileLine substringFromIndex:4]; // removes "deb "
        // i separate the string into two parts: "https://an.example.repourl/" and "./" (or some kinda "stable main" like bigboss and modmyi do)
        NSInteger locationOfSpace = [strippedFileLine rangeOfString:@" "].location;
        // the actual url
        NSString *repoURL = [strippedFileLine substringToIndex:locationOfSpace];
        NSString *originalRepoURL = [repoURL copy]; // we'll need that og one when downloading the icon
        // either the "./" or "stable main" etc at the end
        NSString *repoDirectory = [strippedFileLine substringFromIndex:locationOfSpace + 1];
        if(![repoDirectory isEqualToString:@"./"]) {
            NSArray *repoComponents = [repoDirectory componentsSeparatedByString:@" "];
            NSString *releaseURL = [NSString stringWithFormat:@"%@/dists/%@/Release",repoURL,[repoComponents objectAtIndex:0]];
            NSString *packagesURL = [NSString stringWithFormat:@"%@/dists/%@/%@/binary-iphoneos-arm/Packages.bz2",repoURL,[repoComponents objectAtIndex:0],[repoComponents objectAtIndex:1]];
            NSString *iconURL = [NSString stringWithFormat:@"%@/dists/%@/",repoURL,[repoComponents objectAtIndex:0]];
            //repoDirectory = [@"dists/" stringByAppendingString:repoDirectoryWithoutSpaces];
            //if(![[repoURL substringFromIndex:repoURL.length - 1] isEqualToString:@"/"]) repoURL = [repoURL stringByAppendingString:@"/"];
            [self downloadRepoFileAtURL:releaseURL];
            [self downloadRepoFileAtURL:packagesURL];
        } else {
            repoURL = [repoURL stringByAppendingString:repoDirectory];
            [self downloadRepoFileAtURL:[repoURL stringByAppendingString:@"Release"]];
            [self downloadRepoFileAtURL:[repoURL stringByAppendingString:@"Packages.bz2"]];
        }
    }
}

- (NSString *)repoFilenameStringForURLString:(NSString *)url {
    NSString *strippedURL = url;
    NSUInteger location = [url rangeOfString:@"://"].location;
    if(location != NSNotFound) strippedURL = [strippedURL substringFromIndex:location + 3];
    strippedURL = [strippedURL stringByReplacingOccurrencesOfString:@"www." withString:@""];
    NSString *baseFilename = [strippedURL stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *fullPathFilename = [@"/var/mobile/Documents/Lime/lists/" stringByAppendingString:baseFilename];
    return fullPathFilename;
}

- (void)downloadRepoFileAtURL:(NSString *)url {
    //if(![[url substringFromIndex:url.length - 1] isEqualToString:@"/"]) url = [url stringByAppendingString:@"/"];
    [self downloadFileAtURL:url writeToPath:[self repoFilenameStringForURLString:url]];
}

// For downloading files;
- (void)downloadFileAtURL:(NSString *)url writeToPath:(NSString *)path {
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
            if([[path substringFromIndex:path.length - 4] isEqualToString:@".bz2"]) {
                // we out there with the repos refreshing, ayy
                // we out there with an ui that looks refreshing
                // go follow @limeinstaller and your life will get better, ayy
                // we out there, we decompress the compression
                // (when u a programmer but also a rapper lmao)
                [self bunzip_one:path];
            }
            [self grabRepoNames];
            [self.tableView reloadData];
        }
        completed = YES;
        downloadedFiles++;
    }] resume];
    //while (CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true) && !completed) {};
}

// code reuse is amazing and this piece of stackoverflow "why does it work" magic actually works and i even have a clue how
// originally from icy btw
- (int)bunzip_one:(NSString *)filepathString {
    const char *file = [filepathString UTF8String];
    const char *output = [[filepathString substringToIndex:filepathString.length - 4] UTF8String];
    FILE *f = fopen(file, "r+b");
    FILE *outfile = fopen(output, "w");
    fprintf(outfile, "");
    outfile = fopen(output, "a");
    int bzError;
    BZFILE *bzf;
    char buf[4096];
    bzf = BZ2_bzReadOpen(&bzError, f, 0, 0, NULL, 0);
    if (bzError != BZ_OK) {
        printf("E: BZ2_bzReadOpen: %d\n", bzError);
        return -1;
    }
    while (bzError == BZ_OK) {
        int nread = BZ2_bzRead(&bzError, bzf, buf, sizeof buf);
        if (bzError == BZ_OK || bzError == BZ_STREAM_END) {
            size_t nwritten = fwrite(buf, 1, nread, stdout);
            fprintf(outfile, "%s", buf);
            if (nwritten != (size_t) nread) {
                printf("E: short write\n");
                return -1;
            }
        }
    }
    if (bzError != BZ_STREAM_END) {
        printf("E: bzip error after read: %d\n", bzError);
        return -1;
    }
    BZ2_bzReadClose(&bzError, bzf);
    fclose(outfile);
    fclose(f);
    [[NSFileManager defaultManager] removeItemAtPath:filepathString error:nil];
    return 0;
}

@end
