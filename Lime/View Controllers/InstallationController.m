//
//  ChangesViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "InstallationController.h"

@interface InstallationController ()

@end

@implementation InstallationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *excellent = [NSArray arrayWithObjects:@"Excellent!", @"Great!", @"Fantastic!", @"Awesome!", @"Epic!", @"Nice!", nil];
    
    self.greatLabel.text = [excellent randomObject];
    
    _completeView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, _completeView.frame.origin.y, _completeView.frame.size.width, _completeView.frame.size.height);
    
    _logView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, _logView.frame.origin.y, _logView.frame.size.width, _logView.frame.size.height);
    
    _state = 0;
    
    [_actionButton setTitle:@"Confirm" forState:UIControlStateNormal];
    
    _tempNext.hidden = YES;
    
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
    if ([LimeHelper darkMode]) {
        cell.detailTextLabel.textColor = [LMColor labelColor];
        cell.textLabel.textColor = [LMColor labelColor];
    }
    cell.detailTextLabel.alpha = 0.5;
    UIImage *icon = [UIImage imageNamed:[NSString stringWithFormat:@"sections/%@", package.section]];
    if (![package.iconPath containsString:@"https://"] || [package.iconPath containsString:@"http://"]) {
        icon = [LimeHelper iconFromPackage:package];
    }
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(30,30), NO, [UIScreen mainScreen].scale);
    [icon drawInRect:CGRectMake(0,0,30,30)];
    icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 6;
    cell.imageView.image = icon;
    cell.separatorInset = UIEdgeInsetsMake(0, 73, 0, 28);
    cell.layoutMargins = UIEdgeInsetsMake(cell.contentView.layoutMargins.top, 28, cell.contentView.layoutMargins.bottom, cell.contentView.layoutMargins.right);
    
    return cell;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if([LimeHelper darkMode]) {
        self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.arrowIMG.image = [UIImage imageNamed:@"arrowdark"];
        [_actionButton setTitleColor:[LMColor labelColor] forState:UIControlStateNormal];
        self.queueTable.separatorColor = [LMColor separatorColor];
        self.logView.textColor = [LMColor labelColor];
        self.greatLabel.textColor = [LMColor labelColor];
        self.finishedLabel.textColor = [LMColor labelColor];
        [self.clearQueueButton setTitleColor:[LMColor labelColor] forState:UIControlStateNormal];
        self.ecksView.image = [LimeHelper imageWithName:@"darkx"];
    }
}
- (IBAction)arrowPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)respring:(id)sender {
    if (self.state == 2) {
        pid_t pid;
        int status;
    
        const char *uicache[] = {"uicache", NULL};
        posix_spawn(&pid, "/usr/bin/uicache", NULL, NULL, (char* const*)uicache, NULL);
        waitpid(pid, &status, WEXITED);
    
        const char *respring[] = {"killall", "SpringBoard", NULL};
        posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)respring, NULL);
        waitpid(pid, &status, WEXITED);
    } else {
        [self beginInstallation];
    }
}
- (IBAction)clearQueue:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray new] forKey:@"queue"];
    [self.queueTable reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)beginInstallation {
    self.state = 1;
    [UIView animateWithDuration:0.2f animations:^{
        self.actionButton.alpha = 0;
        self.actionButton.enabled = NO;
        
        self.tempNext.hidden = NO;
        
        self.logView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - self.logView.frame.size.width / 2, self.logView.frame.origin.y, self.logView.frame.size.width, self.logView.frame.size.height);
        
        self.queueTable.frame = CGRectMake(0 - [UIScreen mainScreen].bounds.size.width, self.queueTable.frame.origin.y, self.queueTable.frame.size.width, self.queueTable.frame.size.height);
        self.clearQueueButton.frame = CGRectMake(0 - [UIScreen mainScreen].bounds.size.width, self.clearQueueButton.frame.origin.y, self.queueTable.frame.size.width, self.queueTable.frame.size.height);
        self.ecksView.alpha = 0;
        [self.actionButton setTitle:@"Next" forState:UIControlStateNormal];
    }];
    
    //
    // INSTALLATION
    //
    
    NSMutableArray *remove = [NSMutableArray new];
    NSMutableArray *install = [NSMutableArray new];
    NSMutableArray *reinstall = [NSMutableArray new];
    for (NSData *encodedAction in [LMQueue queueActions]) {
        LMQueueAction *decodedAction = [NSKeyedUnarchiver unarchiveObjectWithData:encodedAction];
        
        switch (decodedAction.action) {
            case 0:
                [install addObject:[NSString stringWithFormat:@"%@", decodedAction.package.identifier]];
                break;
                
            case 1:
                [remove addObject:[NSString stringWithFormat:@"%@", decodedAction.package.identifier]];
                break;
                
            case 2:
                [reinstall addObject:[NSString stringWithFormat:@"%@", decodedAction.package.identifier]];
                break;
                
            default:
                break;
        }
        
        self.logView.text = [NSString stringWithFormat:@"Install:\n%@\n\nRemove:\n%@\n\nReinstall:\n%@", [install componentsJoinedByString:@"\n"], [remove componentsJoinedByString:@"\n"], [reinstall componentsJoinedByString:@"\n"]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray new] forKey:@"queue"];
    
    //
    // WHEN DONE:
    //
    // DO [self finished];
    //
}
- (IBAction)temporaryNext:(id)sender {
    [self finished];
}

