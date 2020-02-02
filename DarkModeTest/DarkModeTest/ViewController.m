//
//  ViewController.m
//  DarkModeTest
//
//  Created by Even Flatabø on 02/02/2020.
//  Copyright © 2020 EvenDev. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme) name:@"darkMode" object:nil];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor limeBackgroundColor];
}

- (void)updateTheme {
    self.view.backgroundColor = [UIColor limeBackgroundColor];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.fillMode = kCAFillModeForwards;
    transition.duration = 0.5;
    transition.subtype = kCATransitionFromTop;
    [self.view.layer addAnimation:transition forKey:nil];
    [self.navigationController.navigationBar.layer addAnimation:transition forKey:nil];
}

@end
