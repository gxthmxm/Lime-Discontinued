//
//  LMRepo.h
//  Lime
//
//  Created by ArtikusHG on 9/19/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMRepo : NSObject

- (instancetype)initWithName:(NSString *)name filename:(NSString *)filename urlString:(NSString *)urlString;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSString *urlString;

@end
