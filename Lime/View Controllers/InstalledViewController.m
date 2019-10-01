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
    self.packages = [[LimeHelper sharedInstance] installedPackagesArray];
    /*NSArray *sortedPackages = [self.parser.packages allKeys];
    sortedPackages = [sortedPackages sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];*/

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([LimeHelper darkMode]) {
        self.tableView.backgroundColor = [LMColor backgroundColor];
        self.tableView.separatorColor = [LMColor separatorColor];
        self.navigationController.navigationBar.barStyle = 1;
        self.tabBarController.tabBar.barStyle = 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.packages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMPackage *package = [self.packages objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.textLabel.text = package.name;
    cell.detailTextLabel.text = package.desc;
    cell.detailTextLabel.alpha = 0.5;
    UIImage *icon = [LimeHelper iconFromPackage:package];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(40,40), NO, [UIScreen mainScreen].scale);
    [icon drawInRect:CGRectMake(0,0,40,40)];
    icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 10;
    cell.imageView.image = icon;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (IBAction)openQueue:(id)sender {
    [self performSegueWithIdentifier:@"openQue" sender:self];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LMPackage *package = [self.packages objectAtIndex:indexPath.row];
        [LMQueue addQueueAction:[[LMQueueAction alloc] initWithPackage:package action:1]];
        FirstLaunchDeciderController *vc = (FirstLaunchDeciderController *)self.tabBarController;
        [vc showBannerWithMessage:[NSString stringWithFormat:@"Successfully added %@ to the queue", package.identifier] type:0 target:self selector:@selector(openQueue:)];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"packageInfo" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"packageInfo"]) {
        DepictionViewController *depictionViewController = segue.destinationViewController;
        NSInteger index = [self.tableView indexPathForSelectedRow].row;
        
        LMPackage *package = [self.packages objectAtIndex:index];
        depictionViewController.package = package;
    }
}

@end
