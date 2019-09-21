//
//  ChangesViewController.h
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddRepoController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *repoURL;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;
@property (strong, nonatomic) IBOutlet UITextView *logView;
@property (strong, nonatomic) IBOutlet UIView *addRepoContainerView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *line;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImg;

@end

NS_ASSUME_NONNULL_END
