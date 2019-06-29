#import "Settings.h"
#import "LimeHelper.h"
#import <sys/utsname.h>
#import "MobileGestalt.h"
#import <sys/sysctl.h>
#include <spawn.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

@interface Settings ()

@end

@implementation DeviceInfo

+ (NSString *)deviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

+ (NSString *)machineID {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *answer = malloc(size);
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    NSString *machineIdentifier = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    free(answer);
    return machineIdentifier;
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

+ (NSString *)localIP {
    
    NSString *address = @"No Wi-Fi";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

@end

@implementation Settings

-(void)viewDidLoad {
    [super viewDidLoad];
    
    _nameLabel.text = [[UIDevice currentDevice] name];
    _iOSLabel.text = [NSString stringWithFormat:@"iOS %@", [[UIDevice currentDevice] systemVersion]];
    
    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, _infoTable.frame.origin.y + _infoTable.frame.size.height);
    _scrollView.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        self.scrollView.backgroundColor = [UIColor blackColor];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.iOSLabel.textColor = [UIColor whiteColor];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 74) {
        [self.navigationItem setTitle:[[UIDevice currentDevice] name]];
    } else {
        [self.navigationItem setTitle:[NSString new]];
    }
}

@end

@implementation InfoCells

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copy:));
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)copy:(id)sender {
    [UIPasteboard generalPasteboard].string = self.detailTextLabel.text;
}

@end

@implementation InfoTable

-(void)viewDidLoad {
    _modelCell.detailTextLabel.text = [DeviceInfo deviceName];
    _ecidCell.detailTextLabel.text = [DeviceInfo getECID];
    _udidCell.detailTextLabel.text = [DeviceInfo getUDID];
    _serialCell.detailTextLabel.text = [DeviceInfo localIP];
    [_darkToggle setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"] animated:NO];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        self.view.backgroundColor = [UIColor blackColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_uicacheCell.accessoryView addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UICache"]]];
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
        _respringCell.backgroundColor = [UIColor colorWithRed:0.109 green:0.109 blue:0.117 alpha:1];
        _respringCell.textLabel.textColor = [UIColor whiteColor];
        UIImageView *respringIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        respringIcon.image = [LimeHelper imageWithName:@"respringdark"];
        [_respringCell setAccessoryView:respringIcon];
        _uicacheCell.backgroundColor = [UIColor colorWithRed:0.109 green:0.109 blue:0.117 alpha:1];
        UIImageView *uicacheIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        uicacheIcon.image = [LimeHelper imageWithName:@"UICache"];
        _uicacheCell.accessoryView = uicacheIcon;
        _uicacheCell.textLabel.textColor = [UIColor whiteColor];
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithWhite:0.21 alpha:1.0];
        [_creditsCell setSelectedBackgroundView:bgColorView];
        [_respringCell setSelectedBackgroundView:bgColorView];
        [_uicacheCell setSelectedBackgroundView:bgColorView];
    } else {
        UIImageView *respringIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        respringIcon.image = [LimeHelper imageWithName:@"respringlight"];
        [_respringCell setAccessoryView:respringIcon];
        UIImageView *uicacheIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        uicacheIcon.image = [LimeHelper imageWithName:@"UICache"];
        _uicacheCell.accessoryView = uicacheIcon;
    }
}
- (IBAction)darkChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:_darkToggle.isOn forKey:@"darkMode"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text  isEqual:@"Credits"]) {
        [self.parentViewController performSegueWithIdentifier:@"credits" sender:self.parentViewController];
    }
    if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text  isEqual:@"UICache"]) {
        run_cmd("sbreload");
    }
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return (action == @selector(copy:));
}

-(void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
}

extern char **environ;

void run_cmd(char *cmd)
{
    pid_t pid;
    char *argv[] = {cmd, NULL};
    int status;
    
    status = posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, argv, environ);
    if (status == 0) {
        if (waitpid(pid, &status, 0) == -1) {
            perror("waitpid");
        }
    }
}

@end

@implementation Credits

-(void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _creditsTable.frame.origin.y + _creditsTable.frame.size.height);
    _scrollView.delegate = self;
    self.navigationItem.rightBarButtonItem.title = @"Back";
}

- (IBAction)limeTwitter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=LimeInstaller"] options:@{} completionHandler:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        self.scrollView.backgroundColor = [UIColor blackColor];
        self.limeName.textColor = [UIColor whiteColor];
        self.limeUser.textColor = [UIColor whiteColor];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 74) {
        [self.navigationItem setTitle:@"Lime Team"];
    } else {
        [self.navigationItem setTitle:[NSString new]];
    }
}

@end

@implementation CreditsTable

-(void)viewDidLoad {
    [super viewDidLoad];
    
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
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor colorWithWhite:0.21 alpha:1];
        _evenCell.backgroundColor = [UIColor colorWithRed:0.109 green:0.109 blue:0.117 alpha:1];
        _coronuxCell.backgroundColor = [UIColor colorWithRed:0.109 green:0.109 blue:0.117 alpha:1];
        _artikusCell.backgroundColor = [UIColor colorWithRed:0.109 green:0.109 blue:0.117 alpha:1];
        _luisCell.backgroundColor = [UIColor colorWithRed:0.109 green:0.109 blue:0.117 alpha:1];
        _pixelomerCell.backgroundColor = [UIColor colorWithRed:0.109 green:0.109 blue:0.117 alpha:1];
        [_evenCell setSelectedBackgroundView:bgView];
        [_coronuxCell setSelectedBackgroundView:bgView];
        [_artikusCell setSelectedBackgroundView:bgView];
        [_luisCell setSelectedBackgroundView:bgView];
        [_pixelomerCell setSelectedBackgroundView:bgView];
        _evenLabel.textColor = [UIColor whiteColor];
        _coroLabel.textColor = [UIColor whiteColor];
        _artiLabel.textColor = [UIColor whiteColor];
        _luisLabel.textColor = [UIColor whiteColor];
        _pixelLabel.textColor = [UIColor whiteColor];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self openTwitterAccountWithName:[tableView cellForRowAtIndexPath:indexPath].reuseIdentifier];
}

-(void)openTwitterAccountWithName:(NSString*)user {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"twitter://user?screen_name=%@", user]] options:@{} completionHandler:nil];
}

@end
