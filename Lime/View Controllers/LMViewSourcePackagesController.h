//
//  LMViewSourcePackagesController.h
//  Lime
//
//  Created by Even Flatabø on 28/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Objects/LMRepo.h"
#import "../UI Elements/LMPackageCell.h"
#import "../Helpers/LimeHelper.h"
#import "LMDepictionController.h"
#import "../Helpers/LMSourceManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMViewSourcePackagesController : UITableViewController

@property (nonatomic, retain) LMRepo *repo;
@property (nonatomic, retain) UIProgressView *topProgressView;
@property (nonatomic, retain) UIRefreshControl *theRefreshControl;

@end

NS_ASSUME_NONNULL_END
