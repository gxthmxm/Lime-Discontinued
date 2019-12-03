//
//  LMSourceCell.m
//  Lime
//
//  Created by Even Flatabø on 28/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMSourceCell.h"

@implementation LMSourceCell

@synthesize textLabel;
@synthesize detailTextLabel;
@synthesize imageView;

- (void)prepareForReuse {
    [super prepareForReuse];
    self.progressView.progress = 0;
    self.imageView.image = nil;
}

@end
