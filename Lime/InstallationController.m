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

@interface InstallationController ()

@end

@implementation InstallationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)arrowPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)respring:(id)sender {
    pid_t pid;
    int status;
    
    const char *argv[] = {"killall", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)argv, NULL);
    waitpid(pid, &status, WEXITED);
    
}
- (IBAction)dragging:(id)sender {
    
}

@end
