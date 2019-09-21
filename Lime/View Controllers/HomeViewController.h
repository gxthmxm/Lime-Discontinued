//
//  HomeViewController.h
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "../Lime.h"
#import "InstallationController.h"
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// CARD 1
@property (weak, nonatomic) IBOutlet UIView *cardOne;

@end

NS_ASSUME_NONNULL_END
