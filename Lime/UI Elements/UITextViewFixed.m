//
//  UITextViewFixed.m
//  Lime
//
//  Created by Even Flatabø on 25/12/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "UITextViewFixed.h"

IB_DESIGNABLE
@implementation UITextViewFixed

-(void)layoutSubviews {
    [super layoutSubviews];
    self.textContainerInset = UIEdgeInsetsZero;
    self.textContainer.lineFragmentPadding = 0;
}

@end
