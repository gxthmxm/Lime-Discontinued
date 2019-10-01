//
//  LMRepo.h
//  Lime
//
//  Created by ArtikusHG on 9/19/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LMRepo : NSObject

- (instancetype)initWithName:(NSString *)name filename:(NSString *)filename urlString:(NSString *)urlString;

// Artikus
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSString *urlString;

// EvenDev
@property (nonatomic, retain) NSString *origin;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *suite;
@property (nonatomic, retain) NSString *version;
@property (nonatomic, retain) NSString *codename;
@property (nonatomic, retain) NSString *architectures;
@property (nonatomic, retain) NSString *components;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSMutableArray *packages;
@property (nonatomic, retain) NSDate *lastUpdated;

@property (nonatomic, retain) NSString *releaseURL;
@property (nonatomic, retain) NSString *packagesURL;
@property (nonatomic, retain) NSString *releasePath;
@property (nonatomic, retain) NSString *packagesPath;
@property (nonatomic, retain) NSURL *imageURL;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *imagePath;
@property (nonatomic, retain) NSString *repoURL;
@property (nonatomic, retain) NSString *repoDirectory;
@property (nonatomic, retain) NSArray *repoComponents;

@end
