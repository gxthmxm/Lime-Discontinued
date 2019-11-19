//
//  LMHomeStoryDownloader.h
//  Lime
//
//  Created by Even Flatabø on 19/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LMTweakOfTheWeekCell.h"
#import "LMThemeOfTheWeekCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMHomeStoryDownloader : NSObject

+(void)downloadTweakOfTheWeek:(NSDictionary *)json toArray:(NSMutableArray *)array;
+(void)downloadThemeOfTheWeek:(NSDictionary *)json toArray:(NSMutableArray *)array;

@end

NS_ASSUME_NONNULL_END
