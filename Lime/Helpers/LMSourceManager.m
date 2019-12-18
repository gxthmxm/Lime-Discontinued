//
//  LMSourceManager.m
//  Lime
//
//  Created by Even Flatabø on 11/12/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMSourceManager.h"

@implementation LMSourceManager

+ (id)sharedInstance {
    static LMSourceManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ instance = [self new]; });
    return instance;
}

-(id)init {
    self = [super init];
    if (self) {
        NSLog(@"[SourceManager] Starting init");
        
        self.sources = [NSMutableArray new];
        [self getRawSources];
        [self parseSourcesAndDownloadMissing:YES];
        
        NSLog(@"[SourceManager] Init done. Got %lu source(s)", (unsigned long)self.sources.count);
    }
    return self;
}

-(void)getRawSources {
    // Get all the lines of the Sources.list
    NSMutableArray *sourcesListLines = [NSMutableArray arrayWithArray:[[NSString stringWithContentsOfFile:[LimeHelper sourcesPath] encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]];
    [sourcesListLines enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // Example: deb https://evendev.org/repo/ ./
        NSString *line = obj;
        if (line.length > 4 && [line containsString:@"deb"]) {
            LMRepo *repo = [LMRepo new];
            // remove "deb ", returns "https://evendev.org/repo/ ./"
            line = [line substringFromIndex:4];
            // i separate the string into two parts: "https://an.example.repourl/" and "./" (or some kinda "stable main" like bigboss and modmyi do)
            NSInteger locationOfSpace = [line rangeOfString:@" "].location;
            // the actual url
            NSString *repoURL = [line substringToIndex:locationOfSpace];
            // either the "./" or "stable main" etc at the end
            NSString *repoDirectory = [line substringFromIndex:locationOfSpace + 1];
            NSArray *distrosArray = [repoDirectory componentsSeparatedByString:@" "];
            repo.rawRepo.distros = repoDirectory;
            repo.rawRepo.distrosArray = distrosArray;
            repo.rawRepo.repoURL = repoURL;
            
            // if it has custom distros
            if(![repoDirectory isEqualToString:@"./"]) {
                // EXAMPLE: http://apt.thebigboss.org/repofiles/cydia/ stable main
                if ([[repoURL substringFromIndex:[repoURL length] - 1] isEqualToString:@"/"]) {
                    // if the last character of the url (http://apt.thebigboss.org/repofiles/cydia/) is / then remove it
                    repoURL = [repoURL substringToIndex:repoURL.length - 1];
                    // returns http://apt.thebigboss.org/repofiles/cydia
                }
                repo.rawRepo.releaseURL = [NSString stringWithFormat:@"%@/dists/%@/Release", repoURL, [distrosArray objectAtIndex:0]];
                // http://apt.thebigboss.org/repofiles/cydia/dists/stable/Release
                repo.rawRepo.releasePath = [NSString stringWithFormat:@"/var/mobile/Documents/Lime/lists/%@", [[[repo.rawRepo.releaseURL stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
                // /var/mobile/Documents/Lime/lists/apt.thebigboss.org_repofiles_cydia_dists_stable_Release
                repo.rawRepo.packagesURL = [NSString stringWithFormat:@"%@/dists/%@/%@/binary-iphoneos-arm/Packages", repoURL, [distrosArray objectAtIndex:0], [distrosArray objectAtIndex:1]];
                // http://apt.thebigboss.org/repofiles/cydia/dists/stable/main/binary-iphoneos-arm/Packages
                repo.rawRepo.packagesPath = [NSString stringWithFormat:@"/var/mobile/Documents/Lime/lists/%@", [[repo.rawRepo.packagesURL stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
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
                repo.rawRepo.releaseURL = [NSString stringWithFormat:@"%@Release", repoURL];
                // https://repo.packix.com/./Release
                repo.rawRepo.releasePath = [NSString stringWithFormat:@"/var/mobile/Documents/Lime/lists/%@", [[[repo.rawRepo.releaseURL stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
                // /var/mobile/Documents/Lime/lists/repo.packix.com_._Release
                repo.rawRepo.packagesURL = [NSString stringWithFormat:@"%@Packages", repoURL];
                // https://repo.packix.com/./Packages
                repo.rawRepo.packagesPath = [NSString stringWithFormat:@"/var/mobile/Documents/Lime/lists/%@", [[repo.rawRepo.packagesURL stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
                // /var/mobile/Documents/Lime/lists/repo.packix.com_._Packages
            }
            repo.rawRepo.imageURL = [repo.rawRepo.releaseURL stringByReplacingOccurrencesOfString:@"Release" withString:@"CydiaIcon.png"];
            repo.rawRepo.imagePath = [NSString stringWithFormat:@"/var/mobile/Documents/Lime/icons/%@", [[repo.rawRepo.imageURL stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
            [self.sources addObject:repo];
        }
    }];
}

-(void)parseSourcesAndDownloadMissing:(BOOL)download {
    [self.sources enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block LMRepo *repo = obj;
        if ([NSFileManager.defaultManager fileExistsAtPath:repo.rawRepo.packagesPath] && [NSFileManager.defaultManager fileExistsAtPath:repo.rawRepo.releasePath]) {
            NSLog(@"[SourceManager] Parsing %@", repo.rawRepo.repoURL);
            repo = [LMRepoParser parseRepo:repo];
            LMPackageParser *parser = [[LMPackageParser alloc] initWithFilePath:repo.rawRepo.packagesPath];
            repo.packages = parser.packages;
            [self.sources replaceObjectAtIndex:idx withObject:repo];
        } else {
            if (download) {
                NSLog(@"[SourceManager] Downloading %@", repo.rawRepo.repoURL);
                LMSourceDownloader *sourceDL = [[LMSourceDownloader alloc] initWithRepo:repo];
                [sourceDL downloadRepoAndIcon:![NSFileManager.defaultManager fileExistsAtPath:repo.rawRepo.imagePath] completionHandler:^{
                    NSLog(@"[SourceManager] Parsing %@", repo.rawRepo.repoURL);
                    repo = [LMRepoParser parseRepo:repo];
                    LMPackageParser *parser = [[LMPackageParser alloc] initWithFilePath:repo.rawRepo.packagesPath];
                    repo.packages = parser.packages;
                    [self.sources replaceObjectAtIndex:idx withObject:repo];
                }];
            }
        }
    }];
}

-(void)refreshSources {
    self.sources = [NSMutableArray new];
    [self getRawSources];
    __block NSUInteger tasks = self.sources.count;
    __block int completedTasks = 0;
    [self.sources enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        tasks++;
        __block LMRepo *repo = obj;
        NSLog(@"[SourceManager] Downloading %@", repo.rawRepo.repoURL);
        LMSourceDownloader *sourceDL = [[LMSourceDownloader alloc] initWithRepo:repo];
        [sourceDL downloadRepoAndIcon:YES completionHandler:^{
            completedTasks++;
            if (completedTasks == tasks) [self parseSourcesAndDownloadMissing:NO];
        }];
    }];
}

@end