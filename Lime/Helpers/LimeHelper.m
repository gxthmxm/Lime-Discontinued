//
//  LimeHelper.m
//  Lime
//
//  Created by Even Flatabø on 18/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LimeHelper.h"

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
    [self addPackagesToArrays];
}

-(void)addPackagesToArrays {
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

@end
