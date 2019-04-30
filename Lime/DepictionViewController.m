//
//  ChangesViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "DepictionViewController.h"

@interface DepictionViewController ()
@end

@implementation DepictionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _scrollView.contentSize = [UIScreen mainScreen].bounds.size;
    NSLog(@"%@", self.navigationController.navigationBar.barTintColor);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    self.navigationController.navigationBar.shadowImage = nil;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault]; 
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1];
}
/*

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint scrollOffset = scrollView.contentOffset;
    if (scrollOffset.y >= 40) {
        if (![self.navigationController isNavigationBarHidden]) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    } else {
        if ([self.navigationController isNavigationBarHidden]) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
    }
}
 */

@end
