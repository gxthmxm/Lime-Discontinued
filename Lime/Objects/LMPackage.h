//
//  LMPackage.h
//  Lime
//
//  Created by EvenDev on 21/09/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMRepo.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMPackage : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *section;
@property (nonatomic, strong) NSString *iconPath;
@property (nonatomic, strong) NSString *architecture;
@property (nonatomic, strong) NSString *depictionURL;
@property (nonatomic, strong) NSString *tags;
@property (nonatomic, strong) NSString *dependencies;
@property (nonatomic, strong) NSArray *conflicts;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *maintainer;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSString *sileoDepiction;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *installedSize;
@property (nonatomic, strong) NSString *debURL;
@property (nonatomic, strong) LMRepo *repository;
@property (nonatomic) BOOL commercial;
@property (nonatomic) BOOL ignoreUpgrades;
@property (nonatomic) BOOL installed;
@property (nonatomic) NSUInteger* possibleActions;
@property (nonatomic, strong) NSData* installedDate;

@end

NS_ASSUME_NONNULL_END
