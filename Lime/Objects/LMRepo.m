//
//  LMRepo.m
//  Lime
//
//  Created by ArtikusHG on 9/19/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "LMRepo.h"

@implementation LMRepo

-(id)init {
    self = [super init];
    if (self) {
        self.parsedRepo = [LMParsedRepo new];
        self.rawRepo = [LMRawRepo new];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.parsedRepo forKey:@"parsedRepo"];
    [aCoder encodeObject:self.rawRepo forKey:@"rawRepo"];
}

-(id)initWithCoder:(NSCoder *)aCoder {
    self = [super init];
    if (self) {
        self.parsedRepo = [aCoder decodeObjectForKey:@"parsedRepo"];
        self.rawRepo = [aCoder decodeObjectForKey:@"rawRepo"];
    }
    return self;
}

@end
