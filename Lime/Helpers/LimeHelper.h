//
//  LimeHelper.h
//  Lime
//
//  Created by EvenDev on 24/06/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSTask.h"
#import "../Lime.h"
#import "../Settings.h"
#import "../View Controllers/FirstLaunchDeciderController.h"

@interface LimeHelper : NSObject <NSURLSessionDelegate>

@property (nonatomic, retain) NSMutableDictionary *packagesDict;
@property (nonatomic, retain) NSMutableArray *packagesArray;
@property (nonatomic, retain) NSMutableDictionary *installedPackagesDict;
@property (nonatomic, retain) NSMutableArray *installedPackagesArray;
@property (nonatomic, retain) NSMutableArray *sourcesInList;
@property (nonatomic, retain) NSMutableArray *sources;

+(id)sharedInstance;
-(id)init;
-(void)getInstalledPackages;
-(void)grabSourcesInLists;
-(void)grabFilenames;
-(void)parseRepos;
-(void)downloadRepos;
-(void)addPackagesFromDictToAray;
- (void)downloadRepoIconForURLString:(NSString *)urlString;
-(void)refresh;

+(UIImage*)iconFromPackage:(LMPackage*)package;
+(UIImage*)imageWithName:(NSString*)name;

+(BOOL)darkMode;
+(void)setDarkMode:(BOOL)state;

+(NSString *)dpkgStatusLocation;

typedef void(^downloadCompletion)(BOOL);
- (void)downloadFileAtURL:(NSString *)url writeToPath:(NSString *)path completion:(downloadCompletion)completion;

@end
