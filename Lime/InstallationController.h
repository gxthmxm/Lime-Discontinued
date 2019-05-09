//
//  ChangesViewController.h
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InstallationController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *actionButton;
@property (strong, nonatomic) IBOutlet UIImageView *checkmark;
@property (strong, nonatomic) IBOutlet UILabel *greatLabel;
@property (strong, nonatomic) IBOutlet UIView *completeView;
@property (strong, nonatomic) IBOutlet UITableView *queueTable;
@property (strong, nonatomic) IBOutlet UITextView *logView;
@property (strong, nonatomic) IBOutlet UIButton *tempNext;

@property int *state;

@end

NS_ASSUME_NONNULL_END
