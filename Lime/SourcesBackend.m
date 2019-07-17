//
//  SourcesBackend.m
//  Lime
//
//  Created by ArtikusHG on 5/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "SourcesBackend.h"

@implementation SourcesBackend

NSString *limePath = @"/var/mobile/Documents/Lime/";
NSString *sourcesPath = @"/var/mobile/Documents/Lime/sources.list";
NSString *listsPath = @"/var/mobile/Documents/Lime/lists/";

+ (NSString *)iconFilenameForName:(NSString *)name {
    NSString *fixedName = [name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    fixedName = [fixedName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *filename = [[limePath stringByAppendingString:fixedName] stringByAppendingString:@".png"];
    return filename;
}

/*- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 [self performSegueWithIdentifier:@"packageInfo" sender:self];
 }*/

// apt-get update -o "Dir::Etc::SourceParts=/var/mobile/Documents/Lime/lists/" -o "Dir::Etc::SourceList=/var/mobile/Documents/Lime/sources.list" -o "Dir::State::Lists=/var/mobile/Documents/Lime/lists/"

@end
