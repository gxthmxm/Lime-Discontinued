//
//  LMColor.h
//  Lime
//
//  Created by EvenDev on 21/09/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMColor : NSObject

+(UIColor *)labelColor;
+(UIColor *)separatorColor;
+(UIColor *)backgroundColor;
+(UIColor *)secondaryLabelColor;
+(UIColor *)selectedTableViewCellColor;
+(UIColor *)tableViewCellColor;

@end

NS_ASSUME_NONNULL_END
