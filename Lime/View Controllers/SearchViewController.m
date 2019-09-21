//
//  SearchViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([LimeHelper darkMode]) {
        self.tableView.backgroundColor = [LMColor backgroundColor];
        self.tableView.separatorColor = [LMColor separatorColor];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
        self.tabBarController.tabBar.barStyle = 1;
    }
}

@end
