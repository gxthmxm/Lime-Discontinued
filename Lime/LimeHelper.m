//
//  LimeHelper.m
//  Lime
//
//  Created by EvenDev on 24/06/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "LimeHelper.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@implementation LMPackage

@end

@implementation LimeHelper

+(LMPackage*)packageWithIdentifier:(NSString*)identifier {
    LMPackage *package = [LMPackage new];
    package.identifier = identifier;
    
    return package;
}

+(UIImage*)iconFromPackage:(LMPackage *)package {
    UIImage *icon = [UIImage imageWithContentsOfFile:package.iconPath];
    return icon;
}

@end
