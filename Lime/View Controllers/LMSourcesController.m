//
//  LMSourcesController.m
//  Lime
//
//  Created by Even Flatabø on 28/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMSourcesController.h"

@interface LMSourcesController ()

@end

@implementation LMSourcesController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self parseRepoData];
    [LMSourceManager.sharedInstance setSourceController:self];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    self.topProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [navBar addSubview:self.topProgressView];
    self.topProgressView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.topProgressView.widthAnchor constraintEqualToAnchor:navBar.widthAnchor constant:0].active = YES;
    [self.topProgressView.topAnchor constraintEqualToAnchor:navBar.bottomAnchor constant:-2.5].active = YES;
}

-(IBAction)refreshButtonAction:(id)sender {
    [NSFileManager.defaultManager removeItemAtPath:LimeHelper.listsPath error:nil];
    [NSFileManager.defaultManager createDirectoryAtPath:LimeHelper.listsPath withIntermediateDirectories:NO attributes:0 error:nil];
    //[NSFileManager.defaultManager removeItemAtPath:LimeHelper.iconsPath error:nil];
    //[NSFileManager.defaultManager createDirectoryAtPath:LimeHelper.iconsPath withIntermediateDirectories:NO attributes:0 error:nil];
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    [self.tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.userInteractionEnabled = NO;
    }];
    NSDate *started = [NSDate date];
    [LMSourceManager.sharedInstance refreshSourcesCompletionHandler:^{
        NSLog(@"[SourceManager] %lu sources refreshed in %f seconds", (unsigned long)LMSourceManager.sharedInstance.sources.count, [[NSDate date] timeIntervalSinceDate:started]);
        [self.tableView reloadData];
        self.navigationController.navigationBar.userInteractionEnabled = YES;
        [self.tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.userInteractionEnabled = YES;
        }];
    }];
}

// UITableView stuff

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LMSourceManager.sharedInstance sources].count;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *refreshBtn = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Refresh" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        self.navigationController.navigationBar.userInteractionEnabled = NO;
        [self.tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.userInteractionEnabled = NO;
        }];
        
        LMRepo *repo = [LMSourceManager.sharedInstance.sources objectAtIndex:indexPath.row];
        LMSourceCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSDate *started = [NSDate date];
        [LMSourceManager.sharedInstance refreshSource:repo progressView:cell.progressView completionHandler:^{
               NSLog(@"[SourceManager] %@ refreshed in %f seconds", repo.parsedRepo.label, [[NSDate date] timeIntervalSinceDate:started]);
            [cell.progressView setProgress:0];
            [self.tableView reloadData];
            self.navigationController.navigationBar.userInteractionEnabled = YES;
            [self.tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.userInteractionEnabled = YES;
            }];
            cell.textLabel.text = repo.parsedRepo.label;
        }];
    }];
    UITableViewRowAction *deleteBtn = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        LMRepo *repo = [LMSourceManager.sharedInstance.sources objectAtIndex:indexPath.row];
        // ---------------
        // ADD A CONFIRMATION ALERT OR SOMETHING? ITS UP TO YOU EVEN
        // ---------------
        [LimeHelper removeRepo:repo];
        [LMSourceManager.sharedInstance.sources removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];

    return @[deleteBtn, refreshBtn];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {}

- (LMSourceCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"sourcecell";
    LMSourceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    LMRepo *repo = [[LMSourceManager.sharedInstance sources] objectAtIndex:indexPath.row];
    cell.textLabel.text = repo.parsedRepo.label;
    cell.detailTextLabel.text = repo.rawRepo.repoURL;
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 7.65;
    cell.imageView.image = repo.rawRepo.image;
    /*
    if(cell.progressView == nil) {
        cell.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        cell.progressView.frame = CGRectMake(0, 56.5, cell.contentView.frame.size.width, 0);
        if(!cell.progressView.superview) {
            [cell.contentView addSubview:cell.progressView];
            cell.progressView.translatesAutoresizingMaskIntoConstraints = NO;
            [cell.progressView.widthAnchor constraintEqualToAnchor:cell.contentView.widthAnchor constant:0].active = YES;
            [cell.progressView.topAnchor constraintEqualToAnchor:cell.contentView.bottomAnchor constant:-2.5].active = YES;
        }
    }
    if(repo.totalDownloaded != 0 && repo.totalExpectedLength != 0) {
        cell.progressView.progress = (float)repo.totalDownloaded / repo.totalExpectedLength;
    }*/
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"viewsource"]) {
        LMRepo *repo = [[LMSourceManager.sharedInstance sources] objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        LMViewSourcePackagesController *dest = segue.destinationViewController;
        dest.repo = repo;
    }
}

@end
