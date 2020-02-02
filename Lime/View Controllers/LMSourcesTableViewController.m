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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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

@end
