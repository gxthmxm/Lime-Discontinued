//
//  LMParsedRepo.m
//  Lime
//
//  Created by Even Flatabø on 17/12/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMParsedRepo.h"

@implementation LMParsedRepo

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.origin forKey:@"origin"];
    [aCoder encodeObject:self.label forKey:@"label"];
    [aCoder encodeObject:self.suite forKey:@"suite"];
    [aCoder encodeObject:self.version forKey:@"version"];
    [aCoder encodeObject:self.codename forKey:@"codename"];
    [aCoder encodeObject:self.architectures forKey:@"architectures"];
    [aCoder encodeObject:self.components forKey:@"components"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
}

-(id)initWithCoder:(NSCoder *)aCoder {
    self = [super init];
    if (self) {
        self.origin = [aCoder decodeObjectForKey:@"origin"];
        self.label = [aCoder decodeObjectForKey:@"label"];
        self.suite = [aCoder decodeObjectForKey:@"suite"];
        self.version = [aCoder decodeObjectForKey:@"version"];
        self.codename = [aCoder decodeObjectForKey:@"codename"];
        self.architectures = [aCoder decodeObjectForKey:@"architectures"];
        self.components = [aCoder decodeObjectForKey:@"components"];
        self.desc = [aCoder decodeObjectForKey:@"desc"];
    }
    return self;
}

@end
