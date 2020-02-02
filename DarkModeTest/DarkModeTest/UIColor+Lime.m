//
//  UIColor+Lime.m
//  DarkModeTest
//
//  Created by Even Flatabø on 02/02/2020.
//  Copyright © 2020 EvenDev. All rights reserved.
//

#import "UIColor+Lime.h"

@implementation UIColor (Lime)

+(UIColor *)limeColorWithDark:(UIColor *)dark light:(UIColor *)light {
    return [NSUserDefaults.standardUserDefaults boolForKey:@"darkMode"] ? dark : light;
}

+(UIColor *)limeBackgroundColor {
    return [UIColor limeColorWithDark:[UIColor blackColor] light:[UIColor whiteColor]];
}

@end
