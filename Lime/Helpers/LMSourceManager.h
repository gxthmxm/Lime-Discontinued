//
//  LMSourceManager.h
//  Lime
//
//  Created by Even Flatabø on 11/12/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Objects/LMRepo.h"
#import "../Objects/LMPackage.h"
#import "LimeHelper.h"
#import "../Parsers/LMRepoParser.h"
#import "LMSourceDownloader.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMSourceManager : NSObject

+ (id)sharedInstance;

@property (nonatomic, strong) NSMutableArray *sources;

@end

NS_ASSUME_NONNULL_END
