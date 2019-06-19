//
//  ChangesViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

/*

 //
 //  ChangesViewController.m
 //  Lime
 //
 //  Created by ArtikusHG on 4/30/19.
 //  Copyright © 2019 Daniel. All rights reserved.
 //
 
 #import "Settings.h"
 #import <sys/utsname.h>
 #import "MobileGestalt.h"
 
 @interface Settings ()
 
 @end
 
 @implementation DeviceInfo
 
 + (NSString *)deviceName {
 struct utsname systemInfo;
 uname(&systemInfo);
 
 return [NSString stringWithCString:systemInfo.machine
 encoding:NSUTF8StringEncoding];
 }
 
 + (NSString *)getDeviceName {
 struct utsname systemInfo;
 uname(&systemInfo);
 
 return [NSString stringWithCString:systemInfo.machine
 encoding:NSUTF8StringEncoding];
 }
 
 + (NSString *)getECID {
 NSString *ECID = nil;
 CFStringRef value = MGCopyAnswer(kMGUniqueChipID);
 if (value != nil) {
 ECID = [NSString stringWithFormat:@"%@", value];
 CFRelease(value);
 }
 return ECID;
 }
 
 + (NSString *)getUDID {
 NSString *UDID = nil;
 CFStringRef value = MGCopyAnswer(kMGUniqueDeviceID);
 if (value != nil) {
 UDID = [NSString stringWithFormat:@"%@", value];
 CFRelease(value);
 }
 return UDID;
 }
 
 @end
 
 @implementation Settings
 
 
 
 -(void)viewDidLoad {
 [super viewDidLoad];
 
 _nameLabel.text = [[UIDevice currentDevice] name];
 _iOSLabel.text = [NSString stringWithFormat:@"iOS %@", [[UIDevice currentDevice] systemVersion]];
 [_iPhoneView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [DeviceInfo deviceName]]]];
 
 _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, _infoTable.frame.origin.y + _infoTable.frame.size.height);
 }
 
 @end
 
 @implementation InfoTable
 
 -(void)viewDidLoad {
 _modelCell.detailTextLabel.text = [DeviceInfo getDeviceName];
 _ecidCell.detailTextLabel.text = [DeviceInfo getECID];
 _udidCell.detailTextLabel.text = [DeviceInfo getUDID];
 self.view.backgroundColor = [UIColor whiteColor];
 }
 
 -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text  isEqual: @"Credits"]) {
 [self.parentViewController performSegueWithIdentifier:@"credits" sender:self.parentViewController];
 } else {
 sleep(0.1);
 [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
 }
 }
 
 @end


*/

#import "Settings.h"
#import <sys/utsname.h>
#import "MobileGestalt.h"

@interface Settings ()

@end

@implementation DeviceInfo

+ (NSString *)deviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

+ (NSString *)getECID {
    NSString *ECID = nil;
    CFStringRef value = MGCopyAnswer(kMGUniqueChipID);
    if (value != nil) {
        ECID = [NSString stringWithFormat:@"%@", value];
        CFRelease(value);
    }
    return ECID;
}

+ (NSString *)getUDID {
    NSString *UDID = nil;
    CFStringRef value = MGCopyAnswer(kMGUniqueDeviceID);
    if (value != nil) {
        UDID = [NSString stringWithFormat:@"%@", value];
        CFRelease(value);
    }
    return UDID;
}

@end

@implementation Settings

-(void)viewDidLoad {
    [super viewDidLoad];
    
    _nameLabel.text = [[UIDevice currentDevice] name];
    _iOSLabel.text = [NSString stringWithFormat:@"iOS %@", [[UIDevice currentDevice] systemVersion]];
    [_iPhoneView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [DeviceInfo deviceName]]]];
    
    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, _infoTable.frame.origin.y + _infoTable.frame.size.height);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        self.scrollView.backgroundColor = [UIColor blackColor];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.iOSLabel.textColor = [UIColor whiteColor];
    }
}

@end

@implementation InfoTable

-(void)viewDidLoad {
    _modelCell.detailTextLabel.text = [DeviceInfo deviceName];
    _ecidCell.detailTextLabel.text = [DeviceInfo getECID];
    _udidCell.detailTextLabel.text = [DeviceInfo getUDID];
     [_darkToggle setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"] animated:NO];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        self.view.backgroundColor = [UIColor blackColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        self.tableView.backgroundColor = [UIColor blackColor];
        self.tableView.separatorColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        
        _modelCell.textLabel.textColor = [UIColor whiteColor];
        _modelCell.backgroundColor = [UIColor colorWithRed:0.109 green:0.109 blue:0.117 alpha:1];
        _modelCell.detailTextLabel.textColor = [UIColor whiteColor];
        _ecidCell.textLabel.textColor = [UIColor whiteColor];
        _ecidCell.backgroundColor = [UIColor colorWithRed:0.109 green:0.109 blue:0.117 alpha:1];
        _ecidCell.detailTextLabel.textColor = [UIColor whiteColor];
        _udidCell.textLabel.textColor = [UIColor whiteColor];
        _udidCell.backgroundColor = [UIColor colorWithRed:0.109 green:0.109 blue:0.117 alpha:1];
        _udidCell.detailTextLabel.textColor = [UIColor whiteColor];
        _serialCell.textLabel.textColor = [UIColor whiteColor];
        _serialCell.backgroundColor = [UIColor colorWithRed:0.109 green:0.109 blue:0.117 alpha:1];
        _serialCell.detailTextLabel.textColor = [UIColor whiteColor];
        _bootCell.textLabel.textColor = [UIColor whiteColor];
        _bootCell.backgroundColor = [UIColor colorWithRed:0.109 green:0.109 blue:0.117 alpha:1];
        _bootCell.detailTextLabel.textColor = [UIColor whiteColor];
        _creditsCell.textLabel.textColor = [UIColor whiteColor];
        _creditsCell.backgroundColor = [UIColor colorWithRed:0.109 green:0.109 blue:0.117 alpha:1];
        _darkTitle.textColor = [UIColor whiteColor];
        _darkCell.backgroundColor = [UIColor colorWithRed:0.109 green:0.109 blue:0.117 alpha:1];
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        [_creditsCell setSelectedBackgroundView:bgColorView];
    }
}
- (IBAction)darkChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:_darkToggle.isOn forKey:@"darkMode"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text  isEqual: @"Credits"]) {
        [self.parentViewController performSegueWithIdentifier:@"credits" sender:self.parentViewController];
    } else {
        [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    }
}

@end

@implementation Credits

-(void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _creditsTable.frame.origin.y + _creditsTable.frame.size.height);
}

- (IBAction)limeTwitter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=LimeAPT"] options:@{} completionHandler:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        self.scrollView.backgroundColor = [UIColor blackColor];
        self.limeName.textColor = [UIColor whiteColor];
        self.limeUser.textColor = [UIColor whiteColor];
    }
}

@end

@implementation CreditsTable

-(void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        self.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        self.tableView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
        self.tableView.separatorColor = [UIColor colorWithRed:0.235 green:0.235 blue:0.235 alpha:1];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *username = [tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"twitter://user?screen_name=%@", username]] options:@{} completionHandler:nil];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.detailTextLabel.alpha = 0;
}

@end
