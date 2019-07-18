//
//  AppDelegate.h
//  Lime
//
//  Created by Daniel on 29/04/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMDPKGParser.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (LMDPKGParser *)getParser;

@end

