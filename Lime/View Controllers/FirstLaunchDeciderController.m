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

@end
