//
//  LimeHelper.m
//  Lime
//
//  Created by Even Flatabø on 18/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LimeHelper.h"

extern char **environ;

@implementation LimeHelper

+ (NSString *)documentDirectory {
    if ([LMDeviceInfo isJailbroken]) {
        return @"/var/mobile/Documents/Lime/";
    } else {
        return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/"];
    }
}

+ (NSString *)dpkgStatusLocation {
    #if !(TARGET_IPHONE_SIMULATOR)
        if ([LMDeviceInfo isJailbroken]) {
            return @"/var/lib/dpkg/status";
        } else {
            return [[NSBundle mainBundle] pathForResource:@"status" ofType:@""];
        }
    #else
        return [[NSBundle mainBundle] pathForResource:@"status" ofType:@""];
    #endif
}

+ (id)sharedInstance {
    static LimeHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    
    return instance;
}

+ (NSString *)limePath {
    return @"/var/mobile/Documents/Lime/";
}
+ (NSString *)sourcesPath {
    return [[self limePath] stringByAppendingString:@"sources.list"];
}
+ (NSString *)listsPath {
    return [[self limePath] stringByAppendingString:@"lists/"];
}
+ (NSString *)iconsPath {
    return [[self limePath] stringByAppendingString:@"icons/"];
}
+ (NSString *)tmpPath {
    return [[self limePath] stringByAppendingString:@"tmp/"];
}

+ (NSMutableURLRequest *)mutableURLRequestWithHeadersWithURLString:(NSString *)URLString {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0];
    [request setValue:@"Cydia/0.9 CFNetwork/978.0.7 Darwin/18.7.0" forHTTPHeaderField:@"User-Agent"];
    [request setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"X-Firmware"];
    [request setValue:[LMDeviceInfo deviceName] forHTTPHeaderField:@"X-Machine"];
    [request setValue:[LMDeviceInfo udid] forHTTPHeaderField:@"X-Unique-ID"];
    return request;
}

-(id)init {
    self = [super init];
    if (self) {
        self.packagesArray = [NSMutableArray new];
        self.packagesDict = [NSMutableDictionary new];
        self.installedPackagesArray = [NSMutableArray new];
        self.installedPackagesDict = [NSMutableDictionary new];
        self.defaultNavigationController = [[UINavigationController alloc] initWithRootViewController:[UIViewController new]];
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:[LimeHelper limePath] isDirectory:nil]) [[NSFileManager defaultManager] createDirectoryAtPath:[LimeHelper limePath] withIntermediateDirectories:YES attributes:nil error:nil];
        if(![[NSFileManager defaultManager] fileExistsAtPath:[LimeHelper listsPath] isDirectory:nil]) [[NSFileManager defaultManager] createDirectoryAtPath:[LimeHelper listsPath] withIntermediateDirectories:YES attributes:nil error:nil];
        if(![[NSFileManager defaultManager] fileExistsAtPath:[LimeHelper iconsPath] isDirectory:nil]) [[NSFileManager defaultManager] createDirectoryAtPath:[LimeHelper iconsPath] withIntermediateDirectories:YES attributes:nil error:nil];
        if(![[NSFileManager defaultManager] fileExistsAtPath:[LimeHelper sourcesPath] isDirectory:nil]) [[NSFileManager defaultManager] createFileAtPath:[LimeHelper sourcesPath] contents:[@"deb https://repo.dynastic.co/ ./" dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        
        [self getInstalledPackages];
    }
    return self;
}

+(void)respringDevice {
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/killall"];
    [task setArguments:@[@"-9", @"SpringBoard"]];
        
    NSMutableDictionary *defaultEnv = [[NSMutableDictionary alloc] initWithDictionary:[[NSProcessInfo processInfo] environment]];
    [defaultEnv setObject:@"YES" forKey:@"NSUnbufferedIO"] ;
    task.environment = defaultEnv;
        
    NSPipe *stdoutPipe = [NSPipe pipe];
    task.standardOutput = stdoutPipe;
    NSPipe *stderrPipe = [NSPipe pipe];
    task.standardError = stderrPipe;
    [task launch];
}

