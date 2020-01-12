//
//  LMWebController.m
//  Lime
//
//  Created by Even Flatabø on 12/01/2020.
//  Copyright © 2020 EvenDev. All rights reserved.
//

#import "LMWebController.h"

@interface LMWebController ()

@end

@implementation LMWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    self.title = @"Loading...";
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    self.webView.navigationDelegate = self;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
    configuration.applicationNameForUserAgent = @"Lime (Cydia) Light";
    [request setValue:@"Telesphoreo APT-HTTP/1.0.592 Light" forHTTPHeaderField:@"User-Agent"];
    
    [request setValue:LMDeviceInfo.udid forHTTPHeaderField:@"X-Cydia-ID"];
    [request setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"X-Firmware"];
    [request setValue:LMDeviceInfo.udid forHTTPHeaderField:@"X-Unique-ID"];
    [request setValue:LMDeviceInfo.machineID forHTTPHeaderField:@"X-Machine"];
    [request setValue:@"API" forHTTPHeaderField:@"Payment-Provider"];
    [request setValue:[[NSLocale preferredLanguages] firstObject] forHTTPHeaderField:@"Accept-Language"];
    [self.webView loadRequest:request];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:self.webView];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.progressTintColor = self.view.tintColor;
    self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.progressView];
    [self.progressView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.progressView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    if (@available(iOS 11.0, *)) {
        [self.progressView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    } else {
        [self.progressView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    }
    [self.progressView.heightAnchor constraintEqualToConstant:2].active = YES;
}

-(void)hideProgressView {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.progressView.alpha = 0;
    } completion:nil];
}

-(void)showProgressView {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.progressView.alpha = 1;
    } completion:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
    }
}

-(void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        self.view.backgroundColor = [UIColor blackColor];
    }
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.title = webView.title;
    [self hideProgressView];
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self showProgressView];
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self hideProgressView];
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        LMWebController *controller = [LMWebController new];
        controller.url = navigationAction.request.URL;
        [self.navigationController pushViewController:controller animated:YES];
        decisionHandler(NO);
    } else {
        decisionHandler(YES);
    }
}


@end
