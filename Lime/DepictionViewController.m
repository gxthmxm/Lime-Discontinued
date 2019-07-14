//
//  ChangesViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "DepictionViewController.h"
#import "InstallationController.h"
#import "HomeViewController.h"
#import "UIColor/UIImageAverageColorAddition.h"
#import "Settings.h"
#import "LimeHelper.h"

@interface DepictionViewController () {
    HomeViewController *homeController;
}
@end

@implementation InformationTableView

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    DepictionViewController *depictionViewController = (DepictionViewController*)self.parentViewController;
    if (![depictionViewController.package.author  isEqual:@""]) {
        self.developerCell.detailTextLabel.text = depictionViewController.package.author;
    } else {
        self.developerCell.detailTextLabel.text = @"Unknown";
    }
    self.versionCell.detailTextLabel.text = depictionViewController.package.version;
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
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        self.tableView.separatorColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        self.tableView.backgroundColor = [UIColor blackColor];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
    }
}

@end

@implementation DepictionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    // Do any additional setup after loading the view.
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    // Remove author email
    NSRange range = [self.package.author rangeOfString:@"<"];
    if(range.location != NSNotFound) self.package.author = [self.package.author substringToIndex:range.location - 1];
    
    NSURL *nsurl = self.package.depictionURL;
    NSMutableURLRequest *nsrequest=[NSMutableURLRequest requestWithURL:nsurl];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        configuration.applicationNameForUserAgent = @"Lime (Cydia) Dark";
        [nsrequest setValue:@"Telesphoreo APT-HTTP/1.0.592 Dark" forHTTPHeaderField:@"User-Agent"];
        [nsrequest setValue:@"true" forHTTPHeaderField:@"dark"];
    } else {
        configuration.applicationNameForUserAgent = @"Lime (Cydia) Light";
        [nsrequest setValue:@"Telesphoreo APT-HTTP/1.0.592 Light" forHTTPHeaderField:@"User-Agent"];
    }
    
    self.depictionView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    
    [_depictionView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    NSString* scaleMeta = @"var meta = document.createElement('meta'); meta.name = 'viewport'; meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; var head = document.getElementsByTagName('head')[0]; head.appendChild(meta);";
    [_depictionView evaluateJavaScript:scaleMeta completionHandler:nil];
    
    [nsrequest setValue:[DeviceInfo getUDID] forHTTPHeaderField:@"X-Cydia-ID"];
    [nsrequest setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"X-Firmware"];
    [nsrequest setValue:[DeviceInfo getUDID] forHTTPHeaderField:@"X-Unique-ID"];
    [nsrequest setValue:[DeviceInfo machineID] forHTTPHeaderField:@"X-Machine"];
    [nsrequest setValue:@"API" forHTTPHeaderField:@"Payment-Provider"];
    [nsrequest setValue:[[NSLocale preferredLanguages] firstObject] forHTTPHeaderField:@"Accept-Language"];
    
    self.depictionView.multipleTouchEnabled = NO;
    [self.scrollView addSubview:_depictionView];
    self.depictionView.navigationDelegate = self;
    [_depictionView loadRequest:nsrequest];
    self.depictionView.scrollView.delegate = self;
    //_depictionView.scrollView.userInteractionEnabled = NO;
    if (![self.package.iconPath isEqual:@""]) {
        self.iconView.image = [LimeHelper iconFromPackage:self.package];
    }
    self.bannerView.backgroundColor = [[LimeHelper iconFromPackage:self.package] averageColor];
    self.titleLabel.text = self.package.name;
    [_titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_titleLabel sizeToFit];
    if (![self.package.author  isEqual:@""]) {
        self.authorLabel.text = self.package.author;
    } else {
        self.authorLabel.text = @"Unknown";
    }
    self.authorLabel.alpha = 0.5;
    [_authorLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_authorLabel sizeToFit];
    _authorLabel.frame = CGRectMake(_authorLabel.frame.origin.x, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 3, _authorLabel.frame.size.width, _authorLabel.frame.size.height);
    self.descriptionLabel.text = self.package.desc;
    [self.descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.descriptionLabel sizeToFit];
    _bigView.frame = CGRectMake(_bigView.frame.origin.x, _bigView.frame.origin.y, _bigView.frame.size.width, self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.size.height + 17);
    _depictionView.frame = CGRectMake(0, self.bigView.frame.origin.y + self.bigView.frame.size.height, _depictionView.frame.size.width, _depictionView.frame.size.height);
    
    self.getButton.backgroundColor = self.tabBarController.tabBar.tintColor; //[[[UIApplication sharedApplication] delegate] window].tintColor;
    self.moreButton.backgroundColor = self.tabBarController.tabBar.tintColor;

    if (self.package.installed) {
        [_getButton setTitle:@"MORE" forState:UIControlStateNormal];
    }
    
    if ([self.package.installedSize containsString:@"-"]) {
        NSMutableArray *sizeArray = [NSMutableArray arrayWithArray:[self.package.installedSize componentsSeparatedByString:@"-"]];
        if ([sizeArray objectAtIndex:1]) {
            self.finalSize = [sizeArray objectAtIndex:1];
        }
    } else {
        if (self.package.installedSize) {
            self.finalSize = self.package.installedSize;
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height - 60);
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,28,28)];
    iv.image = self.iconView.image;
    iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.clipsToBounds = YES;
    iv.layer.cornerRadius = 8;

    UIView* ivContainer = [[UIView alloc] initWithFrame:CGRectMake(0,0,28,28)];
    [ivContainer addSubview:iv];

    self.navigationItem.titleView = ivContainer;

    //[self.getButton setTitle:@"Remove" forState:UIControlStateNormal];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(addToQueue) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 74, 30);
    [button setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (self.package.installed) {
        [button setTitle:@"MORE" forState:UIControlStateNormal];
    } else {
        [button setTitle:@"GET" forState:UIControlStateNormal];
    }
    button.titleLabel.font = [UIFont fontWithName:@".SFUIText-Bold" size:13];
    button.backgroundColor = [[LimeHelper iconFromPackage:self.package] averageColor];
    button.layer.cornerRadius = 15.0;
    
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

-(void)addToQueue {
    [self performSegueWithIdentifier:@"openQueue" sender:self];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView.hidden = YES;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        self.bigView.backgroundColor = [UIColor blackColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.authorLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        self.descriptionLabel.textColor = [UIColor whiteColor];
        self.separator.backgroundColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        self.descriptionTitleLabel.textColor = [UIColor whiteColor];
        self.depictionView.backgroundColor = [UIColor blackColor];
        self.depictionView.scrollView.backgroundColor = [UIColor blackColor];
        self.scrollView.backgroundColor = [UIColor blackColor];
        self.infoView.backgroundColor = [UIColor blackColor];
        self.separator2.backgroundColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        self.informationTitle.textColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor blackColor];
        [self.moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.navigationItem.titleView.hidden = YES;
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    self.navigationItem.rightBarButtonItem.customView.alpha = 1;
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
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
        self.depictionView.scrollView.backgroundColor = [UIColor blackColor];
        self.depictionView.backgroundColor = [UIColor blackColor];
        NSString *css = @"body { background-color: #000 !important }";
        NSString *javascript = @"var style = document.createElement('style'); style.innerHTML = '%@'; document.head.appendChild(style)";
        NSString *javascriptWithCSSString = [NSString stringWithFormat:javascript, css];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
            [self.depictionView evaluateJavaScript:javascriptWithCSSString completionHandler:nil];
        }
        
        if (self.package.depictionURL && [NSString stringWithFormat:@"%@", self.package.depictionURL].length > 0) {
            _depictionView.frame = CGRectMake(_depictionView.frame.origin.x, _depictionView.frame.origin.y, _scrollView.frame.size.width, _depictionView.scrollView.contentSize.height);
            _infoView.frame = CGRectMake(0, _depictionView.frame.origin.y + _depictionView.frame.size.height, _infoView.frame.size.width, _infoView.frame.size.height);
            
            float bottom = _infoView.frame.origin.y + _infoView.frame.size.height + 25;
            _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, bottom);
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.tintColor = [[[UIApplication sharedApplication] delegate] window].tintColor;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint scrollOffset = scrollView.contentOffset;

    if (scrollOffset.y >= 30) {
        self.navigationItem.titleView.hidden = NO;
        [UIView animateWithDuration:0.2f animations:^{
            [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
                self.navigationController.navigationBar.barStyle = 1;
            }
            self.navigationController.navigationBar.tintColor = [[LimeHelper iconFromPackage:self.package] averageColor];
        }];
    } else {
        [UIView animateWithDuration:0.2f animations:^{
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        }];
    }
    if (scrollOffset.y >= 157) {
        [UIView animateWithDuration:0.2f animations:^{
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
        [UIView animateWithDuration:0.2f animations:^{
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
- (IBAction)addToQueue:(id)sender {
    if(!self.package.installed) {
        UIAlertController* actionAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* removeAction = [UIAlertAction actionWithTitle:@"Remove" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            LMQueueAction *queueAction = [[LMQueueAction alloc] initWithPackage:self.package action:1];
            [LMQueue addQueueAction:queueAction];
            [self performSegueWithIdentifier:@"openQueue" sender:self.getButton];
        }];
        UIAlertAction* reinstallAction = [UIAlertAction actionWithTitle:@"Reinstall" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            LMQueueAction *queueAction = [[LMQueueAction alloc] initWithPackage:self.package action:2];
            [LMQueue addQueueAction:queueAction];
            [self performSegueWithIdentifier:@"openQueue" sender:self.getButton];
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
        [self performSegueWithIdentifier:@"openQueue" sender:self.getButton];
    }
}

/*-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = [[navigationAction request] URL];
    NSString *urlScheme = [url scheme];
    if ([urlScheme isEqualToString:@"https"] || [urlScheme isEqualToString:@"lime"] || [urlScheme isEqualToString:@"http"] || url == self.package.depictionURL) {
        if (!(url == self.package.depictionURL)) {
            [self performSegueWithIdentifier:@"depictionWeb" sender:self];
            self.redirectURL = url;
            decisionHandler(WKNavigationActionPolicyAllow);
        } else {
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"depictionWeb"]) {
        DepictionWebController *destController = segue.destinationViewController;
        DepictionViewController *srcController = segue.sourceViewController;
        destController.url = srcController.redirectURL;
    }
}*/

@end