+(void)runLemonWithArguments:(NSArray *)args textView:(UITextView *)textView completionHandler:(nullable void(^)(NSTask *task))completionHandler {
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/lemon"];
    [task setArguments:args];
    task.terminationHandler = ^(NSTask *task){
        if (completionHandler) completionHandler(task);
    };
        
    NSMutableDictionary *defaultEnv = [[NSMutableDictionary alloc] initWithDictionary:[[NSProcessInfo processInfo] environment]];
    [defaultEnv setObject:@"YES" forKey:@"NSUnbufferedIO"] ;
    task.environment = defaultEnv;
        
    NSPipe *stdoutPipe = [NSPipe pipe];
    task.standardOutput = stdoutPipe;
    NSPipe *stderrPipe = [NSPipe pipe];
    task.standardError = stderrPipe;
    if (textView) {
        [[task.standardOutput fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
            NSData *data = [file availableData];
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
            dispatch_async(dispatch_get_main_queue(), ^(void){
                textView.text = [textView.text stringByAppendingString:string];
                [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 0)];
            });
        }];
        [[task.standardError fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
            NSData *data = [file availableData];
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
            dispatch_async(dispatch_get_main_queue(), ^(void){
                textView.text = [textView.text stringByAppendingString:string];
                [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 0)];
            });
        }];
    }
    [task launch];
}

-(void)getInstalledPackages {
    // Inits a parser on the dpkg status file
    LMPackageParser *parser = [[LMPackageParser alloc] initWithFilePath:[LimeHelper dpkgStatusLocation] repository:nil];
    [parser.packages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // Add all the packages to dictionaries
        LMPackage *pkg = obj;
        // This dict only has the installed packages
        [self.installedPackagesDict setObject:pkg forKey:pkg.identifier];
        // This dict containts ALL packages
        [self.packagesDict setObject:pkg forKey:pkg.identifier];
    }];
    [self addPackagesToArrays];
}

-(void)addPackagesToArrays {
    self.installedPackagesArray = [NSMutableArray arrayWithArray:self.installedPackagesDict.allValues];
    self.packagesArray = [NSMutableArray arrayWithArray:self.packagesDict.allValues];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    self.installedPackagesArray = [NSMutableArray arrayWithArray:[[self installedPackagesArray] sortedArrayUsingDescriptors:@[sort]]];
    self.packagesArray = [NSMutableArray arrayWithArray:[self.packagesArray sortedArrayUsingDescriptors:@[sort]]];
}

-(void)refreshInstalledPackages {
    self.installedPackagesArray = [NSMutableArray new];
    self.installedPackagesDict = [NSMutableDictionary new];
    [self getInstalledPackages];
}

+(void)removeRepo:(LMRepo *)repo {
    NSString *sourcesList = [NSString stringWithContentsOfFile:LimeHelper.sourcesPath encoding:NSUTF8StringEncoding error:nil];
    if (sourcesList.length > 0) {
        NSMutableArray *array = [sourcesList componentsSeparatedByCharactersInSet:NSCharacterSet.newlineCharacterSet].mutableCopy;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *line = obj;
            if ([line containsString:repo.rawRepo.repoURL]) [array removeObjectAtIndex:idx];
        }];
        NSString *newSourcesList = [array componentsJoinedByString:@"\n"];
        [newSourcesList writeToFile:LimeHelper.sourcesPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

+(LMRepo *)rawRepoWithDebLine:(NSString *)line {
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
            repo.rawRepo.packagesPath = [NSString stringWithFormat:@"/var/mobile/Documents/Lime/lists/%@", [[[repo.rawRepo.packagesURL stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
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
            repo.rawRepo.packagesPath = [NSString stringWithFormat:@"/var/mobile/Documents/Lime/lists/%@", [[[repo.rawRepo.packagesURL stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
            // /var/mobile/Documents/Lime/lists/repo.packix.com_._Packages
        }
        repo.rawRepo.imageURL = [repo.rawRepo.releaseURL stringByReplacingOccurrencesOfString:@"Release" withString:@"CydiaIcon.png"];
        repo.rawRepo.imagePath = [NSString stringWithFormat:@"/var/mobile/Documents/Lime/icons/%@", [[[repo.rawRepo.imageURL stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
        return repo;
    } else return nil;
}

@end
