//
//  AppDelegate.m
//  Lime
//
//  Created by Daniel on 29/04/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"darkMode"] == nil) {
        NSDictionary *appDefaults  = [NSDictionary dictionary];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"darkMode"];
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return YES;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([[url host]  isEqual: @"home"]) {
        [self URLHome];
    }
    if ([[url host]  isEqual: @"settings"]) {
        [self URLSettings];
    }
    if ([[url host]  isEqual: @"sources"]) {
        [self URLSources];
    }
    if ([[url host]  isEqual: @"updates"]) {
        [self URLUpdates];
    }
    if ([[url host]  isEqual: @"installed"]) {
        [self URLSearch];
    }
    if ([[url host]  isEqual: @"search"]) {
        [self URLInstalled];
    }
    if ([[url host]  isEqual: @"queue"]) {
        [self URLQueue];
    }
    if ([[url host]  isEqual: @"url"]) {
        //[self URLLink:url];
    }
    if ([[url host]  isEqual: @"repo"]) {
        //[self URLRepo:url];
    }
    if ([[url host]  isEqual: @"package"]) {
        //[self URLPackage:url];
    }
    if ([[url host]  isEqual: @"refresh"]) {
        [self URLRefresh];
    }
    
    return YES;
}

-(void)URLHome {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Home" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void)URLSettings {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void)URLSources {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Sources" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void)URLUpdates {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Updates" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void)URLInstalled {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Installed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void)URLSearch {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Search" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void)URLQueue {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Queue" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void)URLLink:(NSString*)url {
    
}

-(void)URLRepo:(NSString*)repo {
    
}

-(void)URLPackage:(NSString*)package {
    
}

-(void)URLRefresh {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Refresh" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
