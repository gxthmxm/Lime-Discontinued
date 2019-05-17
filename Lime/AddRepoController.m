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
