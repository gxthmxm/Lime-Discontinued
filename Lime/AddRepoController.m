//
//  ChangesViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "AddRepoController.h"

@interface AddRepoController ()

@end

@implementation AddRepoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_repoURL becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardOpened:) name:UIKeyboardDidShowNotification object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)keyboardOpened:(NSNotification*)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    self.effectView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - keyboardFrameBeginRect.size.height - 264, self.effectView.frame.size.width,  self.effectView.frame.size.height);
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [_repoURL resignFirstResponder];
}
- (IBAction)addRepo:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [_repoURL resignFirstResponder];
}

@end
