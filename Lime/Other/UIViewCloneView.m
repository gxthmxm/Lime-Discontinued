//
//  UIView+CloneView.m
//  Lime
//
//  Created by EvenDev on 21/09/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "UIViewCloneView.h"

@implementation UIView (CloneView)

-(id)clone {
    NSData *archivedViewData = [NSKeyedArchiver archivedDataWithRootObject:self];
    id clone = [NSKeyedUnarchiver unarchiveObjectWithData:archivedViewData];
    return clone;
}

@end
