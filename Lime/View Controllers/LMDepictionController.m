//
//  LMDepicitonController.m
//  Lime
//
//  Created by Even Flatabø on 22/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMDepictionController.h"

#define max(a, b) ((a > b) ? a : b)
#define min(a, b) ((a > b) ? b : a)

@interface LMDepictionController ()

@end

@implementation LMDepictionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
       addObserver:self selector:@selector(orientationChanged:)
       name:UIDeviceOrientationDidChangeNotification
       object:[UIDevice currentDevice]];
    
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 10000);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.bannerView.clipsToBounds = YES;
    self.bannerView.frame = CGRectMake(0, self.bannerView.frame.origin.y, UIScreen.mainScreen.bounds.size.width, 200);
    
    // Setting information
    
    if (self.package) {
        if ([[[LimeHelper sharedInstance] installedPackagesDict] objectForKey:self.package.identifier]) self.package.installed = YES;
        
        NSLog(@"%@", self.package.depictionURL);
        // Banner
        __block NSURL *sileoDepictionURL = self.package.sileoDepiction.length ? [NSURL URLWithString:self.package.sileoDepiction] : nil;
        __block UIImageView *weakBannerView = self.bannerView;
        if (sileoDepictionURL) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:sileoDepictionURL];
            sileoDepictionURL = nil;
            NSLog(@"Data is null: %d", !data);
            if (data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSURL *headerImageURL;
                __block UIImage *image;
                NSLog(@"Dict is null: %d", !dict);
                if ([dict isKindOfClass:[NSDictionary class]] && (headerImageURL = dict[@"headerImage"] ? [NSURL URLWithString:dict[@"headerImage"]] : nil) && (data = [NSData dataWithContentsOfURL:headerImageURL]) && (image = [UIImage imageWithData:data])) {
                    __block UIImageView *weakerBannerView = weakBannerView;
                    weakBannerView = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"Setting image for banner: %@", weakerBannerView);
                        [UIView animateWithDuration:0.2 animations:^{
                            weakerBannerView.image = image;
                            [weakerBannerView setNeedsDisplay];
                        }];
                        image = nil;
                        weakerBannerView = nil;
                    });
                }
                NSLog(@"img is null: %d", !image);
                NSLog(@"imageURL: %@", headerImageURL);
                NSLog(@"raw imageURL: %@", dict[@"headerImage"]);
            }
        });
        
        // Remove Email from Author
        NSRange range = [self.package.author rangeOfString:@"<"];
        if(range.location != NSNotFound) self.package.author = [self.package.author substringToIndex:range.location - 1];
        
        // Web View
         NSURL *nsurl = [NSURL URLWithString:self.package.depictionURL];
         NSMutableURLRequest *nsrequest=[NSMutableURLRequest requestWithURL:nsurl];
         WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
         
        /* if ([LimeHelper darkMode]) {
             configuration.applicationNameForUserAgent = @"Lime (Cydia) Dark";
             [nsrequest setValue:@"Telesphoreo APT-HTTP/1.0.592 Dark" forHTTPHeaderField:@"User-Agent"];
             [nsrequest setValue:@"true" forHTTPHeaderField:@"dark"];
         } else {*/
             configuration.applicationNameForUserAgent = @"Lime (Cydia) Light";
             [nsrequest setValue:@"Telesphoreo APT-HTTP/1.0.592 Light" forHTTPHeaderField:@"User-Agent"];
         //}
         
         self.depictionView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
         
         [_depictionView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
         [self.depictionView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
         self.progressView.progressTintColor = self.view.tintColor;
         NSString* scaleMeta = @"var meta = document.createElement('meta'); meta.name = 'viewport'; meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; var head = document.getElementsByTagName('head')[0]; head.appendChild(meta);";
         [_depictionView evaluateJavaScript:scaleMeta completionHandler:nil];
         
         [nsrequest setValue:@"udid"/*[LMDeviceInfo udid]*/ forHTTPHeaderField:@"X-Cydia-ID"];
         [nsrequest setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"X-Firmware"];
         [nsrequest setValue:@"udid"/*[LMDeviceInfo udid]*/ forHTTPHeaderField:@"X-Unique-ID"];
         [nsrequest setValue:@"MachineID"/*[LMDeviceInfo machineID]*/ forHTTPHeaderField:@"X-Machine"];
         [nsrequest setValue:@"API" forHTTPHeaderField:@"Payment-Provider"];
         [nsrequest setValue:[[NSLocale preferredLanguages] firstObject] forHTTPHeaderField:@"Accept-Language"];
         
         self.depictionView.multipleTouchEnabled = NO;
         [self.scrollView addSubview:self.depictionView];
         self.depictionView.navigationDelegate = self;
         [_depictionView loadRequest:nsrequest];
         self.depictionView.scrollView.delegate = self;
         if (!(self.package.depictionURL) || !(self.package.depictionURL.length > 0) || [self.package.depictionURL isEqualToString:@""]) {
             self.progressView.alpha = 0;
         }
        
        // Icon
        if (self.package.iconPath.length > 0
            && [[NSFileManager defaultManager] fileExistsAtPath:self.package.iconPath]) {
            self.iconView.image = [UIImage imageWithContentsOfFile:self.package.iconPath];
        } else {
            if ([UIImage imageNamed:self.package.section]) self.iconView.image = [UIImage imageNamed:self.package.section];
            else self.iconView.image = [UIImage imageNamed:@"Unknown"];
        }
        
        self.bannerView.backgroundColor = [self.iconView.image averageColor];
        self.titleLabel.text = self.package.name;
        [self.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.titleLabel sizeToFit];
        if (self.package.author.length > 0) {
            self.authorLabel.text = self.package.author;
        } else {
            self.authorLabel.text = @"Unknown";
        }
        self.authorLabel.alpha = 0.5;
        [self.authorLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.authorLabel sizeToFit];
        self.authorLabel.frame = CGRectMake(self.authorLabel.frame.origin.x, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 3, self.authorLabel.frame.size.width, self.authorLabel.frame.size.height);
        self.descriptionLabel.text = self.package.desc;
        [self.descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.descriptionLabel sizeToFit];
        self.bigView.frame = CGRectMake(self.bigView.frame.origin.x, self.bannerView.frame.size.height - self.navbar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height, self.bigView.frame.size.width, self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.size.height + 17);
        self.depictionView.frame = CGRectMake(0, self.bigView.frame.origin.y + self.bigView.frame.size.height, self.depictionView.frame.size.width, self.depictionView.frame.size.height);
        
        self.getButton.backgroundColor = self.tabBarController.tabBar.tintColor; //[[[UIApplication sharedApplication] delegate] window].tintColor;
        self.moreButton.backgroundColor = self.tabBarController.tabBar.tintColor;

        if (self.package.installed) {
            [self.getButton setTitle:@"MORE" forState:UIControlStateNormal];
        }
        
        // Navigation bar stuff
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height - 23);
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,28,28)];
        iv.image = self.iconView.image;
        iv.contentMode = UIViewContentModeScaleAspectFit;
        iv.clipsToBounds = YES;
        iv.layer.cornerRadius = 6.3;

        UIView* ivContainer = [[UIView alloc] initWithFrame:CGRectMake(0,0,28,28)];
        [ivContainer addSubview:iv];

        self.navigationItem.titleView = ivContainer;
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        //[button addTarget:self action:@selector(addToQueue) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 74, 30);
        [button setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (self.package.installed) {
            [button setTitle:@"MORE" forState:UIControlStateNormal];
        } else {
            [button setTitle:@"GET" forState:UIControlStateNormal];
        }
        button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        button.backgroundColor = self.view.tintColor;
        button.layer.cornerRadius = 15.0;
        
        UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = buttonItem;
         
        if (self.package.installedSize) {
            self.finalSize = [[self.package.installedSize componentsSeparatedByString:@"Size: "] lastObject];
        } else {
            if (self.package.size) {
                self.finalSize = self.package.size;
            } else {
                self.finalSize = @"0";
            }
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == _depictionView.scrollView && [keyPath isEqual:@"contentSize"]) {
        // we are here because the contentSize of the WebView's scrollview changed.
        /*NSString *css = @"body { background-color: #000 !important }";
        NSString *javascript = @"var style = document.createElement('style'); style.innerHTML = '%@'; document.head.appendChild(style)";
        NSString *javascriptWithCSSString = [NSString stringWithFormat:javascript, css];
        if ([LimeHelper darkMode]) {
            [self.depictionView evaluateJavaScript:javascriptWithCSSString completionHandler:nil];
        }*/
        
        if (self.package.depictionURL && [NSString stringWithFormat:@"%@", self.package.depictionURL].length > 0) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.depictionView.frame = CGRectMake(self.depictionView.frame.origin.x, self.depictionView.frame.origin.y, self.scrollView.frame.size.width, self.depictionView.scrollView.contentSize.height);
                NSLog(@"Changed Frame");
                self.infoView.frame = CGRectMake(0, self.depictionView.frame.origin.y + self.depictionView.frame.size.height, self.infoView.frame.size.width, self.infoView.frame.size.height);
            } completion:^(BOOL finished) {
                
                float bottom = self.infoView.frame.origin.y + self.infoView.frame.size.height + 62;
                self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, bottom);
            }];
        }
    }
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.depictionView.estimatedProgress;
    }
}

