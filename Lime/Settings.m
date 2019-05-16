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

@end

@implementation InfoTable

-(void)viewDidLoad {
    _modelCell.detailTextLabel.text = [DeviceInfo deviceName];
    _ecidCell.detailTextLabel.text = [DeviceInfo getECID];
    _udidCell.detailTextLabel.text = [DeviceInfo getUDID];
    self.view.backgroundColor = [UIColor whiteColor];
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

@end

@implementation CreditsTable

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _evenCell.detailTextLabel.text = @"even_dev";
    _coronuxCell.detailTextLabel.text = @"Coronux";
    _artikusCell.detailTextLabel.text = @"artikus_hg";
    _luisCell.detailTextLabel.text = @"LuMartti";
    _midnightCell.detailTextLabel.text = @"MidnightChip";
    _supportCell.detailTextLabel.text = @"SupportLime";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *username = [tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"twitter://user?screen_name=%@", username]] options:@{} completionHandler:nil];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.detailTextLabel.alpha = 0;
}

@end
