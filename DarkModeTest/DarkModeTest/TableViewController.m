//
//  TableViewController.m
//  DarkModeTest
//
//  Created by Even Flatabø on 02/02/2020.
//  Copyright © 2020 EvenDev. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme) name:@"darkMode" object:nil];
    
    self.tableView.backgroundColor = [UIColor limeBackgroundColor];
    self.darkModeToggle.on = [NSUserDefaults.standardUserDefaults boolForKey:@"darkMode"];
    self.followSystemToggle.on = [NSUserDefaults.standardUserDefaults boolForKey:@"followSystem"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([NSUserDefaults.standardUserDefaults boolForKey:@"followSystem"]) {
        [NSUserDefaults.standardUserDefaults setBool:(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) forKey:@"darkMode"];
    }
}

-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    if ([NSUserDefaults.standardUserDefaults boolForKey:@"followSystem"]) {
        [self.darkModeToggle setOn:(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) animated:YES];
        [NSUserDefaults.standardUserDefaults setBool:(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) forKey:@"darkMode"];
        [self updateTheme];
    }
}

- (IBAction)darkModeChanged:(id)sender {
    [NSUserDefaults.standardUserDefaults setBool:self.darkModeToggle.on forKey:@"darkMode"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"darkMode" object:self];
}

- (IBAction)followSystemChanged:(id)sender {
    [NSUserDefaults.standardUserDefaults setBool:self.followSystemToggle.on forKey:@"followSystem"];
    if (self.followSystemToggle.on) {
        [self.darkModeToggle setOn:(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) animated:YES];
        [NSUserDefaults.standardUserDefaults setBool:(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) forKey:@"darkMode"];
    }
}

- (void)updateTheme {
    [self.tableView reloadData];
    self.tableView.backgroundColor = [UIColor limeBackgroundColor];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.fillMode = kCAFillModeForwards;
    transition.duration = 0.5;
    transition.subtype = kCATransitionFromTop;
    [self.view.layer addAnimation:transition forKey:nil];
    [self.tableView.layer addAnimation:transition forKey:@"UITableViewReloadDataAnimationKey"];
}

@end
