//
//  SourcesBackend.h
//  Lime
//
//  Created by ArtikusHG on 5/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"

NS_ASSUME_NONNULL_BEGIN

@interface SourcesBackend : NSObject
+ (NSString *)iconFilenameForName:(NSString *)name;

// apt-get update -o "Dir::Etc::SourceParts=/var/mobile/Documents/Lime/lists/" -o "Dir::Etc::SourceList=/var/mobile/Documents/Lime/sources.list" -o "Dir::State::Lists=/var/mobile/Documents/Lime/lists/"

@end

NS_ASSUME_NONNULL_END
