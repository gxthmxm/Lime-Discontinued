//
//  LMInstalledPackageCell.m
//  Lime
//
//  Created by Even Flatabø on 21/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMInstalledPackageCell.h"

@implementation LMInstalledPackageCell

@synthesize textLabel;
@synthesize detailTextLabel;
@synthesize imageView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
