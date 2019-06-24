//
//  ConfigControllers.m
//  Lime
//
//  Created by EvenDev on 30/05/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "ConfigControllers.h"

@implementation FirstLaunchDeciderController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"] == YES) {
        NSLog(@" first");
        [self performSegueWithIdentifier:@"firstLaunch" sender:self];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    } else {
        [self performSegueWithIdentifier:@"normalLaunch" sender:self];
        NSLog(@"not first");
    }
}

@end

@implementation ConfigStartController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

@end

@implementation ConfigRepoController

@end

@implementation ConfigSelectRepoController

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end

@implementation ConfigCustomizationController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)turnLight:(id)sender {[self makeLightMode];}
- (IBAction)turnDark:(id)sender {[self makeDarkMode];}

-(void)makeDarkMode {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"darkMode"];
    [self.darkToggle setImage:[UIImage imageNamed:@"Checkmark"]];
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
    [self.lightToggle setImage:[UIImage imageNamed:@"Checkmark"]];
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
