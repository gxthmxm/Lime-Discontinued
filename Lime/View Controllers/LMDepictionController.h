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

NS_ASSUME_NONNULL_BEGIN

@interface LMDepictionController : UIViewController <UIScrollViewDelegate>

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
@property (weak, nonatomic) IBOutlet UILabel *depictionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

NS_ASSUME_NONNULL_END
