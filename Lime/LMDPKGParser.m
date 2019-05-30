//
//  LMDPKGParser.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "LMDPKGParser.h"
@import UIKit;

@implementation LMDPKGParser

- (instancetype)init {
    // Icy's parser, but a bit Limier
    self = [super init];
    self.packageIDs = [[NSMutableArray alloc] init];
    self.packageIcons = [[NSMutableArray alloc] init];
    self.packageNames = [[NSMutableArray alloc] init];
    self.packageDescs = [[NSMutableArray alloc] init];
    self.packageDepictions = [[NSMutableArray alloc] init];
    self.packageAuthors = [[NSMutableArray alloc] init];
	self.packageVersions = [[NSMutableArray alloc] init];
    
    NSMutableArray *names = [[NSMutableArray alloc] init];
    FILE *file = fopen("/var/lib/dpkg/status", "r");
    char str[999];
    NSString *icon = @"";
    NSString *lastID = @"";
    NSString *lastDesc = @"";
    NSString *lastAuthor = @"";
    NSString *lastDepiction = @"";
	NSString *lastVersion = @"";
    while(fgets(str, 999, file) != NULL) {
#define ProcessEntry(val, str) ([[[NSString stringWithCString:str encoding:NSASCIIStringEncoding] stringByReplacingOccurrencesOfString:@val": " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""])
#define TestEntrySet(val, var) if (strstr(str, val":")) var = ProcessEntry(val, str)
#define TestEntryAdd(val, var) if (strstr(str, val":")) [var addObject:ProcessEntry(val, str)]
		TestEntrySet("Package", lastID);
		TestEntryAdd("Name", names);
		TestEntrySet("Description", lastDesc);
		TestEntrySet("Author", lastAuthor);
		TestEntrySet("Depiction", lastDepiction);
		TestEntrySet("Version", lastVersion);
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
            if(self.packageIDs.count < names.count) {
                NSInteger index = [names indexOfObject:lastObject];
				[self.packageVersions insertObject:lastVersion atIndex:index];
                [self.packageIDs insertObject:lastID atIndex:index];
                [self.packageIcons insertObject:icon atIndex:index];
                [self.packageDescs insertObject:lastDesc atIndex:index];
                [self.packageAuthors insertObject:lastAuthor atIndex:index];
                [self.packageDepictions insertObject:lastDepiction atIndex:index];
                icon = @"";
                lastID = @"";
                lastDesc = @"";
                lastAuthor = @"";
                lastDepiction = @"";
            }
        }
    }
    self.packageNames = names;
    fclose(file);
    return self;
}

@end
