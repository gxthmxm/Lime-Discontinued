//
//  LMQueueController.m
//  Lime
//
//  Created by Even Flatabø on 02/12/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMQueueController.h"

@interface LMQueueController ()

@end

@implementation LMQueueController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *excellent = [NSArray arrayWithObjects:@"Excellent!", @"Great!", @"Fantastic!", @"Awesome!", @"Epic!", @"Nice!", nil];
    
    self.greatLabel.text = [excellent randomObject];
    
    self.completeView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, self.completeView.frame.origin.y, self.completeView.frame.size.width, self.completeView.frame.size.height);
    
    self.logView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, self.logView.frame.origin.y, self.logView.frame.size.width, self.logView.frame.size.height);
    
    self.state = 0;
    
    [self.actionButton setTitle:@"Confirm" forState:UIControlStateNormal];
    
    self.queue = [[LMQueue alloc] init];
    
    self.queueTable.delegate = self;
    self.queueTable.dataSource = self;
    
    if ([LMQueue queueActions].count < 1) {
        self.actionButton.enabled = NO;
        self.actionButton.alpha = 0.4;
    }
    
    self.queueTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [LMQueue removeObjectFromQueueWithIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        if ([LMQueue queueActions].count < 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LMQueue queueActions].count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *queue = [NSMutableArray arrayWithArray:[LMQueue queueActions]];
    LMQueueAction *action = [NSKeyedUnarchiver unarchiveObjectWithData:[queue objectAtIndex:indexPath.row]];
    LMPackage *package = action.package;
    
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.textLabel.text = package.name;
    switch (action.action) {
        case 0:
            cell.detailTextLabel.text = @"Install";
            break;
            
        case 1:
            cell.detailTextLabel.text = @"Remove";
            break;
            
        case 2:
            cell.detailTextLabel.text = @"Reinstall";
            break;
            
        default:
            break;
    }
    cell.detailTextLabel.alpha = 0.5;
    UIImage *icon;
    if (package.iconPath.length > 0
        && [[NSFileManager defaultManager] fileExistsAtPath:package.iconPath]) {
        icon = [UIImage imageWithContentsOfFile:package.iconPath];
    } else {
        if ([UIImage imageNamed:package.section]) icon = [UIImage imageNamed:package.section];
        else icon = [UIImage imageNamed:@"Unknown"];
    }
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(30,30), NO, [UIScreen mainScreen].scale);
    [icon drawInRect:CGRectMake(0,0,30,30)];
    icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 6.75;
    cell.imageView.image = icon;
    cell.separatorInset = UIEdgeInsetsMake(0, 73, 0, 28);
    cell.layoutMargins = UIEdgeInsetsMake(cell.contentView.layoutMargins.top, 28, cell.contentView.layoutMargins.bottom, cell.contentView.layoutMargins.right);
    
    return cell;
}

- (IBAction)arrowPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)respring:(id)sender {
    if (self.state == 2) {
    } else {
        [self beginInstallation];
    }
}

-(void)beginInstallation {
    self.state = 1;
    self.logViewFrame = self.effectView.frame;
    [UIView animateWithDuration:0.2f animations:^{
        self.actionButton.alpha = 0;
        self.actionButton.enabled = NO;
        
        self.arrowIMG.alpha = 0;
        
        self.effectView.frame = self.view.frame;
        self.effectView.layer.cornerRadius = 0;
        
        self.logView.frame = CGRectMake(16, 16, self.view.frame.size.width - 32, self.view.frame.size.height - 16);
        
        self.queueTable.frame = CGRectMake(0 - [UIScreen mainScreen].bounds.size.width, self.queueTable.frame.origin.y, self.queueTable.frame.size.width, self.queueTable.frame.size.height);
        [self.actionButton setTitle:@"Next" forState:UIControlStateNormal];
    }];
    
    //
    // INSTALLATION
    //
    self.logView.text = @"";
    
    NSInteger tasks = [LMQueue queueActions].count;
    __block NSInteger completedTasks = 0;
    
    // 0 install 1 remove 2 reinstall
    BOOL isDir;
    [NSFileManager.defaultManager fileExistsAtPath:LimeHelper.tmpPath isDirectory:&isDir];
    if (!isDir) [NSFileManager.defaultManager createDirectoryAtPath:LimeHelper.tmpPath withIntermediateDirectories:NO attributes:0 error:nil];
    for (NSData *encodedAction in [LMQueue queueActions]) {
        LMQueueAction *decodedAction = [NSKeyedUnarchiver unarchiveObjectWithData:encodedAction];
        if (decodedAction.action == 0) {
            if (decodedAction.package.filename) {
                self.logView.text = [self.logView.text stringByAppendingFormat:@"\nDownloading %@", decodedAction.package.identifier];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [LMDownloader.new downloadFileWithURLString:decodedAction.package.debURL toFile:[LimeHelper.tmpPath stringByAppendingString:[decodedAction.package.filename componentsSeparatedByString:@"/"].lastObject] progressView:nil completionHandler:^(NSError * _Nullable error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.logView.text = [self.logView.text stringByAppendingFormat:@"\nFinished downloading %@", decodedAction.package.identifier];
                            completedTasks++;
                            if (completedTasks == tasks) [self finished];
                        });
                    }];
                });
            }
        } else if (decodedAction.action == 1) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                self.logView.text = [self.logView.text stringByAppendingString:@"\nLime can't remove packages yet."];
            });
        } else if (decodedAction.action == 2) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                self.logView.text = [self.logView.text stringByAppendingString:@"\nLime can't reinstall packages yet."];
            });
        }
    };
    NSLog(@"[Queue] DONE!");
    //[NSFileManager.defaultManager removeItemAtPath:LimeHelper.tmpPath error:nil];
}

-(void)finished {
    _state = 2;
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray new] forKey:@"queue"];
    [UIView animateWithDuration:0.2f animations:^{
        self.actionButton.alpha = 1;
        self.actionButton.enabled = YES;
        
        self.arrowIMG.alpha = 1;
        
        self.effectView.frame = self.logViewFrame;
        self.effectView.layer.cornerRadius = 20;
        
        self.completeView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - self.completeView.frame.size.width / 2, self.completeView.frame.origin.y, self.completeView.frame.size.width, self.completeView.frame.size.height);
        
        self.logView.frame = CGRectMake(0 - [UIScreen mainScreen].bounds.size.width, self.logView.frame.origin.y, self.logView.frame.size.width, self.logView.frame.size.height);
        
        [self.actionButton setTitle:@"Respring" forState:UIControlStateNormal];
    }];
    
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    _state = 0;
}

@end
