//
//  LimeHelper.h
//  Lime
//
//  Created by EvenDev on 24/06/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LMRepository : NSObject

@property (nonatomic, strong) NSString *origin;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *suite;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *codename;
@property (nonatomic, strong) NSArray *architectures;
@property (nonatomic, strong) NSArray *components;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSURL *repoURL;
@property (nonatomic, strong) NSURL *iconURL;
@property (nonatomic, strong) NSString *packageFileName;
@property (nonatomic, strong) NSString *releaseFileName;
@property (nonatomic, strong) NSString *installedPackageFileName;
@property (nonatomic, strong) NSString *installedReleaseFileName;
@property (nonatomic, strong) NSMutableDictionary *packages;
@property (nonatomic) BOOL defaultRepo;
@property (nonatomic) BOOL removable;

@end

@interface LMPackage : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *section;
@property (nonatomic, strong) NSString *iconPath;
@property (nonatomic, strong) NSString *architecture;
@property (nonatomic, strong) NSURL *depictionURL;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSArray *dependencies;
@property (nonatomic, strong) NSArray *conflicts;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *maintainer;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *installedSize;
@property (nonatomic) BOOL commercial;
@property (nonatomic) BOOL ignoreUpgrades;
@property (nonatomic) BOOL installed;
@property (nonatomic) NSUInteger* possibleActions;
@property (nonatomic, strong) NSData* installedDate;

@end

@interface LMQueueAction : NSObject

@property (nonatomic) NSInteger action;
@property (nonatomic, strong) LMPackage *package;

+(LMQueueAction*)newActionWithPackage:(LMPackage*)package action:(NSInteger)action;

@end

@interface LMQueue : NSObject

@property (nonatomic, strong) NSArray *actions;

+(void)addQueueAction:(LMQueueAction*)action;
+(NSArray*)queueActions;

@end

@interface LimeHelper : NSObject

+(LMPackage*)packageWithIdentifier:(NSString*)identifier;
+(UIImage*)iconFromPackage:(LMPackage*)package;
+(UIImage*)imageWithName:(NSString*)name;

@end
