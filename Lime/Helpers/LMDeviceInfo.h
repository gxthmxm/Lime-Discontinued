//
//  LMDeviceInfo.h
//  Lime
//
//  Created by Even Flatabø on 19/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>
#import <sys/sysctl.h>
#include <spawn.h>
#include <ifaddrs.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMDeviceInfo : NSObject

+ (NSString *)deviceName;
+ (NSString *)machineID;
+ (NSString *)ecid;
+ (NSString *)udid;
+ (BOOL)isJailbroken;
+ (BOOL)isSimulator;

@end

NS_ASSUME_NONNULL_END
