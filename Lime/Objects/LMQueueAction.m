//
//  LMQueueAction.m
//  Lime
//
//  Created by EvenDev on 21/09/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "LMQueueAction.h"

@implementation LMQueueAction

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.package forKey:@"package"];
    [aCoder encodeInteger:self.action forKey:@"action"];
}
- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super init];
    if (self) {
        self.package = [aCoder decodeObjectForKey:@"package"];
        self.action = [aCoder decodeIntegerForKey:@"action"];
    }
    return self;
}

-(instancetype)initWithPackage:(LMPackage*)package action:(NSInteger)action {
    self = [super init];
    if (self) {
        self.package = package;
        self.action = action;
    }
    return self;
}

@end
