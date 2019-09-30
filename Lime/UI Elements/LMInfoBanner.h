//
//  LMInfoBanner.h
//  Lime
//
//  Created by EvenDev on 30/09/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMInfoBanner : UIView

@property (nonatomic) NSUInteger type;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) SEL selector;
@property (nonatomic) id target;

-(id)initWithMessage:(NSString *)message type:(NSUInteger)type target:(id)target selector:(SEL)selector;
-(void)draw;

@end

NS_ASSUME_NONNULL_END
