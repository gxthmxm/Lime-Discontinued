//
//  ConfigSelectRepoController.m
//  Lime
//
//  Created by EvenDev on 21/09/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "ConfigSelectRepoController.h"

@interface ConfigSelectRepoController ()

@end

@implementation ConfigSelectRepoController

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
