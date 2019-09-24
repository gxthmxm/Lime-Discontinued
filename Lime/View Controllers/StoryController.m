//
//  StoryController.m
//  Lime
//
//  Created by EvenDev on 21/09/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "StoryController.h"

@interface StoryController ()

@end

@implementation StoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    self.topView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.topView.frame.size.height / self.topView.frame.size.width * self.view.frame.size.width);
    self.topView.layer.cornerRadius = 0;
    [self.scrollView addSubview:self.topView];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.topView.frame.size.height, self.view.frame.size.width, 0) configuration:config];
    self.webView.customUserAgent = @"dark";
    self.webView.navigationDelegate = self;
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.storyURL]];
    [self.scrollView addSubview:self.webView];
    
    self.closeEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    self.closeEffectView.frame = CGRectMake(self.view.frame.size.width - 48, 20, 28, 28);
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [self.closeEffectView addGestureRecognizer:tapGest];
    self.closeEffectView.layer.cornerRadius = 14;
    self.closeEffectView.clipsToBounds = YES;
    UIImageView *x = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mrX"]];
    x.frame = CGRectMake(0, 0, 28, 28);
    [self.closeEffectView.contentView addSubview:x];
    [self.view addSubview:self.closeEffectView];
}

-(void)dismiss:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([LimeHelper darkMode]) {
        self.view.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.11 alpha:1.0];
        self.scrollView.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.11 alpha:1.0];
        self.webView.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.11 alpha:1.0];
        self.webView.scrollView.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.11 alpha:1.0];
        self.topView.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.11 alpha:1.0];
    }
}

-(void)dealloc {
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        self.webView.frame = CGRectMake(0, self.topView.frame.size.height, self.view.frame.size.width, self.webView.scrollView.contentSize.height);
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.topView.frame.size.height + self.webView.frame.size.height);
    }
}

@end
