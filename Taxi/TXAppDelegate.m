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
//#import <PushApps/PushApps.h>
#import "TXSignInVC.h"
#import <Parse/Parse.h>

@implementation TXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // ****************************************************************************
    // Parse initialization
    [Parse setApplicationId:@"Vw5Gf7cIo3blEgdNEQ4IwGoSil0PtfdH5DeoUZNe" clientKey:@"adXCcAZ1evib4nhHnOtoE1Et9261NV8px9K8Vbhg"];
	// ****************************************************************************
    
    [PFFacebookUtils initializeFacebook];

    // Set default ACLs
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    TXSignInVC *signIn = [[TXSignInVC alloc] initWithNibName:@"TXSignInVC" bundle:nil];
    
    self.window.rootViewController = signIn;
    //[[UINavigationController alloc] initWithRootViewController:signIn];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSString *message = [TXCode2MsgTranslator messageForCode:SUCCESS];
    NSLog(@"%@", message);
    
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    [GMSServices provideAPIKey:@"AIzaSyA-mIDdBQDMjxoQ59UOpYnyqa0ogk9m7-M"];
    
    
    
    return YES;
}

#pragma mark - Parse installation

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    
    NSLog(@"%@",@"Registered successfully with parse");
    NSLog(@"Device token : %@",deviceToken);
}


// Gets called when a remote notification is received while app is in the foreground.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
   // [[PushAppsManager sharedInstance] handlePushMessageOnForeground:userInfo];
}

- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {
    
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication] || [GPPURLHandler handleURL:url
                  sourceApplication:sourceApplication
                         annotation:annotation];
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

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
