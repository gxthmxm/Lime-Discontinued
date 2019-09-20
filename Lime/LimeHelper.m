//
//  LimeHelper.m
//  Lime
//
//  Created by EvenDev on 24/06/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "LimeHelper.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@implementation LMPackage

- (void)encodeWithCoder:(NSCoder *)aCoder{
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
	[aCoder encodeObject:self.sileoDepiction forKey:@"sileoDepiction"];
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
    }
    return self;
}

@end

@implementation LMRepository

@end

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

@implementation LimeHelper

+(LMPackage*)packageWithIdentifier:(NSString*)identifier {
    LMPackage *package = [LMPackage new];
    package.identifier = identifier;
    
    return package;
}

+(UIImage*)iconFromPackage:(LMPackage *)package {
    UIImage *icon = [UIImage imageWithContentsOfFile:package.iconPath];
    return icon;
}

+(UIImage*)imageWithName:(NSString*)name {
    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Applications/Lime.app/%@.png", name]];
    return image;
}

@end
