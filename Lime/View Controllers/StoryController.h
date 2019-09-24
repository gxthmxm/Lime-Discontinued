//
//  StoryController.h
//  Lime
//
//  Created by EvenDev on 21/09/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "../Lime.h"
#import "../UI Elements/THOTWCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface StoryController : UIViewController <WKNavigationDelegate>

@property (nonatomic, strong) THOTWCard *topView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIVisualEffectView *closeEffectView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSURL *storyURL;

@end

NS_ASSUME_NONNULL_END
