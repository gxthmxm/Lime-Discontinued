//
//  InstalledViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "InstalledViewController.h"

@interface InstalledViewController ()

@end

@implementation InstalledViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.parser = [[LMDPKGParser alloc] init];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.parser.packageNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.textLabel.text = [self.parser.packageNames objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.parser.packageDescs objectAtIndex:indexPath.row];
    UIImage *icon = [UIImage imageWithContentsOfFile:[self.parser.packageIcons objectAtIndex:indexPath.row]];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(40,40), NO, [UIScreen mainScreen].scale);
    [icon drawInRect:CGRectMake(0,0,40,40)];
    icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 10;
    cell.imageView.image = icon;
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Info goes here
}

@end
