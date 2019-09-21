//
//  WebController.h
//  Lime
//
//  Created by EvenDev on 20/09/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "Settings.h"
#import "../Lime.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebController : UIViewController <WKNavigationDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

NS_ASSUME_NONNULL_END
