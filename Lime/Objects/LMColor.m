//
//  LMColor.m
//  Lime
//
//  Created by EvenDev on 21/09/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "LMColor.h"

@implementation LMColor

+(UIColor *)labelColor {
    return [UIColor whiteColor];
}

+(UIColor *)separatorColor {
    return [UIColor colorWithRed:0.235 green:0.235 blue:0.235 alpha:1];
}

+(UIColor *)backgroundColor {
    return [UIColor blackColor];
}

+(UIColor *)secondaryLabelColor {
    return [UIColor colorWithWhite:1 alpha:0.5];
}

+(UIColor *)selectedTableViewCellColor {
    return [UIColor colorWithWhite:0.1 alpha:1];
}

+(UIColor *)tableViewCellColor {
    return [UIColor colorWithRed:0.109 green:0.109 blue:0.117 alpha:1];
}

@end
