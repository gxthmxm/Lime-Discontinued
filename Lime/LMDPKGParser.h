//
//  LMDPKGParser.h
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMDPKGParser : NSObject

@property (strong, nonatomic) NSMutableArray *packageIDs;
@property (strong, nonatomic) NSMutableArray *packageNames;
@property (strong, nonatomic) NSMutableArray *packageIcons;
@property (strong, nonatomic) NSMutableArray *packageDescs;
@property (strong, nonatomic) NSMutableArray *packageDepictions;
@property (strong, nonatomic) NSMutableArray *packageAuthors;
@property (strong, nonatomic) NSMutableArray *packageVersions;

@end

NS_ASSUME_NONNULL_END
