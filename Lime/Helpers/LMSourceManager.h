//
//  LMSourceManager.h
//  Lime
//
//  Created by Even Flatabø on 11/12/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Objects/LMRepo.h"
#import "../Objects/LMPackage.h"
#import "LimeHelper.h"
#import "../Parsers/LMRepoParser.h"
#import "LMSourceDownloader.h"
#import "../View Controllers/LMSourcesController.h"

NS_ASSUME_NONNULL_BEGIN

@class LMSourcesController;
@class LMViewSourcePackagesController;

@interface LMSourceManager : NSObject

+ (id)sharedInstance;
-(void)refreshSourcesCompletionHandler:(void (^)(void))completion;
-(void)refreshSource:(LMRepo *)repo viewSourceController:(LMViewSourcePackagesController *)viewSrcController completionHandler:(void (^)(void))completion;

@property (nonatomic, strong) NSMutableArray *sources;
@property (nonatomic, strong) LMSourcesController *sourceController;

@end

NS_ASSUME_NONNULL_END
