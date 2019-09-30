//
//  FirstLaunchDeciderController.h
//  Lime
//
//  Created by EvenDev on 21/09/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Lime.h"
#import "../UI Elements/LMInfoBanner.h"

NS_ASSUME_NONNULL_BEGIN

@interface FirstLaunchDeciderController : UITabBarController

-(void)showBannerWithMessage:(NSString *)message type:(NSUInteger)type target:(id)target selector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
