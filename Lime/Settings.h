//
//  ChangesViewController.h
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Settings : UIViewController <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *iOSLabel;
@property (strong, nonatomic) IBOutlet UIView *infoTable;

@end

@interface InfoTable : UITableViewController
@property (strong, nonatomic) IBOutlet UITableViewCell *modelCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *ecidCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *udidCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *serialCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *bootCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *darkCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *creditsCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *respringCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *uicacheCell;
@property (strong, nonatomic) IBOutlet UISwitch *darkToggle;
@property (strong, nonatomic) IBOutlet UILabel *darkTitle;

@end

@interface InfoCells : UITableViewCell
@end

@interface Credits : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *limeTwitter;
@property (strong, nonatomic) IBOutlet UIView *creditsTable;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *limeUser;
@property (strong, nonatomic) IBOutlet UILabel *limeName;

@end

@interface CreditsTable : UITableViewController

@property (strong, nonatomic) IBOutlet UITableViewCell *evenCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *coronuxCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *artikusCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *luisCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *pixelomerCell;

@property (strong, nonatomic) IBOutlet UILabel *evenLabel;
@property (strong, nonatomic) IBOutlet UILabel *coroLabel;
@property (strong, nonatomic) IBOutlet UILabel *artiLabel;
@property (strong, nonatomic) IBOutlet UILabel *luisLabel;
@property (strong, nonatomic) IBOutlet UILabel *pixelLabel;

-(void)openTwitterAccountWithName:(NSString*)user;

@end

@interface DeviceInfo : NSObject

+ (NSString *)deviceName;
+ (NSString *)getECID;
+ (NSString *)getUDID;
+ (NSString *)machineID;
+ (NSString *)localIP;

@end

NS_ASSUME_NONNULL_END
