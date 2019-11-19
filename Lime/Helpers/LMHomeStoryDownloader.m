//
//  LMHomeStoryDownloader.m
//  Lime
//
//  Created by Even Flatabø on 19/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMHomeStoryDownloader.h"

@implementation LMHomeStoryDownloader

+(void)downloadTweakOfTheWeek:(NSDictionary *)json toArray:(NSMutableArray *)array {
    LMTweakOfTheWeekCell *cell = [LMTweakOfTheWeekCell new];
    cell.backgroundImageView = [UIImageView new];
    cell.foregroundView = [UIImageView new];
    cell.iconView = [UIImageView new];
    cell.packageTitle = [UILabel new];
    cell.packageDescription = [UILabel new];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/icons/%@.png", [json objectForKey:@"package-identifier"]]] || [[NSFileManager defaultManager] fileExistsAtPath:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/foreground/%@.png", [json objectForKey:@"package-identifier"]]] || [[NSFileManager defaultManager] fileExistsAtPath:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/background/%@.png", [json objectForKey:@"package-identifier"]]] || [[NSFileManager defaultManager] fileExistsAtPath:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/%@.html", [json objectForKey:@"package-identifier"]]]) {
        UIImage *icon = [UIImage imageWithContentsOfFile:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/icons/%@.png", [json objectForKey:@"package-identifier"]]];
        UIImage *foreground = [UIImage imageWithContentsOfFile:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/foreground/%@.png", [json objectForKey:@"package-identifier"]]];
        UIImage *background = [UIImage imageWithContentsOfFile:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/background/%@.png", [json objectForKey:@"package-identifier"]]];
        cell.iconView.image = icon;
        cell.foregroundView.image = foreground;
        cell.backgroundImageView.image = background;
        cell.packageTitle.text = [json objectForKey:@"package-name"];
        cell.packageDescription.text = [json objectForKey:@"package-desc"];
        cell.repository = [json objectForKey:@"repository"];
        cell.packageIdentifier = [json objectForKey:@"package-identifier"];
        cell.storyURL = [json objectForKey:@"story"];
        cell.ratio = 1.274626865671642;
        [array addObject:cell];
    } else {
        NSData *icon = [NSData dataWithContentsOfURL:[NSURL URLWithString:[json objectForKey:@"package-icon"]]];
        [icon writeToFile:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/icons/%@.png", [json objectForKey:@"package-identifier"]] atomically:YES];
        NSData *foregroundIMG = [NSData dataWithContentsOfURL:[NSURL URLWithString:[json objectForKey:@"foreground-image"]]];
        [foregroundIMG writeToFile:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/foreground/%@.png", [NSURL URLWithString:[json objectForKey:@"package-identifier"]]] atomically:YES];
        NSData *backgroundIMG = [NSData dataWithContentsOfURL:[NSURL URLWithString:[json objectForKey:@"background-image"]]];
        [backgroundIMG writeToFile:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/background/%@.png", [json objectForKey:@"package-identifier"]] atomically:YES];
        NSData *storyFILE = [NSData dataWithContentsOfURL:[NSURL URLWithString:[json objectForKey:@"story"]]];
        [storyFILE writeToFile:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/%@.html", [json objectForKey:@"package-identifier"]] atomically:YES];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/icons/%@.png", [json objectForKey:@"package-identifier"]]] || [[NSFileManager defaultManager] fileExistsAtPath:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/foreground/%@.png", [json objectForKey:@"package-identifier"]]] || [[NSFileManager defaultManager] fileExistsAtPath:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/background/%@.png", [json objectForKey:@"package-identifier"]]] || [[NSFileManager defaultManager] fileExistsAtPath:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/%@.html", [json objectForKey:@"package-identifier"]]]) {
            UIImage *icon = [UIImage imageWithContentsOfFile:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/icons/%@.png", [json objectForKey:@"package-identifier"]]];
            UIImage *foreground = [UIImage imageWithContentsOfFile:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/foreground/%@.png", [json objectForKey:@"package-identifier"]]];
            UIImage *background = [UIImage imageWithContentsOfFile:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/background/%@.png", [json objectForKey:@"package-identifier"]]];
            cell.iconView.image = icon;
            cell.foregroundView.image = foreground;
            cell.backgroundImageView.image = background;
            cell.packageTitle.text = [json objectForKey:@"package-name"];
            cell.packageDescription.text = [json objectForKey:@"package-desc"];
            cell.repository = [json objectForKey:@"repository"];
            cell.packageIdentifier = [json objectForKey:@"package-identifier"];
            cell.storyURL = [json objectForKey:@"story"];
            cell.ratio = 1.274626865671642;
            [array addObject:cell];
        } else {
            NSLog(@"Unknown error downloading story: %@", [json objectForKey:@"package-name"]);
        }
    }
}

+(void)downloadThemeOfTheWeek:(NSDictionary *)json toArray:(NSMutableArray *)array {
    LMThemeOfTheWeekCell *cell = [LMThemeOfTheWeekCell new];
    cell.backgroundImageView = [UIImageView new];
    cell.foregroundView = [UIImageView new];
    cell.iconView = [UIImageView new];
    cell.packageTitle = [UILabel new];
    cell.packageDescription = [UILabel new];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/icons/%@.png", [json objectForKey:@"package-identifier"]]] || [[NSFileManager defaultManager] fileExistsAtPath:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/foreground/%@.png", [json objectForKey:@"package-identifier"]]] || [[NSFileManager defaultManager] fileExistsAtPath:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/background/%@.png", [json objectForKey:@"package-identifier"]]] || [[NSFileManager defaultManager] fileExistsAtPath:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/%@.html", [json objectForKey:@"package-identifier"]]]) {
        UIImage *icon = [UIImage imageWithContentsOfFile:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/icons/%@.png", [json objectForKey:@"package-identifier"]]];
        UIImage *foreground = [UIImage imageWithContentsOfFile:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/foreground/%@.png", [json objectForKey:@"package-identifier"]]];
        UIImage *background = [UIImage imageWithContentsOfFile:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/background/%@.png", [json objectForKey:@"package-identifier"]]];
        cell.iconView.image = icon;
        cell.foregroundView.image = foreground;
        cell.backgroundImageView.image = background;
        cell.packageTitle.text = [json objectForKey:@"package-name"];
        cell.packageDescription.text = [json objectForKey:@"package-desc"];
        cell.repository = [json objectForKey:@"repository"];
        cell.packageIdentifier = [json objectForKey:@"package-identifier"];
        cell.storyURL = [json objectForKey:@"story"];
        cell.ratio = 1.274626865671642;
        [array addObject:cell];
    } else {
        NSData *icon = [NSData dataWithContentsOfURL:[NSURL URLWithString:[json objectForKey:@"package-icon"]]];
        [icon writeToFile:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/icons/%@.png", [json objectForKey:@"package-identifier"]] atomically:YES];
        NSData *foregroundIMG = [NSData dataWithContentsOfURL:[NSURL URLWithString:[json objectForKey:@"foreground-image"]]];
        [foregroundIMG writeToFile:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/foreground/%@.png", [NSURL URLWithString:[json objectForKey:@"package-identifier"]]] atomically:YES];
        NSData *backgroundIMG = [NSData dataWithContentsOfURL:[NSURL URLWithString:[json objectForKey:@"background-image"]]];
        [backgroundIMG writeToFile:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/background/%@.png", [json objectForKey:@"package-identifier"]] atomically:YES];
        NSData *storyFILE = [NSData dataWithContentsOfURL:[NSURL URLWithString:[json objectForKey:@"story"]]];
        [storyFILE writeToFile:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/%@.html", [json objectForKey:@"package-identifier"]] atomically:YES];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/icons/%@.png", [json objectForKey:@"package-identifier"]]] || [[NSFileManager defaultManager] fileExistsAtPath:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/foreground/%@.png", [json objectForKey:@"package-identifier"]]] || [[NSFileManager defaultManager] fileExistsAtPath:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/background/%@.png", [json objectForKey:@"package-identifier"]]] || [[NSFileManager defaultManager] fileExistsAtPath:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/%@.html", [json objectForKey:@"package-identifier"]]]) {
            UIImage *icon = [UIImage imageWithContentsOfFile:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/icons/%@.png", [json objectForKey:@"package-identifier"]]];
            UIImage *foreground = [UIImage imageWithContentsOfFile:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/foreground/%@.png", [json objectForKey:@"package-identifier"]]];
            UIImage *background = [UIImage imageWithContentsOfFile:[[LimeHelper documentDirectory] stringByAppendingFormat:@"stories/background/%@.png", [json objectForKey:@"package-identifier"]]];
            cell.iconView.image = icon;
            cell.foregroundView.image = foreground;
            cell.backgroundImageView.image = background;
            cell.packageTitle.text = [json objectForKey:@"package-name"];
            cell.packageDescription.text = [json objectForKey:@"package-desc"];
            cell.repository = [json objectForKey:@"repository"];
            cell.packageIdentifier = [json objectForKey:@"package-identifier"];
            cell.storyURL = [json objectForKey:@"story"];
            cell.ratio = 1.274626865671642;
            [array addObject:cell];
        } else {
            NSLog(@"Unknown error downloading story: %@", [json objectForKey:@"package-name"]);
        }
    }
}

@end
