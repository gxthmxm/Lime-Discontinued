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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openCardOne:)];
    [self.cardOne addGestureRecognizer:tap];
    self.cardOne.layer.cornerRadius = 15;
    
    NSDateFormatter *dateFormattor = [NSDateFormatter new];
    dateFormattor.dateFormat = @"EEEE d MMMM";
    self.dateLabel.text = [[dateFormattor stringFromDate:[NSDate date]] uppercaseString];
    
    [self grabStories];
}

-(void)grabStories {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://evendev.org/lime/story/stories.json"]];
    self.stories = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (self.stories) {
        // Card 1
        NSDictionary *firstCard = [self.stories objectForKey:@"card-1"];
        NSData *bgImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *)[firstCard valueForKey:@"background-image"]]];
        self.cardOne.backgroundView.image = [UIImage imageWithData:bgImage];
        
        NSData *fgImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *)[firstCard valueForKey:@"foreground-image"]]];
        self.cardOne.foregroundView.image = [UIImage imageWithData:fgImage];
        
        NSData *icon = [NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *)[firstCard valueForKey:@"package-icon"]]];
        self.cardOne.iconView.image = [UIImage imageWithData:icon];
        
        self.cardOne.packageTitle.text = [firstCard valueForKey:@"package-name"];
        self.cardOne.storyURL = [firstCard valueForKey:@"story"];
        self.cardOne.packageDescription.text = [firstCard valueForKey:@"package-desc"];
        self.cardOne.packageIdentifier = [firstCard valueForKey:@"package-identifier"];
        self.cardOne.titleLabel.text = [firstCard valueForKey:@"title"];
        self.cardOne.repository = [firstCard valueForKey:@"repository"];
    }
}

- (void)openCardOne:(UITapGestureRecognizer*)sender {
    StoryController *controller = [[StoryController alloc] init];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.cardOne];
    THOTWCard *card = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    controller.topView = card;
    controller.storyURL = [NSURL URLWithString:self.cardOne.storyURL];
    [self presentViewController:controller animated:YES completion:nil];
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
        self.dateLabel.textColor = [LMColor labelColor];
        self.todayLabel.textColor = [LMColor labelColor];
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
