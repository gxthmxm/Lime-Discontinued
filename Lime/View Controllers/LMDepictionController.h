//
//  LMDepicitonController.h
//  Lime
//
//  Created by Even Flatabø on 22/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Objects/LMPackage.h"
#import "../Helpers/LimeHelper.h"
#import "../Other/UIImageAverageColorAddition.h"
#import <WebKit/WebKit.h>
#import "../Helpers/LMQueue.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMDepictionController : UIViewController <UIScrollViewDelegate, WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) LMPackage *package;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIVisualEffectView *navbar;

@property (weak, nonatomic) IBOutlet UIImageView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIButton *getButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIView *separator;

@property (weak, nonatomic) IBOutlet UIView *ratingsView;
@property (weak, nonatomic) IBOutlet UILabel *ratingsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingsScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingsPossibleLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *fiveStarProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *fourStarProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *threeStarProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *twoStarProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *oneStarProgressView;
@property (weak, nonatomic) IBOutlet UILabel *totalRatingsLabel;

@property (weak, nonatomic) IBOutlet UIView *separator2;
@property (weak, nonatomic) IBOutlet UILabel *depictionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *informatonTitle;
@property (retain, nonatomic) WKWebView *depictionView;

@property (strong, nonatomic) NSString *finalSize;

@end

@interface LMDepictionInformationTableView : UITableViewController

@property (strong, nonatomic) IBOutlet UITableViewCell *developerCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *sizeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *sectionCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *versionCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *installedVersionCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *identifierCell;

@end

NS_ASSUME_NONNULL_END
