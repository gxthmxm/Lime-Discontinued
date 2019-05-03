//
//  HomeViewController.h
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController
@property (strong, nonatomic) IBOutlet WKWebView *webView;

@property (strong, nonatomic) NSArray *queueArray;
@end

NS_ASSUME_NONNULL_END
