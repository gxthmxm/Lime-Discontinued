//
//  LMHomeController.h
//  Lime
//
//  Created by Even Flatabø on 16/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../UI Elements/LMTHOTWCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMHomeController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSDictionary *stories;
@property (nonatomic, strong) NSData *storiesData;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *storiesDateFormatter;

// CARD 1
@property (strong, nonatomic) IBOutlet LMTHOTWCard *cardOne;

@end

NS_ASSUME_NONNULL_END
