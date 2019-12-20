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
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    [self.tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.userInteractionEnabled = NO;
    }];
    [LMSourceManager.sharedInstance refreshSourcesCompletionHandler:^{
        [self.tableView reloadData];
        self.navigationController.navigationBar.userInteractionEnabled = YES;
        [self.tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.userInteractionEnabled = YES;
        }];
    }];
}

// TableViewn't stuff

/*- (NSString *)filenameFromURLString:(NSString *)URLString {
    NSRange range = [URLString rangeOfString:@"://"];
    NSString *filename = URLString;
    filename = [filename substringFromIndex:range.location + 3];
    filename = [filename stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return filename;
}

- (NSString *)nameForRepo:(LMRepo *)repo {
    // get the full filename
    NSString *fullFilepath = [[LimeHelper listsPath] stringByAppendingString:repo.releasePath];
    if([[NSFileManager defaultManager] fileExistsAtPath:fullFilepath isDirectory:nil]) {
        NSArray *lines = [[NSString stringWithContentsOfFile:fullFilepath encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];
        for (NSString *line in lines) {
            // look for the line that starts with "Label:"
            if(line.length > 7 && [[line substringToIndex:6] isEqualToString:@"Label:"]) {
                // gets the actual name without the first 7 symbols which are "Label: " and assigns it to the instance variable.
                return [line substringFromIndex:7];
                break;
            }
        }
    }
    return nil;
}

- (UIImage *)generateIconForRepo:(LMRepo *)repo {
    UIImage *icon;
    NSString *filename = [[LimeHelper iconsPath] stringByAppendingString:repo.imagePath];
    if([[NSFileManager defaultManager] fileExistsAtPath:filename isDirectory:nil]) icon = [UIImage imageWithContentsOfFile:filename];
    else icon = [UIImage imageNamed:@"sections/Unknown.png"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(40,40), NO, [UIScreen mainScreen].scale);
    [icon drawInRect:CGRectMake(0,0,40,40)];
    icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return icon;
}

- (UIImage *)iconForRepo:(LMRepo *)repo forIconUpdate:(BOOL)forUpdate {
    UIImage *icon;
    if(!forUpdate) {
        icon = [self.repoIconsCache objectForKey:repo.repoURL];
        if(icon) return icon;
    }
    icon = [self generateIconForRepo:repo];
    [self.repoIconsCache setObject:icon forKey:repo.repoURL];
    return icon;
}

- (LMRepo *)repoForAPTURLString:(NSString *)line {
    LMRepo *repo = [[LMRepo alloc] init];
    repo.sourcesFileLine = [line stringByAppendingString:@"\n"];
    // remove "deb " from the line
    line = [line substringFromIndex:4];
    // each url ends with "/" and the directory is stored after the space so we use that to separate the url from the directory
    NSArray *linkAndDirectories = [line componentsSeparatedByString:@"/ "];
    NSString *link = [[linkAndDirectories objectAtIndex:0] stringByAppendingString:@"/"];
    NSString *directory = [linkAndDirectories objectAtIndex:1];
    // create variables to store the URLs into
    NSString *packagesURL;
    NSString *releaseURL;
    NSString *iconURL;
    // grab the release and packages urls if the repo has a simple directory
    if ([directory isEqualToString:@"./"]) {
        link = [link stringByAppendingString:directory];
        releaseURL = [link stringByAppendingString:@"Release"];
        packagesURL = [link stringByAppendingString:@"Packages.bz2"];
        iconURL = [link stringByAppendingString:@"CydiaIcon.png"];
    } else {
        NSArray *distAndComp = [directory componentsSeparatedByString:@" "];
        NSString *dist = [distAndComp objectAtIndex:0]; // ex. stable
        NSString *comp = [distAndComp objectAtIndex:1]; // ex. main
        releaseURL = [NSString stringWithFormat:@"%@dists/%@/Release", link, dist];
        packagesURL = [NSString stringWithFormat:@"%@dists/%@/%@/binary-iphoneos-arm/Packages.bz2", link, dist, comp];
        iconURL = [NSString stringWithFormat:@"%@dists/%@/CydiaIcon.png", link, dist];
    }
    // assign URL-related variables
    repo.repoURL = link;
    repo.releaseURL = releaseURL;
    repo.packagesURL = packagesURL;
    repo.imageURL = iconURL;
    
    repo.releasePath = [self filenameFromURLString:repo.releaseURL];
    repo.packagesPath = [self filenameFromURLString:repo.packagesURL];
    repo.imagePath = [self filenameFromURLString:repo.imageURL];
    // assign this so if the files don't exist and we can't grab the name for some reason we have the url as the name
    repo.name = repo.repoURL;
    NSString *repoName = [self nameForRepo:repo];
    if (repoName) repo.name = repoName;
    return repo;
}

- (void)parseRepoData {
    self.repos = [[NSMutableArray alloc] init];
    self.repoIconsCache = [[NSCache alloc] init];
    // sources.list lines. we replace "deb " with an empty string because this part is basically useless for us (but still needed for apt to function properly).
    NSString *sourceLinksString = [NSString stringWithContentsOfFile:[LimeHelper sourcesPath] encoding:NSUTF8StringEncoding error:nil];
    NSArray *sourceLinks = [sourceLinksString componentsSeparatedByString:@"\n"];
    // if nothing in sources.list (tbh idk a case where this can happen but let it be)
    if (sourceLinks.count == 0) return;
    for (NSString *line in sourceLinks) {
        // if there's an empty newline just skip this
        if(line.length <= 2) continue;
        LMRepo *repo = [self repoForAPTURLString:line];
        [self.repos addObject:repo];
        [self.repoIconsCache setObject:[self generateIconForRepo:repo] forKey:repo.repoURL];
    }
    [self.repos sortUsingComparator:^NSComparisonResult(LMRepo *firstRepo, LMRepo *secondRepo) {
        return [firstRepo.name caseInsensitiveCompare:secondRepo.name];
    }];
}

// Repos backend

- (void)downloadRepos {
    self.allReposExpectedLength = 0;
    self.allReposDownloaded = 0;
    self.topProgressView.progress = 0;
    // clean up the repos dir just in case
    for (NSString *filename in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[LimeHelper listsPath] error:nil]) [[NSFileManager defaultManager] removeItemAtPath:[[LimeHelper listsPath] stringByAppendingString:filename] error:nil];
    for (NSString *filename in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[LimeHelper iconsPath] error:nil]) [[NSFileManager defaultManager] removeItemAtPath:[[LimeHelper iconsPath] stringByAppendingString:filename] error:nil];
    for (LMRepo *repo in self.repos) [self downloadRepo:repo forAdd:NO];
}

- (NSMutableURLRequest *)mutableURLRequestWithHeadersWithURLString:(NSString *)URLString {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0];
    [request setValue:@"Cydia/0.9 CFNetwork/978.0.7 Darwin/18.7.0" forHTTPHeaderField:@"User-Agent"];
    [request setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"X-Firmware"];
    [request setValue:[LMDeviceInfo deviceName] forHTTPHeaderField:@"X-Machine"];
    [request setValue:[LMDeviceInfo udid] forHTTPHeaderField:@"X-Unique-ID"];
    return request;
}

// For downloading files;
- (void)downloadRepo:(LMRepo *)repo forAdd:(BOOL)forAdd {
    // reset the shit so it doesn't get bamboolzed
    repo.releaseExpectedLength = 0;
    repo.packagesExpectedLength = 0;
    repo.iconExpectedLength = 0;
    repo.totalExpectedLength = 0;
    repo.releaseDownloaded = 0;
    repo.packagesDownloaded = 0;
    repo.iconDownloaded = 0;
    repo.totalDownloaded = 0;
    repo.releaseTotalAdded = NO;
    repo.packagesTotalAdded = NO;
    repo.iconTotalAdded = NO;
    
    NSString *firstString;
    if(forAdd) {
        firstString = @"ForAdd";
        self.addRepo = nil;
        self.addRepoTasks = nil;
    } else firstString = [NSString stringWithFormat:@"%zd", [self.repos indexOfObject:repo]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
    NSMutableURLRequest *releaseRequest = [self mutableURLRequestWithHeadersWithURLString:repo.releaseURL];
    NSURLSessionDownloadTask *releaseTask = [session downloadTaskWithRequest:releaseRequest];
    releaseTask.taskDescription = [firstString stringByAppendingString:@"_Release"];
    [releaseTask resume];
    
    NSMutableURLRequest *packagesRequest = [self mutableURLRequestWithHeadersWithURLString:repo.packagesURL];
    NSURLSessionDownloadTask *packagesTask = [session downloadTaskWithRequest:packagesRequest];
    packagesTask.taskDescription = [firstString stringByAppendingString:@"_Packages"];
    [packagesTask resume];

    NSMutableURLRequest *iconRequest = [self mutableURLRequestWithHeadersWithURLString:repo.imageURL];
    NSURLSessionDownloadTask *iconTask = [session downloadTaskWithRequest:iconRequest];
    iconTask.taskDescription = [firstString stringByAppendingString:@"_Icon"];
    [iconTask resume];
    
    if(forAdd) {
        self.addRepoTasks = [[NSMutableArray alloc] initWithObjects:releaseTask, packagesTask, iconTask, nil];
        self.addRepo = repo;
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    if(totalBytesExpectedToWrite < 0) return;
    // since the task's desc is the repo's URL and the URL the key thats how we get the repo and what kinda task is this; if repoIndex is ForAdd its for adding the repo so we do stuff a bit differently.
    NSUInteger separatorLocation = [downloadTask.taskDescription rangeOfString:@"_" options:NSBackwardsSearch].location;
    NSString *repoIndex = [downloadTask.taskDescription substringToIndex:separatorLocation];
    NSString *taskType = [downloadTask.taskDescription substringFromIndex:separatorLocation + 1];
    LMRepo *repo;
    BOOL forAdd = NO;
    if([repoIndex isEqualToString:@"ForAdd"]) {
        repo = self.addRepo;
        forAdd = YES;
    } else repo = [self.repos objectAtIndex:[repoIndex integerValue]];
    if ([taskType isEqualToString:@"Release"]) {
        if(!repo.releaseTotalAdded) {
            repo.releaseExpectedLength = totalBytesExpectedToWrite;
            repo.totalExpectedLength += totalBytesExpectedToWrite;
            if(!forAdd) self.allReposExpectedLength += totalBytesExpectedToWrite;
            repo.releaseTotalAdded = YES;
        }
        repo.releaseDownloaded += bytesWritten;
    }
    else if ([taskType isEqualToString:@"Packages"]) {
        if(!repo.packagesTotalAdded) {
            repo.packagesExpectedLength = totalBytesExpectedToWrite;
            repo.totalExpectedLength += totalBytesExpectedToWrite;
            if(!forAdd) self.allReposExpectedLength += totalBytesExpectedToWrite;
            repo.packagesTotalAdded = YES;
        }
        repo.packagesDownloaded += bytesWritten;
    }
    else if ([taskType isEqualToString:@"Icon"]) {
        if(!repo.iconTotalAdded) {
            repo.iconExpectedLength = totalBytesExpectedToWrite;
            repo.totalExpectedLength += totalBytesExpectedToWrite;
            if(!forAdd) self.allReposExpectedLength += totalBytesExpectedToWrite;
            repo.iconTotalAdded = YES;
        }
        repo.iconDownloaded += bytesWritten;
    }
    if(!forAdd) self.allReposDownloaded += bytesWritten;
    repo.totalDownloaded += bytesWritten;
    NSInteger statusCode = [(NSHTTPURLResponse *)downloadTask.response statusCode];
    NSIndexPath *indexPath;
    if(forAdd) indexPath = [NSIndexPath indexPathForRow:[self.repos indexOfObject:repo] inSection:0];
    else indexPath = [NSIndexPath indexPathForRow:[repoIndex integerValue] inSection:0];    if(statusCode / 100 != 2) {
        // NOTE TO EVEN OR SOMEONE ELSE DOING ERROR HANDLING: ERROR HANDLING GOES HERE. LOG THE CODE PROBS?
        // if there was an error on the Release or the Packages.bz2 task, we cancel ALL tasks related to the repo (that's why we added them all to an array btw) and remove the addRepo property
        if(![taskType isEqualToString:@"Icon"] && forAdd) {
            // NOTE TO EVEN: TELL THE USER THE REPO'S BAMBOOLZED HERE.
            for (NSURLSessionDownloadTask *task in self.addRepoTasks) [task cancel];
            [self removeRepo:self.addRepo];
            [self.tableView reloadData];
            
            [self.topProgressView setProgress:0 animated:NO];
            return;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if(forAdd) {
            [self.topProgressView setProgress:(float)repo.totalDownloaded / repo.totalExpectedLength animated:YES];
        } else {
            UIProgressView *repoProgressView = [(LMSourceCell *)[self.tableView cellForRowAtIndexPath:indexPath] progressView];
            [repoProgressView setProgress:(float)repo.totalDownloaded / repo.totalExpectedLength animated:YES];
            [self.topProgressView setProgress:(float)self.allReposDownloaded / self.allReposExpectedLength animated:YES];
            if ((self.allReposDownloaded / self.allReposExpectedLength) >= 1) [self downloadsDone];
        }
    });
}

-(void)downloadsDone {
    [self.topProgressView setProgress:0];
    [self.repos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[(LMSourceCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]] progressView] setProgress:0];
        [self.repos replaceObjectAtIndex:idx withObject:[LMRepoParser parseRepo:obj]];
    }];
    [self.tableView reloadData];
    NSLog(@"[Sources] Done.");
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    // since the task's desc is the repo's URL and the URL the key thats how we get the repo and what kinda task is this; if repoIndex is ForAdd its for adding the repo so we do stuff a bit differently.
    NSUInteger separatorLocation = [downloadTask.taskDescription rangeOfString:@"_" options:NSBackwardsSearch].location;
    NSString *repoIndex = [downloadTask.taskDescription substringToIndex:separatorLocation];
    NSString *taskType = [downloadTask.taskDescription substringFromIndex:separatorLocation + 1];
    LMRepo *repo;
    BOOL forAdd = NO;
    if([repoIndex isEqualToString:@"ForAdd"]) {
        repo = self.addRepo;
        forAdd = YES;
    } else repo = [self.repos objectAtIndex:[repoIndex integerValue]];
    if ([taskType isEqualToString:@"Release"]) {
        NSString *fullFilepath = [[LimeHelper listsPath] stringByAppendingString:repo.releasePath];
        [[NSFileManager defaultManager] moveItemAtPath:[location.absoluteString substringFromIndex:8] toPath:fullFilepath error:nil];
        NSString *repoName = [self nameForRepo:repo];
        if (repoName) {
            // set new name
            repo.name = repoName;
            // update the repo's cell name label
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath;
                if(forAdd) indexPath = [NSIndexPath indexPathForRow:[self.repos indexOfObject:repo] inSection:0];
                else indexPath = [NSIndexPath indexPathForRow:[repoIndex integerValue] inSection:0];
                [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text = repo.name;
            });
        }
    }
    else if ([taskType isEqualToString:@"Packages"]) {
        NSString *fullFilepath = [[LimeHelper listsPath] stringByAppendingString:repo.packagesPath];
        [[NSFileManager defaultManager] moveItemAtPath:[location.absoluteString substringFromIndex:8] toPath:fullFilepath error:nil];
        int bunzip_one = [self bunzip_one:fullFilepath];
        // ERROR HANDLING GOES HERE LATER, IF ITS -1 SOMETHING IS WRONG
    }
    else if ([taskType isEqualToString:@"Icon"]) {
        NSString *fullFilepath = [[LimeHelper iconsPath] stringByAppendingString:repo.imagePath];
        [[NSFileManager defaultManager] moveItemAtPath:[location.absoluteString substringFromIndex:8] toPath:fullFilepath error:nil];
        // update the repo's icon in the cell
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath;
            if(forAdd) indexPath = [NSIndexPath indexPathForRow:[self.repos indexOfObject:repo] inSection:0];
            else indexPath = [NSIndexPath indexPathForRow:[repoIndex integerValue] inSection:0];
            [self.tableView cellForRowAtIndexPath:indexPath].imageView.image = [self iconForRepo:repo forIconUpdate:YES];
        });
    }
}

// code reuse is amazing and this piece of stackoverflow "why does it work" magic actually works and i even have a clue how
// originally from my broken icy btw
- (int)bunzip_one:(NSString *)filepathString {
    const char *file = [filepathString UTF8String];
    const char *output = [[filepathString substringToIndex:filepathString.length - 4] UTF8String];
    FILE *f = fopen(file, "r+b");
    FILE *outfile = fopen(output, "w");
    fprintf(outfile, "");
    outfile = fopen(output, "a");
    int bzError;
    BZFILE *bzf;
    // it used to be char buf[4096] but @CodeLabyrinth aka a guy quite experienced with C told me this would be better for memory
    unsigned short buf[4096];
    bzf = BZ2_bzReadOpen(&bzError, f, 0, 0, NULL, 0);
    if (bzError != BZ_OK) {
        printf("E: BZ2_bzReadOpen: %d\n", bzError);
        [[NSFileManager defaultManager] removeItemAtPath:filepathString error:nil];
        return -1;
    }
    while (bzError == BZ_OK) {
        int nread = BZ2_bzRead(&bzError, bzf, buf, sizeof buf);
        if (bzError == BZ_OK || bzError == BZ_STREAM_END) {
            size_t nwritten = fwrite(buf, 1, nread, outfile);
            if (nwritten != (size_t) nread) {
                printf("E: short write\n");
                [[NSFileManager defaultManager] removeItemAtPath:filepathString error:nil];
                return -1;
            }
        }
    }
    if (bzError != BZ_STREAM_END) {
        printf("E: bzip error after read: %d\n", bzError);
        [[NSFileManager defaultManager] removeItemAtPath:filepathString error:nil];
        return -1;
    }
    BZ2_bzReadClose(&bzError, bzf);
    fclose(outfile);
    fclose(f);
    [[NSFileManager defaultManager] removeItemAtPath:filepathString error:nil];
    return 0;
}

- (void)addRepoWithURLString:(NSString *)URLString {
    NSString *sourcesPath = [LimeHelper sourcesPath];
    if(![[URLString substringFromIndex:URLString.length - 1] isEqualToString:@"/"]) URLString = [URLString stringByAppendingString:@"/"];
    NSString *formattedString = [NSString stringWithFormat:@"deb %@ ./",URLString];
    NSString *sourcesList = [NSString stringWithContentsOfFile:sourcesPath encoding:NSUTF8StringEncoding error:nil];
    // if repo already on the list tell user
    if([sourcesList rangeOfString:formattedString].location != NSNotFound) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"This repo has already been added to your list." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    LMRepo *repo = [self repoForAPTURLString:formattedString];
    // add the repo to sources.list and RAM here, if it's not really a repo or a broken one we'll just remove it later using removeRepo:
    NSString *sourcesFileContents = [NSString stringWithContentsOfFile:[LimeHelper sourcesPath] encoding:NSUTF8StringEncoding error:nil];
    NSString *newSourcesFileContents = [sourcesFileContents stringByAppendingString:repo.sourcesFileLine];
    [newSourcesFileContents writeToFile:[LimeHelper sourcesPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [self.repos addObject:repo];
    [self.repoIconsCache setObject:[self iconForRepo:repo forIconUpdate:NO] forKey:repo.repoURL];
    [self.tableView reloadData];
    [self downloadRepo:repo forAdd:YES];
}*/

