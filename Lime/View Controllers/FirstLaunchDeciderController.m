//
//  FirstLaunchDeciderController.m
//  Lime
//
//  Created by EvenDev on 21/09/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "FirstLaunchDeciderController.h"

@interface FirstLaunchDeciderController ()

@end

@implementation FirstLaunchDeciderController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"] == YES) {
        NSLog(@" first");
        [self performSegueWithIdentifier:@"firstLaunch" sender:self];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
}

-(void)showBannerWithMessage:(NSString *)message type:(NSUInteger)type target:(id)target selector:(SEL)selector {
    LMInfoBanner *banner = [[LMInfoBanner alloc] initWithMessage:message type:type target:target selector:selector];
    banner.frame = CGRectMake(16, self.tabBar.frame.origin.y - 16 - banner.frame.size.height, banner.frame.size.width, banner.frame.size.height);
    [self.view addSubview:banner];
    banner.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        banner.alpha = 1;
    }];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.1 animations:^{
            banner.alpha = 0;
        } completion:^(BOOL finished) {
            [banner removeFromSuperview];
        }];
    });
}

@end
