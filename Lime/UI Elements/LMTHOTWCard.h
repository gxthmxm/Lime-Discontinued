//
//  LMTHOTWCard.h
//  Lime
//
//  Created by Even Flatabø on 16/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMTHOTWCard : UIView

@property (nonatomic, strong) IBOutlet UIImageView *backgroundView;
@property (nonatomic, strong) IBOutlet UIImageView *foregroundView;
@property (nonatomic, strong) IBOutlet UIImageView *iconView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIVisualEffectView *effectView;
@property (nonatomic, strong) IBOutlet UILabel *packageTitle;
@property (nonatomic, strong) IBOutlet UILabel *packageDescription;
@property (nonatomic, strong) IBOutlet UIButton *getButton;
@property (nonatomic, strong) NSString *repository;
@property (nonatomic, strong) NSString *packageIdentifier;
@property (nonatomic, strong) NSString *storyURL;

@end

NS_ASSUME_NONNULL_END
