//
//  DepictionWebController.h
//  Lime
//
//  Created by EvenDev on 03/07/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface DepictionWebController : UIViewController

@property (nonatomic, retain) NSURL *url;
@property (strong, nonatomic) IBOutlet WKWebView *webView;

@end
