//
//  LMAddRepoController.m
//  Lime
//
//  Created by Even Flatabø on 20/12/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMAddRepoController.h"

@interface LMAddRepoController ()

@end

@implementation LMAddRepoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.effectView.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){20.0, 20.0}].CGPath;
    
    self.repoURLTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 10)];
    self.repoURLTextField.leftViewMode = UITextFieldViewModeAlways;

    self.effectView.layer.mask = maskLayer;
    [self.repoURLTextField becomeFirstResponder];
    self.repoURLTextField.inputAccessoryView = self.effectView;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.repoURLTextField resignFirstResponder];
}

- (IBAction)close:(id)sender {
    self.repoURLTextField.text = @"";
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addRepo:(id)sender {
    if (self.repoURLTextField.text.length > 0) {
        [LMSourceManager.sharedInstance setAddRepoURL:self.repoURLTextField.text];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
