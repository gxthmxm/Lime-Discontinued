//
//  LMRepoParser.h
//  Lime
//
//  Created by Even Flatabø on 28/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Objects/LMRepo.h"
#import "../Objects/LMPackage.h"
#import "LMPackageParser.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMRepoParser : NSObject

+(LMRepo *)parseRepo:(LMRepo *)repo;

@end

NS_ASSUME_NONNULL_END
