//
//  LMQueue.h
//  Lime
//
//  Created by EvenDev on 21/09/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Objects/LMQueueAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMQueue : NSObject

@property (nonatomic, strong) NSArray *actions;

+(void)addQueueAction:(LMQueueAction*)action;
+(NSArray*)queueActions;
+(void)setQueueWithMutableArray:(NSMutableArray*)array;
+(void)removeObjectFromQueueWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
