//
//  HomeViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "HomeViewController.h"
#import "InstallationController.h"
#import <QuartzCore/QuartzCore.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"HTML/index" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:htmlString baseURL:[[NSBundle mainBundle] bundleURL]];
}

-(void)updateQueue {
    UIView* queueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 140, 44)];
    [queueView.layer setCornerRadius:10];
    queueView.layer.masksToBounds = YES;
    
    UIView* shadowView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 140 / 2, [UIScreen mainScreen].bounds.size.height - 110, 140, 44)];
    shadowView.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2] CGColor];
    shadowView.layer.shadowRadius = 10;
    shadowView.layer.shadowOffset = CGSizeMake(0, 2);
    shadowView.layer.shadowOpacity = 1;
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView* queueSView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    queueSView.frame = CGRectMake(0, 0, 140, 44);
    
    UIButton *queueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [queueButton setTitle:@"Queue" forState:UIControlStateNormal];
    [queueButton setTitleColor:self.tabBarController.view.tintColor forState:UIControlStateNormal];
    queueButton.frame = CGRectMake(0, 0, 140, 44);
    
    [queueView addSubview:queueSView];
    [queueView addSubview:queueButton];
    [shadowView addSubview:queueView];
    //if (self.queueArray != nil) {
        [self.tabBarController.view addSubview:shadowView];
    //}
}

@end
