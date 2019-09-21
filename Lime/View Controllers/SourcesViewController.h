//
//  SearchViewController.h
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "../Lime.h"
#import "Settings.h"
#include <bzlib.h>

NS_ASSUME_NONNULL_BEGIN

@interface SourcesViewController : UITableViewController <NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>

@property (nonatomic, retain) NSMutableDictionary *repos;
@property (nonatomic, retain) NSArray *sortedRepoNames;
@property (nonatomic, retain) LMPackageParser *parser;

typedef void(^downloadCompletion)(BOOL);

@end

NS_ASSUME_NONNULL_END
