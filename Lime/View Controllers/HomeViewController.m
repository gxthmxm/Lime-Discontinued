//
//  HomeViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (IBAction)closeCard:(UIButton *)sender {
    UIView *card = sender.superview.superview.superview;
    [sender.superview.superview.superview removeFromSuperview];
    [self.scrollView addSubview:card];
    [UIView animateWithDuration:0.2 animations:^{
        card.frame = CGRectMake(20, 96, self.scrollView.frame.size.width - 40, 411);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openCard:)];
    [self.cardOne addGestureRecognizer:tap];
}

- (void)openCard:(UITapGestureRecognizer*)sender {
    [sender.view removeFromSuperview];
    [self.tabBarController.view addSubview:sender.view];
    sender.view.frame = CGRectMake(sender.view.frame.origin.x, sender.view.frame.origin.y + 20, sender.view.frame.size.width, sender.view.frame.size.height);
    [UIView animateWithDuration:0.1 animations:^{
        sender.view.transform = CGAffineTransformScale(sender.view.transform, 0.96, 0.96);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            sender.view.transform = CGAffineTransformScale(sender.view.transform, 1.04, 1.04);
            sender.view.frame = CGRectMake(20, -20, sender.view.frame.size.width, sender.view.frame.size.height);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                sender.view.frame = CGRectMake(0, 0, sender.view.frame.size.width + 40, sender.view.frame.size.height + 40);
            } completion:^(BOOL finished) {
                [sender.view.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer *obj, NSUInteger idx, BOOL *stop) {
                    [sender.view removeGestureRecognizer:obj];
                }];
            }];
        }];
    }];
    [UIView animateWithDuration:0.9 animations:^{
        sender.view.layer.cornerRadius = 0;
    }];
}


- (void)handleLongPress:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            sender.view.transform = CGAffineTransformScale(sender.view.transform, 1.04, 1.04);
        }];
    }
    else if (sender.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.2 animations:^{
            sender.view.transform = CGAffineTransformScale(sender.view.transform, 0.96, 0.96);
        }];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController setNavigationBarHidden:YES];
    self.navigationController.navigationBar.barStyle = 1;
    if ([LimeHelper darkMode]) {
        self.tabBarController.tabBar.barStyle = 1;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        self.view.backgroundColor = [LMColor backgroundColor];
    }
}

/*-(void)drawQueueView {
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
}*/

@end
