//
//  LMRawRepo.m
//  Lime
//
//  Created by Even Flatabø on 17/12/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMRawRepo.h"

@implementation LMRawRepo

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.lastUpdated forKey:@"lastUpdated"];
    [aCoder encodeObject:self.lastDownloaded forKey:@"lastDownloaded"];
    [aCoder encodeObject:self.releaseURL forKey:@"releaseURL"];
    [aCoder encodeObject:self.packagesURL forKey:@"packagesURL"];
    [aCoder encodeObject:self.releasePath forKey:@"releasePath"];
    [aCoder encodeObject:self.packagesPath forKey:@"packagesPath"];
    [aCoder encodeObject:self.imageURL forKey:@"imageURL"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.imagePath forKey:@"imagePath"];
    [aCoder encodeObject:self.repoURL forKey:@"repoURL"];
    [aCoder encodeObject:self.distros forKey:@"distros"];
    [aCoder encodeObject:self.distrosArray forKey:@"distrosArray"];
}

-(id)initWithCoder:(NSCoder *)aCoder {
    self = [super init];
    if (self) {
        self.lastUpdated = [aCoder decodeObjectForKey:@"lastUpdated"];
        self.lastDownloaded = [aCoder decodeObjectForKey:@"lastDownloaded"];
        self.releaseURL = [aCoder decodeObjectForKey:@"releaseURL"];
        self.packagesURL = [aCoder decodeObjectForKey:@"packagesURL"];
        self.releasePath = [aCoder decodeObjectForKey:@"releasePath"];
        self.packagesPath = [aCoder decodeObjectForKey:@"packagesPath"];
        self.imageURL = [aCoder decodeObjectForKey:@"imageURL"];
        self.image = [aCoder decodeObjectForKey:@"image"];
        self.imagePath = [aCoder decodeObjectForKey:@"imagePath"];
        self.repoURL = [aCoder decodeObjectForKey:@"repoURL"];
        self.distros = [aCoder decodeObjectForKey:@"distros"];
        self.distrosArray = [aCoder decodeObjectForKey:@"distrosArray"];
    }
    return self;
}

@end