-(void)finished {
    _state = 2;
    [UIView animateWithDuration:0.2f animations:^{
        self.actionButton.alpha = 1;
        self.actionButton.enabled = YES;
        
        self.tempNext.hidden = YES;
        
        self.completeView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - self.completeView.frame.size.width / 2, self.completeView.frame.origin.y, self.completeView.frame.size.width, self.completeView.frame.size.height);
        
        self.logView.frame = CGRectMake(0 - [UIScreen mainScreen].bounds.size.width, self.logView.frame.origin.y, self.logView.frame.size.width, self.logView.frame.size.height);
        
        [self.actionButton setTitle:@"Respring" forState:UIControlStateNormal];
    }];
    
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    _state = 0;
}

// Keep out, the backend starts
// Staccoverflow

UITextView *a;
BOOL terminated;
- (void)runAptWithArgs:(NSArray *)args {
    args = @[];
    terminated = NO;
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/LimeHelper"];
    [task setArguments:args];
    NSPipe *pipe = [NSPipe pipe];
    NSPipe *errorPipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    [task setStandardError:errorPipe];
    
    
    //[task setStandardInput:[NSPipe pipe]];
    
    NSFileHandle *outFile = [pipe fileHandleForReading];
    NSFileHandle *errFile = [errorPipe fileHandleForReading];
    
    [task launch];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(terminated:) name:NSTaskDidTerminateNotification object:task];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outData:) name:NSFileHandleDataAvailableNotification object:outFile];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errData:) name:NSFileHandleDataAvailableNotification object:errFile];
    [outFile waitForDataInBackgroundAndNotify];
    [errFile waitForDataInBackgroundAndNotify];
    while(!terminated) if (![[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) break;
    //[task waitUntilExit];
}


- (void)outData:(NSNotification *)notification {
    NSFileHandle *fileHandle = (NSFileHandle*)[notification object];
    [fileHandle waitForDataInBackgroundAndNotify];
    // Append data to textview here
    
    a.text = [a.text stringByAppendingString:[[NSString alloc] initWithData:[fileHandle availableData] encoding:NSUTF8StringEncoding]];
}


- (void)errData:(NSNotification *)notification {
    NSFileHandle *fileHandle = (NSFileHandle*)[notification object];
    [fileHandle waitForDataInBackgroundAndNotify];
    // Append data to textview here
}

- (void)terminated:(NSNotification *)notification {
    // Go to finished view here
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    terminated = YES;
    self.logView.text = a.text;
    [self finished];
}

@end
