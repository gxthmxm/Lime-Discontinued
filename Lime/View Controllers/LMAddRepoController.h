//
//  LMAddRepoController.h
//  Lime
//
//  Created by Even Flatabø on 20/12/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMSourcesController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMAddRepoController : UIViewController

@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *repoURLTextField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@end

NS_ASSUME_NONNULL_END