// UITableView stuff

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LMSourceManager.sharedInstance sources].count;
}

/*- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)removeRepo:(LMRepo *)repo {
    // remove it from the memory (e.g. sources array and its icon from repoIconsCache)
    [self.repoIconsCache removeObjectForKey:repo.repoURL];
    [self.repos removeObject:repo];
    // remove the repo from the sources list
    NSString *fileContents = [NSString stringWithContentsOfFile:[LimeHelper sourcesPath] encoding:NSUTF8StringEncoding error:nil];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:repo.sourcesFileLine withString:@""];
    [fileContents writeToFile:[LimeHelper sourcesPath] atomically:NO encoding:NSUTF8StringEncoding error:nil];
    // remove the repo's files
    [[NSFileManager defaultManager] removeItemAtPath:[[LimeHelper listsPath] stringByAppendingString:repo.releasePath] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[[LimeHelper listsPath] stringByAppendingString:[repo.packagesPath substringToIndex:repo.packagesPath.length - 4]] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[[LimeHelper iconsPath] stringByAppendingString:repo.imagePath] error:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LMRepo *repo = [self.repos objectAtIndex:indexPath.row];
        // ---------------
        // ADD A CONFIRMATION ALERT OR SOMETHING? ITS UP TO YOU EVEN
        // ---------------
        [self removeRepo:repo];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}*/

- (LMSourceCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"sourcecell";
    LMSourceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    LMRepo *repo = [[LMSourceManager.sharedInstance sources] objectAtIndex:indexPath.row];
    cell.textLabel.text = repo.parsedRepo.label;
    cell.detailTextLabel.text = repo.rawRepo.repoURL;
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 10;
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
