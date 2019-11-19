//
//  LMTweakOfTheWeekCell.m
//  Lime
//
//  Created by Even Flatabø on 18/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMThemeOfTheWeekCell.h"

@implementation LMThemeOfTheWeekCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 14;
    self.clipsToBounds = YES;
    self.contentView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.19].CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(0, 15);
    self.contentView.layer.shadowRadius = 20;
    self.contentView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:14].CGPath;
    self.contentView.layer.masksToBounds = NO;
    self.contentView.layer.shadowOpacity = 1;
}

@end
