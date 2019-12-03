//
//  LMSourcesController.h
//  Lime
//
//  Created by Even Flatabø on 28/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../UI Elements/LMSourceCell.h"
#import "LMViewSourcePackagesController.h"
#import "LMRepo.h"
#import "../Parsers/LMPackageParser.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMSourcesController : UITableViewController <NSURLSessionDownloadDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSMutableArray *repos;

@property (nonatomic, retain) NSCache *repoIconsCache;
@property (nonatomic, retain) LMPackageParser *parser;

@property (nonatomic, retain) UIProgressView *topProgressView;

@property (nonatomic) NSUInteger allReposExpectedLength;
@property (nonatomic) NSUInteger allReposDownloaded;

@property (nonatomic, retain, nullable) NSMutableArray *addRepoTasks;
@property (nonatomic, retain, nullable) LMRepo *addRepo;

@end

NS_ASSUME_NONNULL_END
