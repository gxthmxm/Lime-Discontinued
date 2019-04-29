//
//  FirstViewController.h
//  Lime
//
//  Created by Daniel on 29/04/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface FirstViewController : UIViewController
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@end

