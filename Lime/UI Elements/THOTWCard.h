//
//  THOTWCard.h
//  Lime
//
//  Created by EvenDev on 24/09/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THOTWCard : UIView

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
