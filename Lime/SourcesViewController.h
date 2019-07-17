//
//  SearchViewController.h
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SourcesViewController : UITableViewController <NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>

@property (nonatomic,retain) NSMutableDictionary *repoNames;
@property (nonatomic,retain) NSMutableArray *sortedRepoNames;

@end

NS_ASSUME_NONNULL_END
