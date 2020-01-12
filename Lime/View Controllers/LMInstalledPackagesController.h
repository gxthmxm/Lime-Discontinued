//
//  LMInstalledPackagesController.h
//  Lime
//
//  Created by Even Flatabø on 19/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Helpers/LimeHelper.h"
#import "../UI Elements/LMPackageCell.h"
#import "LMDepictionController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMInstalledPackagesController : UITableViewController

@property (nonatomic, retain) NSMutableArray *packages;
@property (nonatomic, retain) UIRefreshControl *refreshControl;

@end

NS_ASSUME_NONNULL_END
