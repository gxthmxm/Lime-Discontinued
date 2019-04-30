//
//  ChangesViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "DepictionScrollView.h"

@interface DepictionScrollView () <UIScrollViewDelegate>
@end

@implementation DepictionScrollView
 
 /*-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
     CGPoint scrollOffset = scrollView.contentOffset;
     if (scrollOffset.y >= 40) {
        if (![DepictionViewController.navigationController isNavigationBarHidden]) {
            [self.superview.superview.superview.navigationController setNavigationBarHidden:YES animated:YES];
        }
     } else {
         if ([self.superview.superview.superview.navigationController isNavigationBarHidden]) {
             [self.superview.superview.superview.navigationController setNavigationBarHidden:NO animated:YES];
         }
     }
 }*/

@end
