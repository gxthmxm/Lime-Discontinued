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
#import "NSArray+Random.h"

@interface InstallationController ()

@end

@implementation InstallationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *excellent = [NSArray arrayWithObjects:@"Excellent!", @"Great!", @"Fantastic!", @"Awesome!", @"Epic!", @"Nice!", nil];
    
    self.greatLabel.text = [excellent randomObject];
}
- (IBAction)arrowPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)respring:(id)sender {
    pid_t pid;
    int status;
    
    const char *uicache[] = {"uicache", NULL};
    posix_spawn(&pid, "/usr/bin/uicache", NULL, NULL, (char* const*)uicache, NULL);
    waitpid(pid, &status, WEXITED);
    
    const char *respring[] = {"killall", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)respring, NULL);
    waitpid(pid, &status, WEXITED);
    
}
- (IBAction)dragging:(id)sender {
    
}

@end
