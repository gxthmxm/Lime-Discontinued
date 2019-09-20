//
//  WebController.m
//  Lime
//
//  Created by EvenDev on 20/09/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "WebController.h"

@interface WebController ()

@end

@implementation WebController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Loading...";
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    self.webView.navigationDelegate = self;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        configuration.applicationNameForUserAgent = @"Lime (Cydia) Dark";
        [request setValue:@"Telesphoreo APT-HTTP/1.0.592 Dark" forHTTPHeaderField:@"User-Agent"];
        [request setValue:@"true" forHTTPHeaderField:@"dark"];
    } else {
        configuration.applicationNameForUserAgent = @"Lime (Cydia) Light";
        [request setValue:@"Telesphoreo APT-HTTP/1.0.592 Light" forHTTPHeaderField:@"User-Agent"];
    }
    
    [request setValue:[DeviceInfo getUDID] forHTTPHeaderField:@"X-Cydia-ID"];
    [request setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"X-Firmware"];
    [request setValue:[DeviceInfo getUDID] forHTTPHeaderField:@"X-Unique-ID"];
    [request setValue:[DeviceInfo machineID] forHTTPHeaderField:@"X-Machine"];
    [request setValue:@"API" forHTTPHeaderField:@"Payment-Provider"];
    [request setValue:[[NSLocale preferredLanguages] firstObject] forHTTPHeaderField:@"Accept-Language"];
    [self.webView loadRequest:request];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:self.webView];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.progressTintColor = self.view.tintColor;
    self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //[self.progressView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //[self.view addSubview:obj];
    //}];
    [self.view addSubview:self.progressView];
    [self.progressView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.progressView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.progressView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
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
        WebController *controller = [[WebController alloc] init];
        controller.url = navigationAction.request.URL;
        [self.navigationController pushViewController:controller animated:YES];
        decisionHandler(NO);
    } else {
        decisionHandler(YES);
    }
}

@end
