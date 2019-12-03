//
//  LMHomeCollectionController.h
//  Lime
//
//  Created by Even Flatabø on 18/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../UI Elements/LMTweakOfTheWeekCell.h"
#import "../UI Elements/LMThemeOfTheWeekCell.h"
#import "../Helpers/LMHomeStoryDownloader.h"
#import "../Parsers/LMRepoParser.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMHomeCollectionController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSDictionary *stories;
@property (nonatomic, strong) NSData *storiesData;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *storiesDateFormatter;

@property (nonatomic, strong) NSMutableArray *cards;

@end

NS_ASSUME_NONNULL_END
