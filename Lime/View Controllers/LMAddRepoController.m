//
//  LMAddRepoController.m
//  Lime
//
//  Created by Even Flatabø on 20/12/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMAddRepoController.h"

@interface LMAddRepoController ()

@end

@implementation LMAddRepoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.effectView.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){20.0, 20.0}].CGPath;
    
    self.repoURLTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 10)];
    self.repoURLTextField.leftViewMode = UITextFieldViewModeAlways;

    self.effectView.layer.mask = maskLayer;
    [self.repoURLTextField becomeFirstResponder];
    self.repoURLTextField.inputAccessoryView = self.effectView;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.repoURLTextField resignFirstResponder];
}

- (IBAction)close:(id)sender {
    self.repoURLTextField.text = @"";
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addRepo:(id)sender {
    if (self.repoURLTextField.text.length > 0) {
        NSString *addRepoURL = self.repoURLTextField.text;
        NSMutableArray *components = [addRepoURL componentsSeparatedByString:@" "].mutableCopy;
        NSString *url = components.firstObject;
        if (![[url substringFromIndex:url.length - 1] isEqualToString:@"/"]) url = [url stringByAppendingString:@"/"];
        [components replaceObjectAtIndex:0 withObject:url];
        if (components.count == 1) addRepoURL = [[components firstObject] stringByAppendingString:@" ./"];
        if (components.count == 2) addRepoURL = [NSString stringWithFormat:@"%@ %@", [components firstObject], [components objectAtIndex:1]];
        if (components.count == 3) addRepoURL = [NSString stringWithFormat:@"%@ %@ %@", [components firstObject], [components objectAtIndex:1], [components objectAtIndex:2]];
        if (![addRepoURL containsString:@"https://"] && ![addRepoURL containsString:@"http://"]) addRepoURL = [@"https://" stringByAppendingString:addRepoURL];
        addRepoURL = [@"deb " stringByAppendingString:addRepoURL];
        NSString *sourcesList = [NSString stringWithContentsOfFile:[LimeHelper sourcesPath] encoding:NSUTF8StringEncoding error:nil];
        NSMutableArray *listLines = [[sourcesList componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] mutableCopy];
        if (![listLines containsObject:addRepoURL]) sourcesList = [sourcesList stringByAppendingFormat:@"\n%@", addRepoURL];
        NSLog(@"[SourceManager] Should add %@", addRepoURL);
        [sourcesList writeToFile:[LimeHelper sourcesPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
        self.progressView.hidden = NO;
        self.titleLabel.text = @"Adding...";
        [LMSourceManager.sharedInstance refreshSource:[LimeHelper rawRepoWithDebLine:addRepoURL] progressView:self.progressView completionHandler:^{
            self.sourcesController.tableView.reloadData;
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
