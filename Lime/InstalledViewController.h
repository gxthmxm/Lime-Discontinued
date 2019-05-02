//
//  InstalledViewController.h
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMDPKGParser.h"

NS_ASSUME_NONNULL_BEGIN

@interface InstalledViewController : UITableViewController

@property (nonatomic,retain) LMDPKGParser *parser;

@end

NS_ASSUME_NONNULL_END
