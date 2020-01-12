//
//  LMWebController.h
//  Lime
//
//  Created by Even Flatabø on 12/01/2020.
//  Copyright © 2020 EvenDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "../Helpers/LimeHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMWebController : UIViewController <WKNavigationDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

NS_ASSUME_NONNULL_END
