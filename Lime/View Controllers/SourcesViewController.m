//
//  SearchViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

// sorry, my comments are stupid. you're supposed to understand more by reading them, but in reality they're mostly for myself. :/

#import "SourcesViewController.h"

@implementation SourcesViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([LimeHelper darkMode]) {
        self.tableView.backgroundColor = [LMColor backgroundColor];
        self.tableView.separatorColor = [LMColor separatorColor];
        self.navigationController.navigationBar.barStyle = 1;
        self.tabBarController.tabBar.barStyle = 1;
    }
}

- (IBAction)refresh:(id)sender {
    [[LimeHelper sharedInstance] refresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *limePath = @"/var/mobile/Documents/Lime/";
    NSString *sourcesPath = @"/var/mobile/Documents/Lime/sources.list";
    NSString *listsPath = @"/var/mobile/Documents/Lime/lists/";
    NSString *iconsPath = @"/var/mobile/Documents/Lime/icons/";
    if(![[NSFileManager defaultManager] fileExistsAtPath:limePath isDirectory:nil]) [[NSFileManager defaultManager] createDirectoryAtPath:limePath withIntermediateDirectories:YES attributes:nil error:nil];
    if(![[NSFileManager defaultManager] fileExistsAtPath:listsPath isDirectory:nil]) [[NSFileManager defaultManager] createDirectoryAtPath:listsPath withIntermediateDirectories:YES attributes:nil error:nil];
    if(![[NSFileManager defaultManager] fileExistsAtPath:iconsPath isDirectory:nil]) [[NSFileManager defaultManager] createDirectoryAtPath:iconsPath withIntermediateDirectories:YES attributes:nil error:nil];
    if(![[NSFileManager defaultManager] fileExistsAtPath:sourcesPath isDirectory:nil]) [[NSFileManager defaultManager] createFileAtPath:sourcesPath contents:nil attributes:nil];
}

/*
// code reuse is amazing and this piece of stackoverflow "why does it work" magic actually works and i even have a clue how
// originally from icy btw
- (int)bunzip_one:(NSString *)filepathString {
    const char *file = [filepathString UTF8String];
    const char *output = [[filepathString substringToIndex:filepathString.length - 4] UTF8String];
    FILE *f = fopen(file, "r+b");
    FILE *outfile = fopen(output, "w");
    fprintf(outfile, "");
    outfile = fopen(output, "a");
    int bzError;
    BZFILE *bzf;
    char buf[4096];
    bzf = BZ2_bzReadOpen(&bzError, f, 0, 0, NULL, 0);
    if (bzError != BZ_OK) {
        printf("E: BZ2_bzReadOpen: %d\n", bzError);
        return -1;
    }
    while (bzError == BZ_OK) {
        int nread = BZ2_bzRead(&bzError, bzf, buf, sizeof buf);
        if (bzError == BZ_OK || bzError == BZ_STREAM_END) {
            size_t nwritten = fwrite(buf, 1, nread, stdout);
            fprintf(outfile, "%s", buf);
            if (nwritten != (size_t) nread) {
                printf("E: short write\n");
                return -1;
            }
        }
    }
    if (bzError != BZ_STREAM_END) {
        printf("E: bzip error after read: %d\n", bzError);
        return -1;
    }
    BZ2_bzReadClose(&bzError, bzf);
    fclose(outfile);
    fclose(f);
    [[NSFileManager defaultManager] removeItemAtPath:filepathString error:nil];
    return 0;
}
*/
- (void)addRepoWithURLString:(NSString *)urlString {
    NSString *sourcesPath = @"/var/mobile/Documents/Lime/sources.list";
    if(![[urlString substringFromIndex:urlString.length - 1] isEqualToString:@"/"]) urlString = [urlString stringByAppendingString:@"/"];
    NSString *formatted = [NSString stringWithFormat:@"\ndeb %@ ./",urlString];
    NSString *sourcesList = [NSString stringWithContentsOfFile:sourcesPath encoding:NSUTF8StringEncoding error:nil];
    // if repo already on the list tell user
    if([sourcesList rangeOfString:formatted].location != NSNotFound) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"This repo has already been added to your list." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self refresh:self];
}

// TableView stuff

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[LimeHelper sharedInstance] sources].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMRepo *repo = [[[LimeHelper sharedInstance] sources] objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.textLabel.text = repo.label;
    NSString *urlString = repo.packagesPath;
    //cell.detailTextLabel.text = [[urlString componentsSeparatedByString:@"/"] lastObject];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Packages: %ld", (long)repo.packages.count];
    cell.detailTextLabel.alpha = 0.5;
    UIImage *icon;
    if([[NSFileManager defaultManager] fileExistsAtPath:repo.imagePath isDirectory:nil]) icon = [UIImage imageWithContentsOfFile:repo.imagePath];
    else icon = [UIImage imageNamed:@"sections/Unknown.png"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(35,35), NO, [UIScreen mainScreen].scale);
    [icon drawInRect:CGRectMake(0,0,35,35)];
    icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 10;
    cell.imageView.image = icon;
    
    if ([LimeHelper darkMode]) {
        cell.textLabel.textColor = [LMColor labelColor];
        cell.detailTextLabel.textColor = [LMColor labelColor];
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [LMColor selectedTableViewCellColor];
        [cell setSelectedBackgroundView:bgColorView];
    }
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"openRepo"]) {
        RepoPackagesViewController *vc = segue.destinationViewController;
        vc.repo = [[[LimeHelper sharedInstance] sources] objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"openRepo" sender:self];
}

@end
