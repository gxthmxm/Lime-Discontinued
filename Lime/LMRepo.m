//
//  LMRepo.m
//  Lime
//
//  Created by ArtikusHG on 9/19/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "LMRepo.h"

@implementation LMRepo

- (instancetype)initWithName:(NSString *)name filename:(NSString *)filename urlString:(NSString *)urlString {
    self = [super init];
    self.name = name;
    self.filename = filename;
    self.urlString = urlString;
    return self;
}

@end
