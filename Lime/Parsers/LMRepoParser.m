//
//  LMRepoParser.m
//  Lime
//
//  Created by Even Flatabø on 28/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMRepoParser.h"

@implementation LMRepoParser

+(LMRepo *)parseRepo:(LMRepo *)repo {
    FILE *f = fopen([repo.rawRepo.releasePath UTF8String], "r");
    char str[1024];

    NSDictionary *customPropertiesDict = @{
        @"origin": @"origin",
        @"label": @"label",
        @"suite": @"suite",
        @"version": @"version",
        @"codename": @"codename",
        @"architectures": @"architectures",
        @"components": @"components",
        @"description": @"desc"
    };
    
    NSString *lastKey = nil;
    while(fgets(str, sizeof(str), f) != NULL) {
        NSString *line = [[NSString stringWithCString:str encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if(line.length && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[line characterAtIndex:0]]) {
            // multiline descriptions
            NSString *nextLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; // remove 4 spaces
            NSString *oldValue = [repo valueForKey:lastKey];
            [repo.parsedRepo setValue:[NSString stringWithFormat:@"%@%@", (oldValue ? [oldValue stringByAppendingString:@"\n"] : @""), nextLine] forKey:lastKey];
        }
        else if([line containsString:@": "]) {
            NSMutableArray *lineArray = [line componentsSeparatedByString:@": "].mutableCopy; // Separate the line into the key and the value
            // initialize the key as the lowercase dpkg key (lowercase because see next comment)
            NSString *key = [[lineArray objectAtIndex:0] lowercaseString];
            // LMPackage has custom property names (e.g. description would be desc, dependencies would be depends etc.) so if there is a custom property name set for the current key in our dictionary we change the key
            if([customPropertiesDict objectForKey:key]) key = [customPropertiesDict objectForKey:key];
            // the value (most useless comment in the world)
            [lineArray removeObjectAtIndex:0];
            NSString *value = [lineArray componentsJoinedByString:@": "];
            if(key && value && [repo.parsedRepo respondsToSelector:NSSelectorFromString(key)]) {
                [repo.parsedRepo setValue:value forKey:(lastKey = key)];
            }
        }
    }
    
    fclose(f);
    
    repo.rawRepo.lastUpdated = [NSDate date];
    if ([NSFileManager.defaultManager fileExistsAtPath:repo.rawRepo.imagePath]) repo.rawRepo.image = [UIImage imageWithContentsOfFile:repo.rawRepo.imagePath];
    
    return repo;
}

@end
