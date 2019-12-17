//
//  LMParsedRepo.h
//  Lime
//
//  Created by Even Flatabø on 17/12/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMParsedRepo : NSObject

@property (nonatomic, retain) NSString *origin;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *suite;
@property (nonatomic, retain) NSString *version;
@property (nonatomic, retain) NSString *codename;
@property (nonatomic, retain) NSString *architectures;
@property (nonatomic, retain) NSString *components;
@property (nonatomic, retain) NSString *desc;

@end

NS_ASSUME_NONNULL_END
