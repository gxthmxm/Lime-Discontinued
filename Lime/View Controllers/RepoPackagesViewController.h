//
//  RepoPackagesViewController.h
//  Lime
//
//  Created by EvenDev on 20/09/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Lime.h"
#import "DepictionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RepoPackagesViewController : UITableViewController

@property (nonatomic, strong) LMRepo *repo;

@end

NS_ASSUME_NONNULL_END
