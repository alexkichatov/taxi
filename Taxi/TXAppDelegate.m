//
//  TXAppDelegate.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/19/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXAppDelegate.h"
#import "TXHttpRequestManager.h"
#import "utils.h"
#import "TXUserModel.h"
#import "TXFileManager.h"
#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
#import "MenuViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "TXCode2MsgTranslator.h"
#import "TXApp.h"
#import "TXSignInVC.h"
#import "NSData+StringBytes.h"
#import "TXMapVC.h"

@implementation TXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
    [GMSServices provideAPIKey:@"AIzaSyA-mIDdBQDMjxoQ59UOpYnyqa0ogk9m7-M"];
    //TXMapVC *signIn = [[TXMapVC alloc] initWithNibName:@"TXMapVC" bundle:nil];
    TXSignInVC *signIn = [[TXSignInVC alloc] initWithNibName:@"TXSignInVC" bundle:nil];
    
    self.window.rootViewController = signIn;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self registerForRemoteNotifications:application];
    
    return YES;
}

-(void) registerForRemoteNotifications:(UIApplication *) application {
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
}

#pragma mark - Parse installation

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[[TXApp instance] getSettings] setNotificationsToken:[deviceToken stringRepresentation]];
}


// Gets called when a remote notification is received while app is in the foreground.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
   // [[PushAppsManager sharedInstance] handlePushMessageOnForeground:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// Google oauth callback

- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication annotation: (id)annotation
{
    return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
