//
//  LimeHelper.m
//  Lime
//
//  Created by EvenDev on 24/06/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "LimeHelper.h"

@implementation LimeHelper

+ (id)sharedInstance {
    static LimeHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    
    return instance;
}

-(id)init {
    self = [super init];
    if (self) {
        NSString *limePath = @"/var/mobile/Documents/Lime/";
        NSString *sourcesPath = @"/var/mobile/Documents/Lime/sources.list";
        NSString *listsPath = @"/var/mobile/Documents/Lime/lists/";
        NSString *iconsPath = @"/var/mobile/Documents/Lime/icons/";
        if(![[NSFileManager defaultManager] fileExistsAtPath:limePath isDirectory:nil]) [[NSFileManager defaultManager] createDirectoryAtPath:limePath withIntermediateDirectories:YES attributes:nil error:nil];
        if(![[NSFileManager defaultManager] fileExistsAtPath:listsPath isDirectory:nil]) [[NSFileManager defaultManager] createDirectoryAtPath:listsPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(![[NSFileManager defaultManager] fileExistsAtPath:iconsPath isDirectory:nil]) [[NSFileManager defaultManager] createDirectoryAtPath:iconsPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(![[NSFileManager defaultManager] fileExistsAtPath:sourcesPath isDirectory:nil]) [[NSFileManager defaultManager] createFileAtPath:sourcesPath contents:nil attributes:nil];
        self.packagesArray = [NSMutableArray new];
        self.packagesDict = [NSMutableDictionary new];
        self.installedPackagesArray = [NSMutableArray new];
        self.installedPackagesDict = [NSMutableDictionary new];
        self.sources = [[NSMutableArray alloc] init];
        self.sourcesInList = [[NSMutableArray alloc] init];
        [self getInstalledPackages];
        [self grabSourcesInLists];
    }
    return self;
}

-(void)getInstalledPackages {
    // Inits a parser on the dpkg status file
    LMPackageParser *parser = [[LMPackageParser alloc] initWithFilePath:[LimeHelper dpkgStatusLocation]];
    [parser.packages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // Add all the packages to dictionaries
        LMPackage *pkg = obj;
        // This dict only has the installed packages
        [self.installedPackagesDict setObject:pkg forKey:pkg.identifier];
        // This dict containts ALL packages
        [self.packagesDict setObject:pkg forKey:pkg.identifier];
    }];
}

-(void)grabSourcesInLists {
    // Get new lines
    NSMutableArray *sourcesListLines = [NSMutableArray arrayWithArray:[[NSString stringWithContentsOfFile:@"/var/mobile/Documents/Lime/sources.list" encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]];
    
    [sourcesListLines enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *line = obj;
        if (line.length > 4 && [line containsString:@"deb"]) {
            // if it is a repo, then add it to a array with all the sources in the list
            [self.sourcesInList addObject:line];
        }
    }];
    [self grabFilenames];
}

-(void)grabFilenames {
    // Go over all the sources
    [self.sourcesInList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LMRepo *repo = [[LMRepo alloc] init];
        NSString *fileLine = obj;
        NSString *strippedFileLine = [fileLine substringFromIndex:4]; // removes "deb "
        // i separate the string into two parts: "https://an.example.repourl/" and "./" (or some kinda "stable main" like bigboss and modmyi do)
        NSInteger locationOfSpace = [strippedFileLine rangeOfString:@" "].location;
        // the actual url
        NSString *repoURL = [strippedFileLine substringToIndex:locationOfSpace];
        // either the "./" or "stable main" etc at the end
        NSString *repoDirectory = [strippedFileLine substringFromIndex:locationOfSpace + 1];
        repo.repoDirectory = repoDirectory;
        repo.repoURL = repoURL;
        // if it has custom distros
        if(![repoDirectory isEqualToString:@"./"]) {
            // EXAMPLE: http://apt.thebigboss.org/repofiles/cydia/ stable main
            if ([[repoURL substringFromIndex:[repoURL length] - 1] isEqualToString:@"/"]) {
                // if the last character of the url (http://apt.thebigboss.org/repofiles/cydia/) is / then remove it
                repoURL = [repoURL substringToIndex:repoURL.length - 1];
                // returns http://apt.thebigboss.org/repofiles/cydia
            }
            NSArray *repoComponents = [repoDirectory componentsSeparatedByString:@" "];
            repo.repoComponents = repoComponents;
            // stable and main in an array
            NSString *releaseURL = [NSString stringWithFormat:@"%@/dists/%@/Release",repoURL,[repoComponents objectAtIndex:0]];
            repo.releaseURL = releaseURL;
            // http://apt.thebigboss.org/repofiles/cydia/dists/stable/Release
            repo.releasePath = [NSString stringWithFormat:@"/var/mobile/Documents/Lime/lists/%@", [[[releaseURL stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
            // /var/mobile/Documents/Lime/lists/apt.thebigboss.org_repofiles_cydia_dists_stable_Release
            NSString *packagesURL = [NSString stringWithFormat:@"%@/dists/%@/%@/binary-iphoneos-arm/Packages",repoURL,[repoComponents objectAtIndex:0],[repoComponents objectAtIndex:1]];
            repo.packagesURL = packagesURL;
            // http://apt.thebigboss.org/repofiles/cydia/dists/stable/main/binary-iphoneos-arm/Packages
            repo.packagesPath = [NSString stringWithFormat:@"/var/mobile/Documents/Lime/lists/%@", [[packagesURL stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
            // /var/mobile/Documents/Lime/lists/apt.thebigboss.org_repofiles_cydia_dists_stable_main_binary-iphoneos-arm_Packages
        } else {
            // if it only has ./
            // EXAMPLE: https://repo.packix.com/ ./
            if (![[repoURL substringFromIndex:[repoURL length] - 1] isEqualToString:@"/"]) {
                // if the repo url (https://repo.packix.com/) doesnt have a /, then add one
                repoURL = [repoURL stringByAppendingString:@"/"];
            }
            repoURL = [repoURL stringByAppendingString:repoDirectory];
            // https://repo.packix.com/./
            repo.releaseURL = [NSString stringWithFormat:@"%@Release", repoURL];
            // https://repo.packix.com/./Release
            repo.releasePath = [NSString stringWithFormat:@"/var/mobile/Documents/Lime/lists/%@", [[[repo.releaseURL stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
            // /var/mobile/Documents/Lime/lists/repo.packix.com_._Release
            repo.packagesURL = [NSString stringWithFormat:@"%@Packages", repoURL];
            // https://repo.packix.com/./Packages
            repo.packagesPath = [NSString stringWithFormat:@"/var/mobile/Documents/Lime/lists/%@", [[repo.packagesURL stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
            // /var/mobile/Documents/Lime/lists/repo.packix.com_._Packages
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:repo.releasePath] && [[NSFileManager defaultManager] fileExistsAtPath:repo.packagesPath]) {
            // if it doesnt exist, scrap it
            [self.sources addObject:repo];
        } else {
            NSLog(@"Failed to add %@, does not exist.", repo.releasePath);
        }
    }];
    NSLog(@"Got %ld repositories", (long)self.sources.count);
    [self downloadRepos];
}

-(void)parseRepos {
    [self.sources enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LMRepo *repo = obj;
        // Parse the packages file
        LMPackageParser *parser = [[LMPackageParser alloc] initWithFilePath:repo.packagesPath];
        // Get all the lines of the release file
        NSMutableArray *releaseFileLines = [NSMutableArray arrayWithArray:[[NSString stringWithContentsOfFile:repo.releasePath encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]];
        [releaseFileLines enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // Self-explainatory
            if ([obj containsString:@"Origin:"]) {
                repo.origin = [[[obj componentsSeparatedByString:@"Origin: "] mutableCopy] objectAtIndex:1];
            } else if ([obj containsString:@"Label:"]) {
                repo.label = [[[obj componentsSeparatedByString:@"Label: "] mutableCopy] objectAtIndex:1];
            } else if ([obj containsString:@"Suite:"]) {
                repo.suite = [[[obj componentsSeparatedByString:@"Suite: "] mutableCopy] objectAtIndex:1];
            } else if ([obj containsString:@"Version:"]) {
                repo.version = [[[obj componentsSeparatedByString:@"Version: "] mutableCopy] objectAtIndex:1];
            } else if ([obj containsString:@"Codename:"]) {
                repo.codename = [[[obj componentsSeparatedByString:@"Codename: "] mutableCopy] objectAtIndex:1];
            } else if ([obj containsString:@"Architectures:"]) {
                repo.architectures = [[[obj componentsSeparatedByString:@"Architectures: "] mutableCopy] objectAtIndex:1];
            } else if ([obj containsString:@"Components:"]) {
                repo.components = [[[obj componentsSeparatedByString:@"Components: "] mutableCopy] objectAtIndex:1];
            } else if ([obj containsString:@"Description:"]) {
                repo.desc = [[[obj componentsSeparatedByString:@"Description: "] mutableCopy] objectAtIndex:1];
            }
        }];
        // Add repo to packages
        [parser.packages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LMPackage *pkg = obj;
            pkg.repository = repo;
            pkg.debURL = [NSString stringWithFormat:@"%@/%@", repo.repoURL, pkg.filename];
            if ([self.installedPackagesDict objectForKey:pkg.identifier]) {
                pkg.installed = YES;
            }
            [self.packagesDict setObject:pkg forKey:pkg.identifier];
            [parser.packages replaceObjectAtIndex:idx withObject:pkg];
        }];
        repo.packages = parser.packages;
        
        // Grab repo icons
        NSString *iconURL = repo.repoURL;
        if (![[repo.repoURL substringFromIndex:[repo.repoURL length] - 2] isEqualToString:@"./"])
            iconURL = [repo.repoURL stringByAppendingString:@"./"];
        // https://repo.packix.co/./
        repo.imageURL = [NSURL URLWithString:[iconURL stringByAppendingString:@"CydiaIcon.png"]];
        iconURL = [[[[iconURL stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""] stringByAppendingString:@"CydiaIcon.png"] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
        // repo.packix.co_._CydiaIcon.png
        repo.imagePath = [@"/var/mobile/Documents/Lime/icons/" stringByAppendingString:iconURL];
        repo.image = [UIImage imageWithContentsOfFile:repo.imagePath];
        
        [self.sources replaceObjectAtIndex:idx withObject:repo];
    }];
    [self addPackagesFromDictToAray];
}

-(void)downloadRepos {
    [self.sources enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LMRepo *repo = obj;
        NSString *iconURL = repo.repoURL;
        if (![[repo.repoURL substringFromIndex:[repo.repoURL length] - 2] isEqualToString:@"./"])
            iconURL = [repo.repoURL stringByAppendingString:@"./"];
        [self downloadRepoIconForURLString:[iconURL stringByAppendingString:@"CydiaIcon.png"]];
        [self downloadFileAtURL:repo.packagesURL writeToPath:repo.packagesPath completion:^(BOOL success) {
            if (!success) {
                [self.sources removeObjectAtIndex:idx];
            }
        }];
        [self downloadFileAtURL:repo.releaseURL writeToPath:repo.releasePath completion:^(BOOL success) {
            if (!success) {
                [self.sources removeObjectAtIndex:idx];
            }
        }];
    }];
    [self parseRepos];
}

-(void)addPackagesFromDictToAray {
    [self.packagesDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        LMPackage *pkg = obj;
        [self.packagesArray addObject:pkg];
    }];
    [self.installedPackagesDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        LMPackage *pkg = obj;
        [self.installedPackagesArray addObject:pkg];
    }];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    self.installedPackagesArray = [NSMutableArray arrayWithArray:[[self installedPackagesArray] sortedArrayUsingDescriptors:@[sort]]];
}

- (void)downloadRepoIconForURLString:(NSString *)urlString {
    NSString *filename = [NSString stringWithFormat:@"/var/mobile/Documents/Lime/icons/%@", [[[urlString stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
    [self downloadFileAtURL:urlString writeToPath:filename completion:nil];
}

- (void)downloadFileAtURL:(NSString *)url writeToPath:(NSString *)path completion:(downloadCompletion)completion {
    __block NSInteger responseCode;
    __block BOOL completed = NO;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    [request setValue:[DeviceInfo getUDID] forHTTPHeaderField:@"X-Cydia-ID"];
    [request setValue:@"Telesphoreo APT-HTTP/1.0.592" forHTTPHeaderField:@"User-Agent"];
    [request setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"X-Firmware"];
    [request setValue:[DeviceInfo getUDID] forHTTPHeaderField:@"X-Unique-ID"];
    [request setValue:[DeviceInfo machineID] forHTTPHeaderField:@"X-Machine"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        responseCode = httpResponse.statusCode;
        if(error || responseCode != 200) {
            NSLog(@"Status code: %ld\nError: %@",responseCode,[error localizedDescription]);
            // VERY VERY GOOD ERROR MESSAGE FOR THE USER SAYING THE REPOS MESSED UP GOES HERE
            // HOPE I DONT FORGET TO IMPLEMENT IT YES
            if(completion) completion(NO);
        } else {
            // download the source prolly
            [data writeToFile:path atomically:YES];
            if([[path substringFromIndex:path.length - 4] isEqualToString:@".bz2"]) {
                // we out there with the repos refreshing, ayy
                // we out there with an ui that looks refreshing
                // go follow @limeinstaller and your life will get better, ayy
                // we out there, we decompress the compression
                // (when u a programmer but also a rapper lmao)
                
                //[self bunzip_one:path];
            }
            if(completion) completion(YES);
        }
        completed = YES;
    }] resume];
    //while (CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true) && !completed) {};
}

-(void)refresh {
    self.packagesArray = [NSMutableArray new];
    self.packagesDict = [NSMutableDictionary new];
    self.installedPackagesArray = [NSMutableArray new];
    self.installedPackagesDict = [NSMutableDictionary new];
    self.sources = [[NSMutableArray alloc] init];
    self.sourcesInList = [[NSMutableArray alloc] init];
    [self getInstalledPackages];
    [self grabSourcesInLists];
}

+(UIImage*)iconFromPackage:(LMPackage *)package {
    UIImage *icon = [UIImage imageWithContentsOfFile:package.iconPath];
    return icon;
}

+(UIImage*)imageWithName:(NSString*)name {
    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Applications/Lime.app/%@.png", name]];
    return image;
}

+(BOOL)darkMode {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"];
}

+(void)setDarkMode:(BOOL)state {
    [[NSUserDefaults standardUserDefaults] setBool:state forKey:@"darkMode"];
}

+(NSString *)dpkgStatusLocation {
    #if !(TARGET_IPHONE_SIMULATOR)
        if ([[NSFileManager defaultManager] fileExistsAtPath:@"/bin/bash"]) {
            return @"/var/lib/dpkg/status";
        } else {
            return [[NSBundle mainBundle] pathForResource:@"status" ofType:@""];
        }
    #endif
    return [[NSBundle mainBundle] pathForResource:@"status" ofType:@""];
}

@end
