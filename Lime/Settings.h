//
//  ChangesViewController.h
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Settings : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *iPhoneView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *iOSLabel;
@property (strong, nonatomic) IBOutlet UIView *infoTable;

@end

@interface InfoTable : UITableViewController
@property (strong, nonatomic) IBOutlet UITableViewCell *modelCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *ecidCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *udidCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *serialCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *bootCell;

@end

NS_ASSUME_NONNULL_END
