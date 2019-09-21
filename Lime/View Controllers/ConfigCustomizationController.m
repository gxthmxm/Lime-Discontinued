//
//  ConfigControllers.m
//  Lime
//
//  Created by EvenDev on 30/05/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "ConfigCustomizationController.h"

@implementation ConfigCustomizationController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        [self makeDarkMode];
    } else {
        [self makeLightMode];
    }
}

- (IBAction)turnLight:(id)sender {[self makeLightMode];}
- (IBAction)turnDark:(id)sender {[self makeDarkMode];}

-(void)makeDarkMode {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"darkMode"];
    [self.darkToggle setImage:[LimeHelper imageWithName:@"check"]];
    [self.lightToggle setImage:[UIImage new]];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.darkText.textColor = [UIColor whiteColor];
        self.lightText.textColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barStyle = 1;
        self.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

-(void)makeLightMode {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"darkMode"];
    [self.lightToggle setImage:[LimeHelper imageWithName:@"check"]];
    [self.darkToggle setImage:[UIImage new]];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.darkText.textColor = [UIColor blackColor];
        self.lightText.textColor = [UIColor blackColor];
        self.navigationController.navigationBar.barStyle = 0;
        self.view.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }];
}

- (IBAction)dismissController:(id)sender {[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];}

@end
