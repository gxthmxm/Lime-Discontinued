//
//  LMDPKGParser.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "LMDPKGParser.h"

@implementation LMDPKGParser

- (instancetype)init {
    // Initialize the class
    self = [super init];
    // Array of parameters to store (e.g. Package:, Name: etc. will get stored)
    NSArray *parameters = @[@"Package", @"Name", @"Description", @"Section", @"Icon"];
    int maxlen = 4096;
    FILE *file = fopen("/var/lib/dpkg/status", "r");
    char str[maxlen];
    while(fgets(str, maxlen, file) != NULL) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        for (NSString *parameter in parameters) if(strstr(str, [parameter UTF8String])) {
            NSString *fullLine = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
            NSRange pos = [fullLine rangeOfString:@" "];
            if (pos.location != NSNotFound) {
                NSString *value = [fullLine substringFromIndex:pos.location + 1];
                [dict setValue:value forKey:parameter];
            }
        }
        NSLog(@"%@",dict);
        if(strstr(str, "Section:")) {
            //icon = [NSString stringWithFormat:@"/Applications/IcyInstaller3.app/icons/%@.png",[[[NSString stringWithCString:str encoding:NSASCIIStringEncoding] stringByReplacingOccurrencesOfString:@"Section: " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
            //if([icon rangeOfString:@" "].location != NSNotFound) icon = [NSString stringWithFormat:@"%@.png",[icon substringToIndex:[icon rangeOfString:@" "].location]];
        }
        //if(strstr(str, "Icon:")) icon = [[[NSString stringWithCString:str encoding:NSASCIIStringEncoding] stringByReplacingOccurrencesOfString:@"Icon: file://" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        //if(![[NSFileManager defaultManager] fileExistsAtPath:icon]) icon = @"/Applications/IcyInstaller3.app/icons/Unknown.png";
    }
    fclose(file);
    return self;
}

@end
