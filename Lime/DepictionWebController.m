//
//  DepictionWebController.m
//  Lime
//
//  Created by EvenDev on 03/07/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DepictionWebController.h"

@implementation DepictionWebController

-(void)viewDidLoad {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}

@end
