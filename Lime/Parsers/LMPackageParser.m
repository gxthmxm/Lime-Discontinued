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
    self = [super init];
    
    LMPackage *package = [[LMPackage alloc] init];
    FILE *f = fopen([filePath UTF8String], "r");
    char str[1024];
    NSMutableDictionary *mutablePackages = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *mutablePackageNames = [[NSMutableDictionary alloc] init];
    
    if ([filePath isEqualToString:[LimeHelper dpkgStatusLocation]]) {
        package.installed = YES;
    }

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
	
    NSString *lastKey = nil;
    while(fgets(str, sizeof(str), f) != NULL) {
        if(!str[1] && ![package.identifier hasPrefix:@"cy+"] && ![package.identifier hasPrefix:@"gsc."]) { // a line THAT short is obviously a newline, and we wanna go to the next package and add the current one if so; also we don't add packages prefixed with gsc and cy+
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
            lastKey = nil;
            //break;
        } else {
            NSString *line = [[NSString stringWithCString:str encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            if(line.length && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[line characterAtIndex:0]]) {
            	// multiline descriptions
                NSString *nextLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; // remove 4 spaces
                NSString *oldValue = [package valueForKey:lastKey];
                [package setValue:[NSString stringWithFormat:@"%@%@", (oldValue ? [oldValue stringByAppendingString:@"\n"] : @""), nextLine] forKey:lastKey];
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
                if(key && value && [package respondsToSelector:NSSelectorFromString(key)]) {
                    [package setValue:value forKey:(lastKey = key)];
                }
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
