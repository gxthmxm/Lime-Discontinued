//
//  LMPackage.h
//  Lime
//
//  Created by PixelOmer on 2.02.2020.
//  Copyright © 2020 Citrusware. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMPackage : NSObject

@end

@interface LMPackage(FieldMethods)
- (NSString *)package;
- (NSString *)version;
- (NSString *)sileoDepiction;
- (NSString *)depiction;
@end

NS_ASSUME_NONNULL_END
