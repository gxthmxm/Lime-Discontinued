//
//  LMInstalledPackageCell.h
//  Lime
//
//  Created by Even Flatabø on 21/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMInstalledPackageCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@property (nonatomic, retain) IBOutlet UILabel *detailTextLabel;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

@end

NS_ASSUME_NONNULL_END
