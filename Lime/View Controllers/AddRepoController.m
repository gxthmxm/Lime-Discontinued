//
//  ChangesViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "AddRepoController.h"

@implementation AddRepoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_repoURL becomeFirstResponder];
    self.logView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, self.logView.frame.origin.y, self.logView.frame.size.width, self.logView.frame.size.height);
    self.logView.translatesAutoresizingMaskIntoConstraints = YES;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _repoURL.leftView = paddingView;
    _repoURL.leftViewMode = UITextFieldViewModeAlways;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        _repoURL.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_repoURL.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]}];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    self.effectView.translatesAutoresizingMaskIntoConstraints = YES;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.line.backgroundColor = [UIColor colorWithRed:0.235 green:0.235 blue:0.235 alpha:1];
        self.repoURL.textColor = [UIColor whiteColor];
        [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _arrowImg.image = [UIImage imageNamed:@"arrowdark"];
        self.logView.textColor = [UIColor whiteColor];
        self.repoURL.keyboardAppearance = UIKeyboardAppearanceDark;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    [UIView animateWithDuration:0.2 animations:^{
        self.effectView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - keyboardFrameBeginRect.size.height - 284, self.effectView.frame.size.width,  self.effectView.frame.size.height);
    }];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [_repoURL resignFirstResponder];
}

- (IBAction)addRepo:(id)sender {
    NSString *sourcesPath = @"/var/mobile/Documents/Lime/sources.list";
    NSString *urlString = self.repoURL.text;
    [_repoURL resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.effectView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 515, self.effectView.frame.size.width, 535);
        self.addRepoContainerView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - [UIScreen mainScreen].bounds.size.width * 2, self.addRepoContainerView.frame.origin.y, self.addRepoContainerView.frame.size.width, self.addRepoContainerView.frame.size.height);
        self.logView.frame = CGRectMake(28, self.logView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }];
    /*if(![SourcesBackend repoIsValid:urlString]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"The \"%@\" can not be added to your list because it does not appear to be a valid repo. This may be caused by your internet connection or by an issue on the repo owner's side. Please try again later.",urlString] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }*/
    if(![[urlString substringFromIndex:urlString.length - 1] isEqualToString:@"/"]) urlString = [urlString stringByAppendingString:@"/"];
    NSString *formatted;
    if ([urlString hasPrefix:@"https://"] || [urlString hasPrefix:@"http://"]) {
        formatted = [NSString stringWithFormat:@"deb %@ ./\n",urlString];
    } else {
        formatted = [NSString stringWithFormat:@"deb https://%@ ./\n",urlString];
    }
    NSString *sourcesList = [NSString stringWithContentsOfFile:sourcesPath encoding:NSUTF8StringEncoding error:nil];
    if([sourcesList rangeOfString:formatted].location != NSNotFound) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"This repo has already been added to your list." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
     NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:sourcesPath];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[formatted dataUsingEncoding:NSUTF8StringEncoding]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
