//
//  ChangesViewController.h
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "../Lime.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfigCustomizationController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *lightToggle;
@property (strong, nonatomic) IBOutlet UIImageView *darkToggle;
@property (strong, nonatomic) IBOutlet UILabel *lightText;
@property (strong, nonatomic) IBOutlet UILabel *darkText;

@end

NS_ASSUME_NONNULL_END