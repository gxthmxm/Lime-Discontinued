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
#import "StoryController.h"
#import "../Other/UIViewCloneView.h"
#import "../UI Elements/THOTWCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSDictionary *stories;

// CARD 1
@property (strong, nonatomic) IBOutlet THOTWCard *cardOne;

@end

NS_ASSUME_NONNULL_END
