//
//  ChangesViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "DepictionViewController.h"
#import "InstallationController.h"
#import "NSTask.h"
#import "HomeViewController.h"
#import "UIImageAverageColorAddition.h"

@interface DepictionViewController () {
    HomeViewController *homeController;
}
@end

@implementation DepictionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    // Do any additional setup after loading the view.
    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, _depictionView.frame.origin.y + _depictionView.frame.size.height);
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    // Remove author email
    NSRange range = [self.author rangeOfString:@"<"];
    if(range.location != NSNotFound) self.author = [self.author substringToIndex:range.location - 1];
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
    self.bannerView.backgroundColor = [self.icon averageColor];
    self.titleLabel.text = self.name;
    [_titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_titleLabel sizeToFit];
    if (![self.author  isEqual:@""]) {
        self.authorLabel.text = self.author;
    } else {
        self.authorLabel.text = @"Unknown";
    }
    [_authorLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_authorLabel sizeToFit];
    _authorLabel.frame = CGRectMake(_authorLabel.frame.origin.x, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 3, _authorLabel.frame.size.width, _authorLabel.frame.size.height);
    self.descriptionLabel.text = self.packageDesc;
    [self.descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.descriptionLabel sizeToFit];
    self.getButton.backgroundColor = self.tabBarController.tabBar.tintColor; //[[[UIApplication sharedApplication] delegate] window].tintColor;
    self.moreButton.backgroundColor = self.tabBarController.tabBar.tintColor;

    if (self.installed) {
        [_getButton setTitle:@"MORE" forState:UIControlStateNormal];
    }
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,28,28)];
    iv.image = self.iconView.image;
    iv.contentMode = UIViewContentModeScaleAspectFit;

    UIView* ivContainer = [[UIView alloc] initWithFrame:CGRectMake(0,0,28,28)];
    [ivContainer addSubview:iv];

    self.navigationItem.titleView = ivContainer;
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;

    //[self.getButton setTitle:@"Remove" forState:UIControlStateNormal];
}

struct pixel {
    unsigned char r, g, b, a;
};

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
        [UIView animateWithDuration:0.2f animations:^{
            [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            self.navigationController.navigationBar.tintColor = [self.icon averageColor];
            self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
        }];
    } else {
        [UIView animateWithDuration:0.2f animations:^{
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
        }];
    }
    if (scrollOffset.y >= 200) {
        [UIView animateWithDuration:0.2f animations:^{
            self.navigationItem.titleView.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:0.2f animations:^{
            self.navigationItem.titleView.alpha = 0;
        }];
    }
}
- (IBAction)addToQueue:(id)sender {
    [homeController.queueArray addObject:self.package];
    [homeController updateQueue];
}

// Keep out, the backend starts
// Staccoverflow

//UITextView *a;
BOOL terminated;
- (void)runCommand:(NSString *)command withArgs:(NSArray *)args {
    //a = [[UITextView alloc] initWithFrame:self.view.bounds];
    //[self.view addSubview:a];

    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:command];
    [task setArguments:args];
    NSPipe *pipe = [NSPipe pipe];
    NSPipe *errorPipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    [task setStandardError:errorPipe];

    //[task setStandardInput:[NSPipe pipe]];

    NSFileHandle *outFile = [pipe fileHandleForReading];
    NSFileHandle *errFile = [errorPipe fileHandleForReading];

    [task launch];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(terminated:) name:NSTaskDidTerminateNotification object:task];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outData:) name:NSFileHandleDataAvailableNotification object:outFile];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errData:) name:NSFileHandleDataAvailableNotification object:errFile];
    [outFile waitForDataInBackgroundAndNotify];
    [errFile waitForDataInBackgroundAndNotify];
    while(!terminated) if (![[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) break;
    //[task waitUntilExit];
}


- (void)outData:(NSNotification *)notification {
    NSFileHandle *fileHandle = (NSFileHandle*)[notification object];
    [fileHandle waitForDataInBackgroundAndNotify];
    // Append data to textview here
    //a.text = [a.text stringByAppendingString:[[NSString alloc] initWithData:[fileHandle availableData] encoding:NSUTF8StringEncoding]];
}


- (void)errData:(NSNotification *)notification {
    NSFileHandle *fileHandle = (NSFileHandle*)[notification object];
    [fileHandle waitForDataInBackgroundAndNotify];
    // Append data to textview here
}

- (void)terminated:(NSNotification *)notification {
    // Go to finished view here
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    terminated = YES;
}

@end
