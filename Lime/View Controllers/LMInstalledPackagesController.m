//
//  LMInstalledPackagesController.m
//  Lime
//
//  Created by Even Flatabø on 19/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMInstalledPackagesController.h"

@interface LMInstalledPackagesController ()

@end

@implementation LMInstalledPackagesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.packages = [[LimeHelper sharedInstance] installedPackagesArray];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.packages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMInstalledPackageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"installedcell" forIndexPath:indexPath];
    
    LMPackage *pkg = [self.packages objectAtIndex:indexPath.row];
    cell.textLabel.text = pkg.name;
    cell.detailTextLabel.text = pkg.desc;
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
    if ([UIImage imageNamed:pkg.section]) {
        cell.imageView.image = [UIImage imageNamed:pkg.section];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"Unknown"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"depiction" sender:self];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"depiction"]) {
        LMDepictionController *dest = segue.destinationViewController;
        dest.package = [self.packages objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
}


@end
