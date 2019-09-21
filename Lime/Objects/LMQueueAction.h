//
//  LMQueueAction.h
//  Lime
//
//  Created by EvenDev on 21/09/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMPackage.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMQueueAction : NSObject

@property (nonatomic) NSInteger action;
@property (nonatomic, strong) LMPackage *package;

-(instancetype)initWithPackage:(LMPackage*)package action:(NSInteger)action;

@end

NS_ASSUME_NONNULL_END
