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

#define max(a, b) ((a > b) ? a : b)
#define min(a, b) ((a > b) ? b : a)

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

static UIImage *shadowImage;
+ (UIImage *)headerShadowImage {
	if (!shadowImage) {
		unsigned char shadowImageBytes[] = {
			0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0x00, 0x00, 0x00, 0x0d,
			0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x56,
			0x08, 0x06, 0x00, 0x00, 0x00, 0x0e, 0x9e, 0xfc, 0xc6, 0x00, 0x00, 0x00,
			0x01, 0x73, 0x52, 0x47, 0x42, 0x00, 0xae, 0xce, 0x1c, 0xe9, 0x00, 0x00,
			0x01, 0x59, 0x69, 0x54, 0x58, 0x74, 0x58, 0x4d, 0x4c, 0x3a, 0x63, 0x6f,
			0x6d, 0x2e, 0x61, 0x64, 0x6f, 0x62, 0x65, 0x2e, 0x78, 0x6d, 0x70, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x3c, 0x78, 0x3a, 0x78, 0x6d, 0x70, 0x6d, 0x65,
			0x74, 0x61, 0x20, 0x78, 0x6d, 0x6c, 0x6e, 0x73, 0x3a, 0x78, 0x3d, 0x22,
			0x61, 0x64, 0x6f, 0x62, 0x65, 0x3a, 0x6e, 0x73, 0x3a, 0x6d, 0x65, 0x74,
			0x61, 0x2f, 0x22, 0x20, 0x78, 0x3a, 0x78, 0x6d, 0x70, 0x74, 0x6b, 0x3d,
			0x22, 0x58, 0x4d, 0x50, 0x20, 0x43, 0x6f, 0x72, 0x65, 0x20, 0x35, 0x2e,
			0x34, 0x2e, 0x30, 0x22, 0x3e, 0x0a, 0x20, 0x20, 0x20, 0x3c, 0x72, 0x64,
			0x66, 0x3a, 0x52, 0x44, 0x46, 0x20, 0x78, 0x6d, 0x6c, 0x6e, 0x73, 0x3a,
			0x72, 0x64, 0x66, 0x3d, 0x22, 0x68, 0x74, 0x74, 0x70, 0x3a, 0x2f, 0x2f,
			0x77, 0x77, 0x77, 0x2e, 0x77, 0x33, 0x2e, 0x6f, 0x72, 0x67, 0x2f, 0x31,
			0x39, 0x39, 0x39, 0x2f, 0x30, 0x32, 0x2f, 0x32, 0x32, 0x2d, 0x72, 0x64,
			0x66, 0x2d, 0x73, 0x79, 0x6e, 0x74, 0x61, 0x78, 0x2d, 0x6e, 0x73, 0x23,
			0x22, 0x3e, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x3c, 0x72, 0x64,
			0x66, 0x3a, 0x44, 0x65, 0x73, 0x63, 0x72, 0x69, 0x70, 0x74, 0x69, 0x6f,
			0x6e, 0x20, 0x72, 0x64, 0x66, 0x3a, 0x61, 0x62, 0x6f, 0x75, 0x74, 0x3d,
			0x22, 0x22, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
			0x20, 0x20, 0x20, 0x78, 0x6d, 0x6c, 0x6e, 0x73, 0x3a, 0x74, 0x69, 0x66,
			0x66, 0x3d, 0x22, 0x68, 0x74, 0x74, 0x70, 0x3a, 0x2f, 0x2f, 0x6e, 0x73,
			0x2e, 0x61, 0x64, 0x6f, 0x62, 0x65, 0x2e, 0x63, 0x6f, 0x6d, 0x2f, 0x74,
			0x69, 0x66, 0x66, 0x2f, 0x31, 0x2e, 0x30, 0x2f, 0x22, 0x3e, 0x0a, 0x20,
			0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x3c, 0x74, 0x69, 0x66,
			0x66, 0x3a, 0x4f, 0x72, 0x69, 0x65, 0x6e, 0x74, 0x61, 0x74, 0x69, 0x6f,
			0x6e, 0x3e, 0x31, 0x3c, 0x2f, 0x74, 0x69, 0x66, 0x66, 0x3a, 0x4f, 0x72,
			0x69, 0x65, 0x6e, 0x74, 0x61, 0x74, 0x69, 0x6f, 0x6e, 0x3e, 0x0a, 0x20,
			0x20, 0x20, 0x20, 0x20, 0x20, 0x3c, 0x2f, 0x72, 0x64, 0x66, 0x3a, 0x44,
			0x65, 0x73, 0x63, 0x72, 0x69, 0x70, 0x74, 0x69, 0x6f, 0x6e, 0x3e, 0x0a,
			0x20, 0x20, 0x20, 0x3c, 0x2f, 0x72, 0x64, 0x66, 0x3a, 0x52, 0x44, 0x46,
			0x3e, 0x0a, 0x3c, 0x2f, 0x78, 0x3a, 0x78, 0x6d, 0x70, 0x6d, 0x65, 0x74,
			0x61, 0x3e, 0x0a, 0x4c, 0xc2, 0x27, 0x59, 0x00, 0x00, 0x00, 0x9e, 0x49,
			0x44, 0x41, 0x54, 0x18, 0x19, 0x65, 0x50, 0x41, 0x0e, 0x03, 0x21, 0x08,
			0x54, 0xd4, 0x35, 0x26, 0xa6, 0xaf, 0xf2, 0x53, 0xfd, 0xb0, 0x5f, 0xe8,
			0xc1, 0x04, 0x0a, 0xb3, 0xb6, 0x34, 0xd6, 0xc3, 0x64, 0x86, 0x61, 0x58,
			0xd8, 0x10, 0x42, 0x78, 0x92, 0xbe, 0x87, 0xc1, 0x8b, 0x54, 0xb2, 0x31,
			0x31, 0x60, 0x4a, 0x29, 0xc9, 0xb7, 0xf6, 0x2b, 0xb5, 0x4f, 0xcc, 0xdd,
			0xcd, 0x2e, 0x9d, 0xc5, 0x18, 0xf9, 0xce, 0x62, 0x0a, 0xa4, 0xb3, 0x4f,
			0x9f, 0x10, 0x0c, 0x85, 0xcd, 0xbc, 0xe5, 0x30, 0x72, 0xce, 0x68, 0xf9,
			0x4b, 0x20, 0x8b, 0x75, 0x01, 0x2e, 0x0f, 0x06, 0x89, 0x9d, 0x9d, 0xb1,
			0x3e, 0x3b, 0x75, 0x1f, 0x03, 0x43, 0x3f, 0xc4, 0xe4, 0x06, 0x5c, 0x00,
			0x6a, 0xa5, 0x14, 0xa6, 0xeb, 0xba, 0x98, 0xd6, 0x5a, 0x72, 0x32, 0xb4,
			0x60, 0x53, 0x3d, 0x30, 0x50, 0x6b, 0x6d, 0x8f, 0xd2, 0x84, 0xdc, 0x43,
			0x45, 0x84, 0xa9, 0xd6, 0x2a, 0x04, 0x86, 0x44, 0xef, 0x7d, 0xff, 0x67,
			0xc4, 0x14, 0x98, 0xe6, 0x9c, 0x42, 0x63, 0x0c, 0xb6, 0x52, 0x34, 0x08,
			0x6f, 0xb1, 0x62, 0x76, 0xa9, 0x94, 0x22, 0x3e, 0x94, 0x00, 0x00, 0x00,
			0x00, 0x49, 0x45, 0x4e, 0x44, 0xae, 0x42, 0x60, 0x82
		};
		shadowImage = [UIImage imageWithData:[NSData dataWithBytes:shadowImageBytes length:sizeof(shadowImageBytes)]];
	}
	return shadowImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	_bannerView.clipsToBounds = YES;
	_bannerView.frame = CGRectMake(0, _bannerView.frame.origin.y, UIScreen.mainScreen.bounds.size.width, 200);
	UIImageView *shadowView = [[UIImageView alloc] initWithImage:self.class.headerShadowImage];
	shadowView.contentMode = UIViewContentModeScaleToFill;
	shadowView.translatesAutoresizingMaskIntoConstraints = NO;
	[_bannerView addSubview:shadowView];
	[shadowView.topAnchor constraintEqualToAnchor:_bannerView.topAnchor].active = YES;
	[shadowView.bottomAnchor constraintEqualToAnchor:_bannerView.bottomAnchor].active = YES;
	[shadowView.leftAnchor constraintEqualToAnchor:_bannerView.leftAnchor].active = YES;
	[shadowView.rightAnchor constraintEqualToAnchor:_bannerView.rightAnchor].active = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	
	__block NSURL *sileoDepictionURL = _package.sileoDepiction.length ? [NSURL URLWithString:_package.sileoDepiction] : nil;
	__block UIImageView *weakBannerView = _bannerView;
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
					weakerBannerView.image = image;
					[weakerBannerView setNeedsDisplay];
					image = nil;
					weakerBannerView = nil;
				});
			}
			NSLog(@"img is null: %d", !image);
			NSLog(@"imageURL: %@", headerImageURL);
			NSLog(@"raw imageURL: %@", dict[@"headerImage"]);
		}
	});

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
    self.navigationController.navigationBar.barStyle = 1;
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
    //self.navigationController.navigationBar.barStyle = [[NSUserDefaults standardDefaults] boolForKey:@"darkMode"] ? 1 : 0;
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
            } else {
                self.navigationController.navigationBar.barStyle = 0;
            }
            self.navigationController.navigationBar.tintColor = [[LimeHelper iconFromPackage:self.package] averageColor];
        }];
    } else {
        [UIView animateWithDuration:0.2f animations:^{
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            self.navigationItem.rightBarButtonItem.customView.hidden = YES;
            self.navigationController.navigationBar.barStyle = 1;
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
	CGFloat navBarLowerY = self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y;
	double offsetY = scrollView.contentOffset.y + scrollView.adjustedContentInset.top;
	CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
	double h = max(200 - offsetY, 0);
	_bannerView.bounds = CGRectMake(0, 0, screenWidth, h);
	_bannerView.center = CGPointMake(screenWidth / 2, (_bannerView.bounds.size.height / 2) + offsetY - navBarLowerY);
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
