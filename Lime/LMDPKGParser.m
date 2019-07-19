//
//  LMDPKGParser.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "LMDPKGParser.h"
#import "LimeHelper.h"
@import UIKit;

@implementation LMDPKGParser

- (instancetype)init {
    // Icy's parser, but a bit Limier
    self = [super init];
    self.installedPackages = [[NSMutableArray alloc] init];
    
    NSMutableArray *names = [[NSMutableArray alloc] init];
    FILE *file = fopen("/var/lib/dpkg/status", "r");
    char str[999];
    NSString *icon = @"";
    NSString *lastID = @"";
    NSString *lastDesc = @"";
    NSString *lastAuthor = @"";
    NSString *lastDepiction = @"";
	NSString *lastVersion = @"";
    NSString *lastSize = @"";
    NSString *lastSection = @"";
	NSString *sileoDepiction = @"";
	NSString *line;
    while(fgets(str, 999, file) != NULL) {
		line = @(str);
#define ProcessEntry(val, str) ([[str substringFromIndex:val.length+2] stringByReplacingOccurrencesOfString:@"\n" withString:@""])
#define Compare(a, b) ([a.lowercaseString hasPrefix:[b.lowercaseString stringByAppendingString:@":"]])
#define TestEntrySet(val, var) if (Compare(line, val)) var = ProcessEntry(val, line)
#define TestEntryAdd(val, var) if (Compare(line, val)) [var addObject:ProcessEntry(val, line)]
		TestEntrySet(@"Package", lastID);
		TestEntryAdd(@"Name", names);
		TestEntrySet(@"Description", lastDesc);
		TestEntrySet(@"Author", lastAuthor);
		TestEntrySet(@"Depiction", lastDepiction);
		TestEntrySet(@"Version", lastVersion);
        TestEntrySet(@"Size", lastSize);
        TestEntrySet(@"Section", lastSection);
		TestEntrySet(@"SileoDepiction", sileoDepiction);
        if(strstr(str, "Section:")) {
            icon = [NSString stringWithFormat:@"%@/sections/%@.png",[[NSBundle mainBundle] resourcePath], [[[NSString stringWithCString:str encoding:NSASCIIStringEncoding] stringByReplacingOccurrencesOfString:@"Section: " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
            if([icon rangeOfString:@"Themes"].location != NSNotFound) icon = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/sections/Themes.png"];
            else icon = [icon stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            if(![[NSFileManager defaultManager] fileExistsAtPath:icon]) icon = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/sections/Unknown.png"];
        }
        if(strstr(str, "Icon:")) {
            NSString *customIcon = [[[NSString stringWithCString:str encoding:NSASCIIStringEncoding] stringByReplacingOccurrencesOfString:@"Icon: file://" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            if([[NSFileManager defaultManager] fileExistsAtPath:customIcon]) icon = customIcon;
        }
        if(strlen(str) < 2 && names.count > 0) {
            NSString *lastObject = [names lastObject];
            [names sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            if(self.installedPackages.count < names.count) {
                NSInteger index = [names indexOfObject:lastObject];
            
                LMPackage *package = [LMPackage new];
                package.identifier = lastID;
                package.iconPath = icon;
                package.desc = lastDesc;
                package.author = lastAuthor;
                package.depictionURL = [NSURL URLWithString:lastDepiction];
                package.section = lastSection;
                package.installedSize = lastSize;
                package.size = lastSize;
                package.name = (NSString*)[names objectAtIndex:index];
                package.version = lastVersion;
				package.sileoDepiction = sileoDepiction;
                
                [self.installedPackages insertObject:package atIndex:index];
                
                icon = @"";
                lastID = @"";
                lastDesc = @"";
                lastAuthor = @"";
                lastDepiction = @"";
                lastVersion = @"";
                lastSize = @"";
                lastSection = @"";
				sileoDepiction = @"";
            }
        }
    }
    fclose(file);
    return self;
}

@end
