//
//  ConfigControllers.m
//  Lime
//
//  Created by EvenDev on 30/05/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "ConfigControllers.h"

@implementation ConfigStartController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
}

@end

@implementation ConfigRepoController

@end

@implementation ConfigSelectRepoController

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
