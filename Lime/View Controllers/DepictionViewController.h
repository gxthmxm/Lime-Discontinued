//
//  ChangesViewController.h
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "../Lime.h"
#import "WebController.h"
#import "InstallationController.h"
#import "HomeViewController.h"
#import "Settings.h"

NS_ASSUME_NONNULL_BEGIN

@interface DepictionViewController : UIViewController <UIScrollViewDelegate, WKNavigationDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) WKWebView *depictionView;
@property (strong, nonatomic) IBOutlet UIButton *getButton;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UIImageView *bannerView;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *bigView;
@property (strong, nonatomic) IBOutlet UIView *separator;
@property (strong, nonatomic) NSURL *redirectURL;

@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UIView *separator2;
@property (strong, nonatomic) IBOutlet UILabel *informationTitle;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;

/*@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) UIImage *banner;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *version;
@property (strong, nonatomic) NSString *package;
@property (strong, nonatomic) NSString *depictionURL;
@property (strong, nonatomic) NSString *packageDesc;
@property (strong, nonatomic) NSString *size;*/
@property (strong, nonatomic) NSString *finalSize;/*
@property (strong, nonatomic) NSString *section;
@property (nonatomic) bool installed;*/
@property (strong, nonatomic) LMPackage* package;

@end

@interface InformationTableView : UITableViewController

@property (strong, nonatomic) IBOutlet UITableViewCell *developerCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *sizeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *sectionCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *versionCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *identifierCell;

@end

NS_ASSUME_NONNULL_END
