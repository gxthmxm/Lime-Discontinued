//
//  LimeHelper.h
//  Lime
//
//  Created by Even Flatabø on 18/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LMDeviceInfo.h"
#import "../Parsers/LMPackageParser.h"

NS_ASSUME_NONNULL_BEGIN

@interface LimeHelper : NSObject

+ (id)sharedInstance;

+ (NSString *)documentDirectory;
+ (NSString *)dpkgStatusLocation;

@property (nonatomic, retain) NSMutableDictionary *packagesDict;
@property (nonatomic, retain) NSMutableArray *packagesArray;
@property (nonatomic, retain) NSMutableDictionary *installedPackagesDict;
@property (nonatomic, retain) NSMutableArray *installedPackagesArray;
@property (nonatomic, retain) NSMutableArray *sourcesInList;
@property (nonatomic, retain) NSMutableArray *sources;
@property (nonatomic, retain) UINavigationController *defaultNavigationController;

@end

NS_ASSUME_NONNULL_END
