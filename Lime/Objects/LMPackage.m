//
//  LMPackage.m
//  Lime
//
//  Created by EvenDev on 21/09/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "LMPackage.h"

@implementation LMPackage

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.version forKey:@"version"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
    [aCoder encodeObject:self.section forKey:@"section"];
    [aCoder encodeObject:self.iconPath forKey:@"iconPath"];
    [aCoder encodeObject:self.architecture forKey:@"architecture"];
    [aCoder encodeObject:self.depictionURL forKey:@"depictionURL"];
    [aCoder encodeObject:self.tags forKey:@"tags"];
    [aCoder encodeObject:self.dependencies forKey:@"dependencies"];
    [aCoder encodeObject:self.conflicts forKey:@"conflicts"];
    [aCoder encodeObject:self.author forKey:@"author"];
    [aCoder encodeObject:self.maintainer forKey:@"maintainer"];
    [aCoder encodeObject:self.filename forKey:@"filename"];
    [aCoder encodeObject:self.size forKey:@"size"];
    [aCoder encodeObject:self.installedSize forKey:@"installedSize"];
    [aCoder encodeObject:self.installedDate forKey:@"installedDate"];
    [aCoder encodeObject:self.sileoDepiction forKey:@"sileoDepiction"];//
    [aCoder encodeInteger:self.possibleActions forKey:@"possibleActions"];
    [aCoder encodeBool:self.installed forKey:@"installed"];
    [aCoder encodeBool:self.ignoreUpgrades forKey:@"ignoreUpgrades"];
    [aCoder encodeBool:self.commercial forKey:@"commercial"];
    [aCoder encodeObject:self.repository forKey:@"repository"];
    [aCoder encodeObject:self.debURL forKey:@"debURL"];
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super init];
    if (self) {
        self.identifier = [aCoder decodeObjectForKey:@"identifier"];
        self.name = [aCoder decodeObjectForKey:@"name"];
        self.version = [aCoder decodeObjectForKey:@"version"];
        self.desc = [aCoder decodeObjectForKey:@"desc"];
        self.section = [aCoder decodeObjectForKey:@"section"];
        self.iconPath = [aCoder decodeObjectForKey:@"iconPath"];
        self.architecture = [aCoder decodeObjectForKey:@"architecture"];
        self.depictionURL = [aCoder decodeObjectForKey:@"depictionURL"];
        self.tags = [aCoder decodeObjectForKey:@"tags"];
        self.dependencies = [aCoder decodeObjectForKey:@"dependencies"];
        self.conflicts = [aCoder decodeObjectForKey:@"conflicts"];
        self.author = [aCoder decodeObjectForKey:@"author"];
        self.maintainer = [aCoder decodeObjectForKey:@"maintainer"];
        self.filename = [aCoder decodeObjectForKey:@"filename"];
        self.size = [aCoder decodeObjectForKey:@"size"];
        self.installedSize = [aCoder decodeObjectForKey:@"installedSize"];
        self.installedDate = [aCoder decodeObjectForKey:@"installedDate"];
        self.sileoDepiction = [aCoder decodeObjectForKey:@"sileoDepiction"];
        self.possibleActions = [aCoder decodeIntegerForKey:@"possibleActions"];
        self.installed = [aCoder decodeBoolForKey:@"installed"];
        self.ignoreUpgrades = [aCoder decodeBoolForKey:@"ignoreUpgrades"];
        self.commercial = [aCoder decodeBoolForKey:@"commercial"];
        self.repository = [aCoder decodeObjectForKey:@"repository"];
        self.debURL = [aCoder decodeObjectForKey:@"debURL"];
    }
    return self;
}

@end
