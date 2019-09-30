//
//  LMInfoBanner.m
//  Lime
//
//  Created by EvenDev on 30/09/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "LMInfoBanner.h"

@implementation LMInfoBanner

// 0 = Success
// 1 = Error

-(id)initWithMessage:(NSString *)message type:(NSUInteger)type target:(id)target selector:(SEL)selector {
    self = [super initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width - 32, 0)];
    if (self) {
        self.message = message;
        self.type = type;
        self.target = target;
        self.selector = selector;
        [self draw];
    }
    return self;
}

-(void)draw {
    self.layer.cornerRadius = 5;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 19, 19)];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(35, 8, self.frame.size.width - 43, 0)];
    self.label.text = self.message;
    self.label.textColor = [UIColor whiteColor];
    if (self.type == 0) {
        self.backgroundColor = [UIColor colorWithRed:0.18 green:0.80 blue:0.44 alpha:1.0];
        self.imageView.image = [UIImage imageNamed:@"Success"];
    } else {
        self.backgroundColor = [UIColor colorWithRed:0.91 green:0.30 blue:0.24 alpha:1.0];
        self.imageView.image = [UIImage imageNamed:@"Error"];
    }
    [self.label sizeToFit];
    [self addSubview:self.imageView];
    [self addSubview:self.label];
    
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self.target action:self.selector];
    [self addGestureRecognizer:gest];
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.label.frame.size.height + 16);
}

@end
