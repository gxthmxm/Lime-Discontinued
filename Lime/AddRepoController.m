//
//  ChangesViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "AddRepoController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface AddRepoController ()

@end

@implementation AddRepoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_repoURL becomeFirstResponder];
    self.logView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, self.logView.frame.origin.y, self.logView.frame.size.width, self.logView.frame.size.height);
    self.logView.translatesAutoresizingMaskIntoConstraints = YES;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    self.effectView.translatesAutoresizingMaskIntoConstraints = YES;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.line.backgroundColor = [UIColor colorWithRed:0.235 green:0.235 blue:0.235 alpha:1];
        self.repoURL.textColor = [UIColor whiteColor];
        [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _arrowImg.image = [UIImage imageNamed:@"arrowdark"];
        self.logView.textColor = [UIColor whiteColor];
        self.repoURL.keyboardAppearance = UIKeyboardAppearanceDark;
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    [UIView animateWithDuration:0.2 animations:^{
        self.effectView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - keyboardFrameBeginRect.size.height - 284, self.effectView.frame.size.width,  self.effectView.frame.size.height);
    }];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [_repoURL resignFirstResponder];
}
- (IBAction)addRepo:(id)sender {
    [_repoURL resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.effectView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 515, self.effectView.frame.size.width, 535);
        self.addRepoContainerView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - [UIScreen mainScreen].bounds.size.width * 2, self.addRepoContainerView.frame.origin.y, self.addRepoContainerView.frame.size.width, self.addRepoContainerView.frame.size.height);
        self.logView.frame = CGRectMake(28, self.logView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }];
}

@end
