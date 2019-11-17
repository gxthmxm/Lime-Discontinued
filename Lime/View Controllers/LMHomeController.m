//
//  LMHomeController.m
//  Lime
//
//  Created by Even Flatabø on 16/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMHomeController.h"

@interface LMHomeController ()

@end

@implementation LMHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.extendedLayoutIncludesOpaqueBars = NO;
    [self.navigationController setNavigationBarHidden:YES];
    
    /*UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openCardOne:)];
    [self.cardOne addGestureRecognizer:tap];*/
    self.cardOne.layer.cornerRadius = 15;
    
    NSDateFormatter *dateFormattor = [NSDateFormatter new];
    dateFormattor.dateFormat = @"EEEE d MMMM";
    self.dateLabel.text = [[dateFormattor stringFromDate:[NSDate date]] uppercaseString];
    
    [self grabStories];
}

-(void)grabStories {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://evendeveloper.github.io/lime/story/stories.json"]];
    if (data) {
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
}

/*- (void)openCardOne:(UITapGestureRecognizer*)sender {
    StoryController *controller = [[StoryController alloc] init];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.cardOne];
    LMTHOTWCard *card = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    controller.topView = card;
    controller.storyURL = [NSURL URLWithString:self.cardOne.storyURL];
    [self presentViewController:controller animated:YES completion:nil];
}*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    /*if ([LimeHelper darkMode]) {
        self.tabBarController.tabBar.barStyle = 1;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        self.view.backgroundColor = [LMColor backgroundColor];
        self.dateLabel.textColor = [LMColor labelColor];
        self.todayLabel.textColor = [LMColor labelColor];
    }*/
}

@end
