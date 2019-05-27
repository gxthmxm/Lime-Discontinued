//
//  ChangesViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "InstallationController.h"
#include <spawn.h>
#include <signal.h>
#import "Random Object/NSArray+Random.h"

@interface InstallationController ()

@end

@implementation InstallationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *excellent = [NSArray arrayWithObjects:@"Excellent!", @"Great!", @"Fantastic!", @"Awesome!", @"Epic!", @"Nice!", nil];
    
    self.greatLabel.text = [excellent randomObject];
    
    _completeView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, _completeView.frame.origin.y, _completeView.frame.size.width, _completeView.frame.size.height);
    
    _logView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, _logView.frame.origin.y, _logView.frame.size.width, _logView.frame.size.height);
    
    _state = 0;
    
    [_actionButton setTitle:@"Confirm" forState:UIControlStateNormal];
    
    _tempNext.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.arrowIMG.image = [UIImage imageNamed:@"arrowdark"];
        [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.queueTable.separatorColor = [UIColor colorWithRed:0.235 green:0.235 blue:0.235 alpha:1];
        self.logView.textColor = [UIColor whiteColor];
        self.greatLabel.textColor = [UIColor whiteColor];
        self.finishedLabel.textColor = [UIColor whiteColor];
    }
}
- (IBAction)arrowPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    _state = 0;
}
- (IBAction)respring:(id)sender {
    if (self.state == 2) {
        pid_t pid;
        int status;
    
        const char *uicache[] = {"uicache", NULL};
        posix_spawn(&pid, "/usr/bin/uicache", NULL, NULL, (char* const*)uicache, NULL);
        waitpid(pid, &status, WEXITED);
    
        const char *respring[] = {"killall", "SpringBoard", NULL};
        posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)respring, NULL);
        waitpid(pid, &status, WEXITED);
    } else {
        [self beginInstallation];
    }
}

-(void)beginInstallation {
    self.state = 1;
    [UIView animateWithDuration:0.2f animations:^{
        self.actionButton.alpha = 0;
        self.actionButton.enabled = NO;
        
        self.tempNext.hidden = NO;
        
        self.logView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - self.logView.frame.size.width / 2, self.logView.frame.origin.y, self.logView.frame.size.width, self.logView.frame.size.height);
        
        self.queueTable.frame = CGRectMake(0 - [UIScreen mainScreen].bounds.size.width, self.queueTable.frame.origin.y, self.queueTable.frame.size.width, self.queueTable.frame.size.height);
        [self.actionButton setTitle:@"Next" forState:UIControlStateNormal];
    }];
    
    //
    // WHEN DONE:
    //
    // DO [self finished];
    //
}
- (IBAction)temporaryNext:(id)sender {
    [self finished];
}

-(void)finished {
    _state = 2;
    [UIView animateWithDuration:0.2f animations:^{
        self.actionButton.alpha = 1;
        self.actionButton.enabled = YES;
        
        self.tempNext.hidden = YES;
        
        self.completeView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - self.completeView.frame.size.width / 2, self.completeView.frame.origin.y, self.completeView.frame.size.width, self.completeView.frame.size.height);
        
        self.logView.frame = CGRectMake(0 - [UIScreen mainScreen].bounds.size.width, self.logView.frame.origin.y, self.logView.frame.size.width, self.logView.frame.size.height);
        
        [self.actionButton setTitle:@"Respring" forState:UIControlStateNormal];
    }];
    
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    _state = 0;
}

@end
