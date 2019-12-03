//
//  LMQueue.m
//  Lime
//
//  Created by EvenDev on 21/09/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "LMQueue.h"

@implementation LMQueue

-(instancetype)init {
    self = [super init];
    self.actions = [[NSUserDefaults standardUserDefaults] arrayForKey:@"queue"];
    
    return self;
}

+(void)addQueueAction:(LMQueueAction*)action {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *actions = [[defaults arrayForKey:@"queue"] mutableCopy];
    
    NSMutableArray *archiveArray = [NSMutableArray arrayWithCapacity:actions.count + 1];
    for (NSData *dataObject in actions) {
        LMQueueAction *existingAction = [NSKeyedUnarchiver unarchiveObjectWithData:dataObject];
        if (![existingAction.package.identifier isEqualToString:action.package.identifier]) {
            [archiveArray addObject:dataObject];
        }
    }
    NSData *encodedAction = [NSKeyedArchiver archivedDataWithRootObject:action];
    [archiveArray addObject:encodedAction];
    [defaults setObject:archiveArray forKey:@"queue"];
}

+(NSArray*)queueActions {
    NSArray *queue = [[NSUserDefaults standardUserDefaults] arrayForKey:@"queue"];
    return queue;
}

+(void)setQueueWithMutableArray:(NSMutableArray*)array {
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"queue"];
}

+(void)removeObjectFromQueueWithIndex:(NSInteger)index {
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self queueActions]];
    [array removeObjectAtIndex:index];
    [self setQueueWithMutableArray:array];
}

@end
