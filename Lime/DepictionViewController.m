//
//  ChangesViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "DepictionViewController.h"

@interface DepictionViewController ()
@end

@implementation DepictionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, _depictionView.frame.origin.y + _depictionView.frame.size.height);
    _scrollView.scrollsToTop = NO;
    
    //
    // TO BE ASSIGNED BY INFO
    // USING PLACEHOLDERS
    //
    
    self.icon = [UIImage imageNamed:@"Tweaks"];
    self.name = @"Dark'n'Epic";
    self.author = @"EvenDev";
    self.depictionURL = @"https://repo.evendev.org/depictions/dne.html";
    self.package = @"org.evendev.dne";
    
    NSURL *nsurl=[NSURL URLWithString:self.depictionURL];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [_depictionView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    NSString* scaleMeta = @"var meta = document.createElement('meta'); meta.name = 'viewport'; meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; var head = document.getElementsByTagName('head')[0]; head.appendChild(meta);";
    [_depictionView evaluateJavaScript:scaleMeta completionHandler:nil];
    [_depictionView loadRequest:nsrequest];
    //_depictionView.scrollView.userInteractionEnabled = NO;
    if (self.icon != nil) {
        self.iconView.image = self.icon;
    }
    if (self.banner != nil) {
        self.bannerView.image = self.banner;
    }
    self.titleLabel.text = self.name;
    [_titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_titleLabel sizeToFit];
    self.authorLabel.text = self.author;
    [_authorLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_authorLabel sizeToFit];
    
}
- (IBAction)shareStart:(id)sender {
    UIAlertController* shareAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* shareAction = [UIAlertAction actionWithTitle:@"Share Package..." style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSString* urlScheme = @"lime://package/";
            NSString* url = [urlScheme stringByAppendingString:self.package];
            NSArray* activityItems = @[@"",[NSURL URLWithString:url]];
            NSArray* applicationActivities = nil;
            NSArray* excludeActivities = @[UIActivityTypePostToFacebook];
            UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
            activityController.excludedActivityTypes = excludeActivities;
            [self presentViewController:activityController animated:YES completion:nil];
        }
    ];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                         }];
    
    [shareAlert addAction:shareAction];
    [shareAlert addAction:cancelAction];
    [self presentViewController:shareAlert animated:YES completion:nil];
}

-(void)dealloc {
    [_depictionView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == _depictionView.scrollView && [keyPath isEqual:@"contentSize"]) {
        // we are here because the contentSize of the WebView's scrollview changed.
        _depictionView.frame = CGRectMake(_depictionView.frame.origin.x, _depictionView.frame.origin.y, _scrollView.frame.size.width, _depictionView.scrollView.contentSize.height);
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _depictionView.scrollView.contentSize.height + _depictionView.frame.origin.y);
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    /*[self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];*/
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    /*self.navigationController.navigationBar.shadowImage = nil;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault]; 
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1];*/
}
/*

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint scrollOffset = scrollView.contentOffset;
    if (scrollOffset.y >= 40) {
        if (![self.navigationController isNavigationBarHidden]) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    } else {
        if ([self.navigationController isNavigationBarHidden]) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
    }
}
 */

@end