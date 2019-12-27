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

@end
