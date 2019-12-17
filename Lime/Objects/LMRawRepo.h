//
//  LMRawRepo.h
//  Lime
//
//  Created by Even Flatabø on 17/12/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMRawRepo : NSObject

@property (nonatomic, retain) NSDate *lastUpdated;
@property (nonatomic, retain) NSDate *lastDownloaded;

@property (nonatomic, retain) NSString *releaseURL;
@property (nonatomic, retain) NSString *packagesURL;
@property (nonatomic, retain) NSString *releasePath;
@property (nonatomic, retain) NSString *packagesPath;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *imagePath;
@property (nonatomic, retain) NSString *repoURL;
@property (nonatomic, retain) NSString *distros;
@property (nonatomic, retain) NSArray *distrosArray;

@end

NS_ASSUME_NONNULL_END
