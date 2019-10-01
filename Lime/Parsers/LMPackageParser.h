//
//  LMPackageParser.h
//  Lime
//
//  Created by ArtikusHG on 7/25/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMPackageParser : NSObject

- (instancetype)initWithFilePath:(NSString *)filePath;
@property (nonatomic,retain) NSMutableArray *packages;

@end

NS_ASSUME_NONNULL_END
