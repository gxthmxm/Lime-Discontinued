//
//  LMSourcesTableViewController.m
//  Lime
//
//  Created by Conor Byrne on 02/02/2020.
//  Copyright © 2020 Citrusware. All rights reserved.
//

#import "LMSourcesTableViewController.h"

@interface LMSourcesTableViewController ()

@end

@implementation LMSourcesTableViewController

- (IBAction)addSource:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add Source" message:@"Please enter a repo URL" preferredStyle:UIAlertControllerStyleAlert];
    
    //
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"https://";
    }];
    
    // Create Actions
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"URL: %@", alertController.textFields[0].text);
        //compare the current password and do action here

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL];
    
    // Add Actions
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    
    // Present
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.leftBarButtonItem = self.editButtonItem;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sourceCell" forIndexPath:indexPath];

    cell.textLabel.text = @"Repository";
    cell.detailTextLabel.text = @"https://example.com";
    cell.imageView.image = [UIImage imageNamed:@"Sources"];
        
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	char result[2];
	result[1] = 0;
	result[0] = ('A' + section);
	return @(result);
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return @[@"A", @"B", @"C"];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