-(void)showProgressBar {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.progressView.alpha = 1;
    } completion:nil];
}

-(void)hideProgressBar {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.progressView.alpha = 0;
    } completion:nil];
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self showProgressBar];
    NSLog(@"Start");
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self hideProgressBar];
    NSLog(@"Finished");
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self hideProgressBar];
    NSLog(@"Failed");
}

-(void)orientationChanged:(NSNotification *)note {
    UIDevice *device = note.object;
    if (UIDeviceOrientationIsPortrait(device.orientation)) {
        self.navbar.frame = CGRectMake(0, 0, self.navbar.frame.size.width, [[LimeHelper sharedInstance] defaultNavigationController].navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
    } else {
        self.navbar.frame = CGRectMake(0, 0, self.navbar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.2 animations:^{
        self.navigationController.navigationBar.tintColor = self.view.tintColor;
    }];
}

-(void)dealloc {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [self.depictionView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    [self.depictionView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (IBAction)mainAction:(id)sender {
    if(self.package.installed) {
        UIAlertController* actionAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* removeAction = [UIAlertAction actionWithTitle:@"Remove" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            LMQueueAction *queueAction = [[LMQueueAction alloc] initWithPackage:self.package action:1];
            [LMQueue addQueueAction:queueAction];
        }];
        UIAlertAction* reinstallAction = [UIAlertAction actionWithTitle:@"Reinstall" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            LMQueueAction *queueAction = [[LMQueueAction alloc] initWithPackage:self.package action:2];
            [LMQueue addQueueAction:queueAction];
        }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {}];
        
        [actionAlert addAction:removeAction];
        [actionAlert addAction:reinstallAction];
        [actionAlert addAction:cancelAction];
        [self presentViewController:actionAlert animated:YES completion:nil];
    } else {
        LMQueueAction *queueAction = [[LMQueueAction alloc] initWithPackage:self.package action:0];
        [LMQueue addQueueAction:queueAction];
    }
}

- (IBAction)shareStart:(id)sender {
    UIAlertController* shareAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction* shareAction = [UIAlertAction actionWithTitle:@"Share Package..." style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSString* urlScheme = @"lime://package/";
            NSString* url = [urlScheme stringByAppendingString:self.package.identifier];
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

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.navigationItem.titleView.hidden = YES;
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    self.navigationItem.rightBarButtonItem.customView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    if (self.scrollView.contentOffset.y < 1) {
        [UIView animateWithDuration:0.1 animations:^{
            self.navbar.alpha = 0;
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            self.navbar.frame = CGRectMake(0, 0, self.navbar.frame.size.width, [[LimeHelper sharedInstance] defaultNavigationController].navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
        }];
    } else {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHue:0.5861 saturation:1.0 brightness:1.0 alpha:1.0];
        self.navbar.alpha = 1.0;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.scrollView.contentOffset.y < 101) {
        float alpha = self.scrollView.contentOffset.y / 100;
        self.navbar.alpha = alpha;
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHue:0.5861 saturation:alpha brightness:1.0 alpha:1.0];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Navigation bar fading
    if (scrollView.contentOffset.y < 71) {
        float alpha = scrollView.contentOffset.y / 70;
        self.navbar.alpha = alpha;
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHue:0.5861 saturation:alpha brightness:1.0 alpha:1.0];
    } else {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHue:0.5861 saturation:1.0 brightness:1.0 alpha:1.0];
        self.navbar.alpha = 1.0;
    }
    
    // Stretchy header
    CGFloat navBarLowerY = self.navbar.frame.size.height + self.navbar.frame.origin.y;
    double offsetY = scrollView.contentOffset.y + scrollView.adjustedContentInset.top;
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    double h = max(200 - offsetY, 0);
    self.bannerView.bounds = CGRectMake(0, 0, screenWidth, h);
    self.bannerView.center = CGPointMake(screenWidth / 2, (self.bannerView.bounds.size.height / 2) + offsetY - navBarLowerY);
    
    // Navigation bar content show/hide
    int hideY = self.getButton.frame.origin.y + self.bigView.frame.origin.y - self.navbar.frame.size.height;
    if (scrollView.contentOffset.y >= hideY) {
        [UIView animateWithDuration:0.2 animations:^{
            self.navigationItem.titleView.alpha = 1;
            self.iconView.alpha = 0;
            self.titleLabel.alpha = 0;
            self.authorLabel.alpha = 0;
            self.getButton.alpha = 0;
            self.moreButton.alpha = 0;
            self.navigationItem.rightBarButtonItem.customView.hidden = NO;
            self.navigationItem.rightBarButtonItem.customView.alpha = 1;
        }];
    } else {
        self.navigationItem.titleView.hidden = NO;
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.navigationItem.titleView.alpha = 0;
            self.iconView.alpha = 1;
            self.titleLabel.alpha = 1;
            self.authorLabel.alpha = 1;
            self.getButton.alpha = 1;
            self.moreButton.alpha = 1;
            self.navigationItem.rightBarButtonItem.customView.alpha = 0;
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation LMDepictionInformationTableView

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    LMDepictionController *depictionViewController = (LMDepictionController*)self.parentViewController;
    if (depictionViewController.package.author.length > 0) {
        self.developerCell.detailTextLabel.text = depictionViewController.package.author;
    } else {
        self.developerCell.detailTextLabel.text = @"Unknown";
    }
    LMPackage *latest = [[[LimeHelper sharedInstance] packagesDict] objectForKey:depictionViewController.package.identifier];
    self.versionCell.detailTextLabel.text = latest.version;
    LMPackage *installed = [[[LimeHelper sharedInstance] installedPackagesDict] objectForKey:depictionViewController.package.identifier];
    self.installedVersionCell.detailTextLabel.text = installed.version;
    self.identifierCell.detailTextLabel.text = depictionViewController.package.identifier;
    
    int sizeInt = [depictionViewController.finalSize intValue];
    NSString *byteFormat = @" KB";
        
    if (sizeInt > 1023) {
        byteFormat = @" MB";
        sizeInt = sizeInt / 1024;
    }
    if (sizeInt > 1048575) {
        byteFormat = @" GB";
        sizeInt = sizeInt / 1048576;
    }
    
    self.sizeCell.detailTextLabel.text = [NSString stringWithFormat:@"%d%@", sizeInt, byteFormat];
    
    self.sectionCell.detailTextLabel.text = depictionViewController.package.section;
}

@end
