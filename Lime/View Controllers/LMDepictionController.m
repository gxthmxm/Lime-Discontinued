//
//  LMDepicitonController.m
//  Lime
//
//  Created by Even Flatabø on 22/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMDepictionController.h"

#define max(a, b) ((a > b) ? a : b)
#define min(a, b) ((a > b) ? b : a)

@interface LMDepictionController ()

@end

@implementation LMDepictionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 10000);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.bannerView.clipsToBounds = YES;
    self.bannerView.frame = CGRectMake(0, self.bannerView.frame.origin.y, UIScreen.mainScreen.bounds.size.width, 200);
    
    // Setting information
    
    if (self.package) {
        // Remove Email from Author
        NSRange range = [self.package.author rangeOfString:@"<"];
        if(range.location != NSNotFound) self.package.author = [self.package.author substringToIndex:range.location - 1];
        
        self.iconView.image = [UIImage imageNamed:self.package.section];
        
        self.bannerView.backgroundColor = [self.iconView.image averageColor];
        self.titleLabel.text = self.package.name;
        [self.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.titleLabel sizeToFit];
        NSLog(@"%@", self.package.author);
        if (self.package.author.length > 0) {
            self.authorLabel.text = self.package.author;
        } else {
            self.authorLabel.text = @"Unknown";
        }
        self.authorLabel.alpha = 0.5;
        [self.authorLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.authorLabel sizeToFit];
        self.authorLabel.frame = CGRectMake(self.authorLabel.frame.origin.x, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 3, self.authorLabel.frame.size.width, self.authorLabel.frame.size.height);
        self.descriptionLabel.text = self.package.desc;
        [self.descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.descriptionLabel sizeToFit];
        self.bigView.frame = CGRectMake(self.bigView.frame.origin.x, self.bannerView.frame.size.height - self.navbar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height, self.bigView.frame.size.width, self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.size.height + 17);
        
        self.getButton.backgroundColor = self.tabBarController.tabBar.tintColor; //[[[UIApplication sharedApplication] delegate] window].tintColor;
        self.moreButton.backgroundColor = self.tabBarController.tabBar.tintColor;

        if (self.package.installed) {
            [self.getButton setTitle:@"MORE" forState:UIControlStateNormal];
        }
        
        // Navigation bar stuff
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height - 60);
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,28,28)];
        iv.image = self.iconView.image;
        iv.contentMode = UIViewContentModeScaleAspectFit;
        iv.clipsToBounds = YES;
        iv.layer.cornerRadius = 8;

        UIView* ivContainer = [[UIView alloc] initWithFrame:CGRectMake(0,0,28,28)];
        [ivContainer addSubview:iv];

        self.navigationItem.titleView = ivContainer;
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        //[button addTarget:self action:@selector(addToQueue) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 74, 30);
        [button setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (self.package.installed) {
            [button setTitle:@"MORE" forState:UIControlStateNormal];
        } else {
            [button setTitle:@"GET" forState:UIControlStateNormal];
        }
        button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        button.backgroundColor = self.view.tintColor;
        button.layer.cornerRadius = 15.0;
        
        UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = buttonItem;
    }
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.navigationItem.titleView.hidden = YES;
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    self.navigationItem.rightBarButtonItem.customView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    if (self.scrollView.contentOffset.y < 1) {
        [UIView animateWithDuration:0.1 animations:^{
            self.navbar.alpha = 0;
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            self.navbar.frame = CGRectMake(0, 0, self.navbar.frame.size.width, [[LimeHelper sharedInstance] defaultNavigationController].navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
        }];
    } else {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHue:0.5861 saturation:1.0 brightness:1.0 alpha:1.0];
        self.navbar.alpha = 1.0;
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.scrollView.contentOffset.y < 101) {
        float alpha = self.scrollView.contentOffset.y / 100;
        self.navbar.alpha = alpha;
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHue:0.5861 saturation:alpha brightness:1.0 alpha:1.0];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Navigation bar fading
    if (scrollView.contentOffset.y < 101) {
        float alpha = scrollView.contentOffset.y / 100;
        self.navbar.alpha = alpha;
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHue:0.5861 saturation:alpha brightness:1.0 alpha:1.0];
    } else {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHue:0.5861 saturation:1.0 brightness:1.0 alpha:1.0];
        self.navbar.alpha = 1.0;
    }
    
    // Stretchy header
    CGFloat navBarLowerY = self.navbar.frame.size.height + self.navbar.frame.origin.y;
    double offsetY = scrollView.contentOffset.y + scrollView.adjustedContentInset.top;
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    double h = max(200 - offsetY, 0);
    self.bannerView.bounds = CGRectMake(0, 0, screenWidth, h);
    self.bannerView.center = CGPointMake(screenWidth / 2, (self.bannerView.bounds.size.height / 2) + offsetY - navBarLowerY);
    
    // Navigation bar content show/hide
    int hideY = self.getButton.frame.origin.y + self.bigView.frame.origin.y - self.navbar.frame.size.height;
    if (scrollView.contentOffset.y >= hideY) {
        [UIView animateWithDuration:0.2 animations:^{
            self.navigationItem.titleView.alpha = 1;
            self.iconView.alpha = 0;
            self.titleLabel.alpha = 0;
            self.authorLabel.alpha = 0;
            self.getButton.alpha = 0;
            self.moreButton.alpha = 0;
            self.navigationItem.rightBarButtonItem.customView.hidden = NO;
            self.navigationItem.rightBarButtonItem.customView.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.navigationItem.titleView.alpha = 0;
            self.iconView.alpha = 1;
            self.titleLabel.alpha = 1;
            self.authorLabel.alpha = 1;
            self.getButton.alpha = 1;
            self.moreButton.alpha = 1;
            self.navigationItem.rightBarButtonItem.customView.alpha = 0;
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
