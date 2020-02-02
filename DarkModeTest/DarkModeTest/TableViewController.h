//
//  TableViewController.h
//  DarkModeTest
//
//  Created by Even Flatabø on 02/02/2020.
//  Copyright © 2020 EvenDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Lime.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *darkModeToggle;
@property (weak, nonatomic) IBOutlet UISwitch *followSystemToggle;

@end

NS_ASSUME_NONNULL_END
