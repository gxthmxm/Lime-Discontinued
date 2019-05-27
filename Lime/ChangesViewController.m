//
//  ChangesViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "ChangesViewController.h"

@interface ChangesViewController ()

@end

@implementation ChangesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        self.tableView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
        self.tableView.separatorColor = [UIColor colorWithRed:0.235 green:0.235 blue:0.235 alpha:1];
        self.navigationController.navigationBar.barStyle = 1;
    }
}

@end
