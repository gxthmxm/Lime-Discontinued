//
//  InstalledViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "InstalledViewController.h"
#import "DepictionViewController.h"

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
    cell.detailTextLabel.alpha = 0.5;
    UIImage *icon = [UIImage imageWithContentsOfFile:[self.parser.packageIcons objectAtIndex:indexPath.row]];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(40,40), NO, [UIScreen mainScreen].scale);
    [icon drawInRect:CGRectMake(0,0,40,40)];
    icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 10;
    cell.imageView.image = icon;
    
    /*
    UIButton *getButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 90, 20, 74, 30)];
    getButton.backgroundColor = [UIColor colorWithRed:0.95 green:0.94 blue:0.96 alpha:1.0];
    getButton.layer.cornerRadius = 15;
    [getButton setTitle:@"GET" forState:UIControlStateNormal];
    [getButton setTitleColor:[[[UIApplication sharedApplication] delegate] window].tintColor forState:UIControlStateNormal];
    [getButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [cell addSubview:getButton];
     */
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"packageInfo" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DepictionViewController *depictionViewController = segue.destinationViewController;
    NSInteger index = [(UITableView *)self.view indexPathForSelectedRow].row;
    depictionViewController.package = [self.parser.packageIDs objectAtIndex:index];
    depictionViewController.name = [self.parser.packageNames objectAtIndex:index];
    depictionViewController.packageDesc = [self.parser.packageDescs objectAtIndex:index];
    depictionViewController.author = [self.parser.packageAuthors objectAtIndex:index];
    depictionViewController.depictionURL = [self.parser.packageDepictions objectAtIndex:index];
    depictionViewController.icon = [UIImage imageWithContentsOfFile:[self.parser.packageIcons objectAtIndex:index]];
    depictionViewController.installed = YES;
}

@end
