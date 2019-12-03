//
//  LMQueueController.h
//  Lime
//
//  Created by Even Flatabø on 02/12/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Helpers/LMQueue.h"
#import "../Other/NSArray+Random.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMQueueController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *actionButton;
@property (strong, nonatomic) IBOutlet UIImageView *checkmark;
@property (strong, nonatomic) IBOutlet UILabel *greatLabel;
@property (strong, nonatomic) IBOutlet UIView *completeView;
@property (strong, nonatomic) IBOutlet UITableView *queueTable;
@property (strong, nonatomic) IBOutlet UITextView *logView;
@property (strong, nonatomic) IBOutlet UIButton *tempNext;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *effectView;
@property (strong, nonatomic) IBOutlet UIImageView *arrowIMG;
@property (strong, nonatomic) IBOutlet UILabel *finishedLabel;
@property (strong, nonatomic) LMQueue *queue;

@property (nonatomic) CGRect logViewFrame;

@property (nonatomic) NSInteger state;
@property (nonatomic) NSInteger tasks;

@end

NS_ASSUME_NONNULL_END
