//
//  LMHomeCollectionController.m
//  Lime
//
//  Created by Even Flatabø on 18/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMHomeCollectionController.h"

@interface LMHomeCollectionController ()

@end

@implementation LMHomeCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.extendedLayoutIncludesOpaqueBars = NO;
    [self.navigationController setNavigationBarHidden:YES];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[LimeHelper documentDirectory] stringByAppendingString:@"stories"]]) [[NSFileManager defaultManager] createDirectoryAtPath:[[LimeHelper documentDirectory] stringByAppendingString:@"stories"] withIntermediateDirectories:YES attributes:0 error:nil];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[LimeHelper documentDirectory] stringByAppendingString:@"stories/icons"]]) [[NSFileManager defaultManager] createDirectoryAtPath:[[LimeHelper documentDirectory] stringByAppendingString:@"stories/icons"] withIntermediateDirectories:YES attributes:0 error:nil];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[LimeHelper documentDirectory] stringByAppendingString:@"stories/background"]]) [[NSFileManager defaultManager] createDirectoryAtPath:[[LimeHelper documentDirectory] stringByAppendingString:@"stories/background"] withIntermediateDirectories:YES attributes:0 error:nil];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[LimeHelper documentDirectory] stringByAppendingString:@"stories/foreground"]]) [[NSFileManager defaultManager] createDirectoryAtPath:[[LimeHelper documentDirectory] stringByAppendingString:@"stories/foreground"] withIntermediateDirectories:YES attributes:0 error:nil];
    
    self.cards = [NSMutableArray new];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LMTweakOfTheWeekCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"tweakoftheweek"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LMThemeOfTheWeekCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"themeoftheweek"];
    [self grabStories];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)grabStories {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://evendeveloper.github.io/lime/story/stories.json"]];
    if (data) {
        NSError *error;
        self.stories = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) NSLog(@"%@", error);
        if (self.stories) {
            NSNumber *amount = [self.stories objectForKey:@"amount"];
            int i;
            for(i=0;i<[amount intValue];i++)
            {
                NSDictionary *card = [self.stories objectForKey:[NSString stringWithFormat:@"card-%d", i + 1]];
                if ([[card objectForKey:@"type"] isEqual:@"tweakotw"]) {
                    [LMHomeStoryDownloader downloadTweakOfTheWeek:card toArray:self.cards];
                } else if ([[card objectForKey:@"type"] isEqual:@"themeotw"]) {
                    [LMHomeStoryDownloader downloadThemeOfTheWeek:card toArray:self.cards];
                }
            }
        }
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cards.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id card = [self.cards objectAtIndex:indexPath.row];
    if ([card class] == [LMTweakOfTheWeekCell class]) {
        LMTweakOfTheWeekCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tweakoftheweek" forIndexPath:indexPath];
        LMTweakOfTheWeekCell *cardcell = [self.cards objectAtIndex:indexPath.row];
        cell.backgroundImageView.image = cardcell.backgroundImageView.image;
        cell.foregroundView.image = cardcell.foregroundView.image;
        cell.iconView.image = cardcell.iconView.image;
        cell.packageTitle.text = cardcell.packageTitle.text;
        cell.packageDescription.text = cardcell.packageDescription.text;
        cell.repository = cardcell.repository;
        cell.packageIdentifier = cardcell.packageIdentifier;
        cell.storyURL = cardcell.storyURL;
        
        cell.frame = CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width - 40, 420);
        return cell;
    } else if ([card class] == [LMThemeOfTheWeekCell class]) {
        LMThemeOfTheWeekCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"themeoftheweek" forIndexPath:indexPath];
        LMThemeOfTheWeekCell *cardcell = [self.cards objectAtIndex:indexPath.row];
        cell.backgroundImageView.image = cardcell.backgroundImageView.image;
        cell.foregroundView.image = cardcell.foregroundView.image;
        cell.iconView.image = cardcell.iconView.image;
        cell.packageTitle.text = cardcell.packageTitle.text;
        cell.packageDescription.text = cardcell.packageDescription.text;
        cell.repository = cardcell.repository;
        cell.packageIdentifier = cardcell.packageIdentifier;
        cell.storyURL = cardcell.storyURL;
        
        NSLog(@"%@", cell);
        
        cell.frame = CGRectMake(20, 450, [UIScreen mainScreen].bounds.size.width - 40, 420);
        
        return cell;
    } else {
        LMTweakOfTheWeekCell *cell;
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tweakoftheweek" forIndexPath:indexPath];
        return cell;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    id cell = [self.cards objectAtIndex:indexPath.row];
    if ([cell class] == [LMTweakOfTheWeekCell class]) {
        LMTweakOfTheWeekCell *bruh = cell;
        int width = [UIScreen mainScreen].bounds.size.width - 40;
        float height = width * bruh.ratio;
        return CGSizeMake(width, height);
    } else if ([cell class] == [LMThemeOfTheWeekCell class]) {
        LMThemeOfTheWeekCell *bruh = cell;
        int width = [UIScreen mainScreen].bounds.size.width - 40;
        float height = width * bruh.ratio;
        return CGSizeMake(width, height);
    } else {
        return CGSizeZero;
    }
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
