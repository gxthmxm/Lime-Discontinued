//
//  RepoPackagesViewController.m
//  Lime
//
//  Created by EvenDev on 20/09/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "RepoPackagesViewController.h"

@interface RepoPackagesViewController ()

@end

@implementation RepoPackagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.repo.label;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.repo.packages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMPackage *package = [self.repo.packages objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.textLabel.text = package.name;
    cell.detailTextLabel.text = package.desc;
    cell.detailTextLabel.alpha = 0.5;
    UIImage *icon = [UIImage imageNamed:[NSString stringWithFormat:@"sections/%@", package.section]];
    if (package.iconPath.length > 0) {
        if (![package.iconPath containsString:@"https://"] || [package.iconPath containsString:@"http://"]) {
            icon = [LimeHelper iconFromPackage:package];
        }
    }
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(40,40), NO, [UIScreen mainScreen].scale);
    [icon drawInRect:CGRectMake(0,0,40,40)];
    icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 10;
    cell.imageView.image = icon;
    if ([[[LimeHelper sharedInstance] installedPackagesDict] objectForKey:package.identifier]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    if ([LimeHelper darkMode]) {
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [LMColor selectedTableViewCellColor];
        [cell setSelectedBackgroundView:bgColorView];
    }
    
    /*
     UIButton *getButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 90, 20, 74, 30)];
     getButton.backgroundColor = [UIColor colorWithRed:0.95 green:0.94 blue:0.96 alpha:1.0];
     getButton.layer.cornerRadius = 15;
     [getButton setTitle:@"GET" forState:UIControlStateNormal];
     [getButton setTitleColor:[[[UIApplication sharedApplication] delegate] window].tintColor forState:UIControlStateNormal];
     [getButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
     [cell addSubview:getButton];
     */
    
    if ([LimeHelper darkMode]) {
        cell.textLabel.textColor = [LMColor labelColor];
        cell.detailTextLabel.textColor = [LMColor labelColor];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"repoPackage" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"repoPackage"]) {
        DepictionViewController *vc = segue.destinationViewController;
        vc.package = [self.repo.packages objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
}

@end
