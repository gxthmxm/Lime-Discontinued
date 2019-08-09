//
//  LMPackageParser.m
//  Lime
//
//  Created by ArtikusHG on 7/25/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "LMPackageParser.h"
#import "LimeHelper.h"
@import UIKit;

@implementation LMPackageParser

- (instancetype)initWithFilePath:(NSString *)filePath {
    
    // TOREMOVE
    self = [super init];
    LMPackage *package = [[LMPackage alloc] init];
    FILE *f = fopen([filePath UTF8String], "r");
    char str[1024];
    NSMutableDictionary *mutablePackages = [[NSMutableDictionary alloc] init];
    
    NSDictionary *customPropertiesDict = @{
        @"package":@"identifier",
        @"description":@"desc",
        @"icon":@"iconPath",
        @"depiction":@"depictionURL",
        @"tag":@"tags",
        @"depends":@"dependencies",
        @"installed-size":@"installedSize",
        @"sileodepiction":@"sileoDepiction"
    };
    
    while(fgets(str, sizeof(str), f) != NULL) {
        if(strlen(str) < 2) { // a line THAT short is obviously a newline, and we wanna go to the next package if so
            [mutablePackages setObject:package forKey:package.identifier];
            // reset it
            package = nil;
            package = [[LMPackage alloc] init];
            //break;
        } else {
            NSString *line = [[NSString stringWithCString:str encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            if(strstr(str, ": ")) {
                NSArray *lineArray = [line componentsSeparatedByString:@": "]; // Separate the line into the key and the value
                // initialize the key as the lowercase dpkg key (lowercase because see next comment)
                NSString *key = [[lineArray objectAtIndex:0] lowercaseString];
                // LMPackage has custom property names (e.g. description would be desc, dependencies would be depends etc.) so if there is a custom property name set for the current key in our dictionary we change the key
                if([customPropertiesDict objectForKey:key]) key = [customPropertiesDict objectForKey:key];
                // the value (most useless comment in the world)
                NSString *value = [lineArray objectAtIndex:1];
                if(key && value && [package respondsToSelector:NSSelectorFromString(key)]) {
                    [package setValue:value forKey:key];
                }
            // multiline descriptions
            } else if([line rangeOfString:@"    "].location != NSNotFound) {
                NSString *descriptionLine = [line substringFromIndex:4]; // remove 4 spaces
                descriptionLine = [@"\n" stringByAppendingString:descriptionLine];
                package.desc = [package.desc stringByAppendingString:descriptionLine];
            }
        }
    }
    
    fclose(f);
    self.packages = [mutablePackages copy];
    //UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"a" message:[NSString stringWithFormat:@"%@",self.packages] delegate:nil cancelButtonTitle:@"a" otherButtonTitles:nil];
    //[a show];
    return self;
}

@end
