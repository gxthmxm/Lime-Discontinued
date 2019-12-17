//
//  LMRepo.h
//  Lime
//
//  Created by ArtikusHG on 9/19/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LMParsedRepo.h"
#import "LMRawRepo.h"
#import "LMPackage.h"

@class LMPackage;

@interface LMRepo : NSObject

@property (nonatomic, retain) LMParsedRepo *parsedRepo;
@property (nonatomic, retain) LMRawRepo *rawRepo;
@property (nonatomic, retain) NSMutableArray <LMPackage *> *packages;

/*@property (nonatomic) long long releaseExpectedLength;
@property (nonatomic) long long packagesExpectedLength;
@property (nonatomic) long long iconExpectedLength;
@property (nonatomic) long long totalExpectedLength;

@property (nonatomic) long long releaseDownloaded;
@property (nonatomic) long long packagesDownloaded;
@property (nonatomic) long long iconDownloaded;
@property (nonatomic) long long totalDownloaded;

@property (nonatomic) BOOL releaseTotalAdded;
@property (nonatomic) BOOL packagesTotalAdded;
@property (nonatomic) BOOL iconTotalAdded;*/

@end
