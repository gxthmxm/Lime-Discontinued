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
    NSMutableDictionary *mutablePackageNames = [[NSMutableDictionary alloc] init];

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
    
    NSString *previousKey; // for multiline
    
    while(fgets(str, sizeof(str), f) != NULL) {
        if(strlen(str) < 2 && ![package.identifier hasPrefix:@"cy+"] && ![package.identifier hasPrefix:@"gsc."]) { // a line THAT short is obviously a newline, and we wanna go to the next package and add the current one if so; also we don't add packages prefixed with gsc and cy+
            if(package.name.length < 1) package.name = package.identifier;
            if(package.iconPath.length > 0) package.iconPath = [package.iconPath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
            else {
                package.iconPath = [NSString stringWithFormat:@"%@/sections/%@.png",[[NSBundle mainBundle] resourcePath], package.section];
                if([package.iconPath rangeOfString:@"Themes"].location != NSNotFound) package.iconPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/sections/Themes.png"];
                else package.iconPath = [package.iconPath stringByReplacingOccurrencesOfString:@" " withString:@"_"];
                if(![[NSFileManager defaultManager] fileExistsAtPath:package.iconPath]) package.iconPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/sections/Unknown.png"];
            }
            [mutablePackages setObject:package forKey:package.identifier];
            [mutablePackageNames setObject:package.identifier forKey:package.name];
            // reset it
            package = nil;
            package = [[LMPackage alloc] init];
            //break;
        } else {
            NSString *line = [[NSString stringWithCString:str encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            if(strstr(str, ": ") && ![line hasPrefix:@" "]) {
                NSArray *lineArray = [line componentsSeparatedByString:@": "]; // Separate the line into the key and the value
                // initialize the key as the lowercase dpkg key (lowercase because see next comment)
                NSString *key = [[lineArray objectAtIndex:0] lowercaseString];
                // LMPackage has custom property names (e.g. description would be desc, dependencies would be depends etc.) so if there is a custom property name set for the current key in our dictionary we change the key
                if([customPropertiesDict objectForKey:key]) key = [customPropertiesDict objectForKey:key];
                previousKey = key;
                // the value (most useless comment in the world)
                NSString *value = [lineArray objectAtIndex:1];
                if(key && value && [package respondsToSelector:NSSelectorFromString(key)]) {
                    [package setValue:value forKey:key];
                }
            // multiline stuff
            } else if([line hasPrefix:@" "]) {
                NSString *appendLine = line; // HERE I STILL NEED TO REMOVE THE PREFIX
                appendLine = [@"\n" stringByAppendingString:appendLine];
                appendLine = [[package valueForKey:previousKey] stringByAppendingString:appendLine];
                [package setValue:appendLine forKey:previousKey];
            }
        }
    }
    
    fclose(f);
    self.packages = [mutablePackages copy];
    self.packageNames = [mutablePackageNames copy];
    //UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"a" message:[NSString stringWithFormat:@"%@",self.packages] delegate:nil cancelButtonTitle:@"a" otherButtonTitles:nil];
    //[a show];
    return self;
}

@end
