//
//  LimeHelper.h
//  Lime
//
//  Created by EvenDev on 24/06/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSTask.h"
#import "../Objects/LMPackage.h"

@interface LimeHelper : NSObject

+(UIImage*)iconFromPackage:(LMPackage*)package;
+(UIImage*)imageWithName:(NSString*)name;

+(BOOL)darkMode;
+(void)setDarkMode:(BOOL)state;

@end
