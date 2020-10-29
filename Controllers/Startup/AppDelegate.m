//
//  AppDelegate.m
//  Doctor
//
//  Created by Thomas Woodfin on 11/16/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <Parse/Parse.h>
//#import "PayPalMobile.h"
#import <AVFoundation/AVFoundation.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <FacebookSDK/FacebookSDK.h>
//#import <SKMaps/SKMaps.h>
//#import "XMLParser.h"

//#import "SKTDownloadAPI.h"

@interface AppDelegate ()/*<SKMapVersioningDelegate>*/

@end

@implementation AppDelegate

#define appID @"xlCVt2FCqNUcf1FYAuBnegHqS5usIv6ZdG7HOtrJ"//@"HY7OwRI6Y4dpXCoShOj6x34zhpS5igolQFn3vtbh"//
#define clkey  @"tEWozbNNpzNnko5avXlvCZirZ6rl4hc5T8kqO3VA"//@"4S7bfPQIz0gkhzG7crvFS3CawO8xMWMLHZptiQgj"//
static NSString* const API_KEY = @"2a691899ebe7eb2a33d0bd6094be977c5768a2ea380736fdd21b8ac28a546c45";


@synthesize isPatient;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD setForegroundColor:[UIColor colorWithHexString:@"24465F"]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextColor, nil]];
    [[UINavigationBar appearance] setBackgroundImage: [UIImage imageNamed: @"header.png"] forBarMetrics: UIBarMetricsDefault];
    
    [Fabric with: @[CrashlyticsKit]];
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = appID;
        configuration.clientKey = clkey;
        configuration.server = @"https://parseapi.back4app.com/";
        configuration.localDatastoreEnabled = YES; // If you need to enable local data store
    }]];
    [PFUser enableRevocableSessionInBackground];
//    [Parse setApplicationId:appID
//                  clientKey:clkey];

    [PFFacebookUtils initializeFacebook];
    // Override point for customization after application launch.
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController* vc;
    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
       vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ViewController"];
    }
    else
    {
        vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ViewController~ipad"];
    }
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
    [nav.navigationController.navigationBar setHidden:YES];
    self.window.rootViewController=nav;
    isPatient=false;
    //Register Remote notification
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes  categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"fb5855845a4383a5b64a3cb470b904870b9e527906b43d6d180c720c9f5e6265" forKey:@"deviceToken"];
    return YES;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma -mark Notification Impl

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    if(deviceToken) {
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation setDeviceTokenFromData:deviceToken];
        [[NSUserDefaults standardUserDefaults] setObject:currentInstallation.objectId forKey:@"objectId"];
        [currentInstallation saveInBackground];
    }
    
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError%@", error);
}


- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"user notification ===== %@",userInfo);
    //Set alert & sound
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    BOOL result = (state == UIApplicationStateActive);
    if (result) {
        AudioServicesPlaySystemSound (1104);
        NSDictionary* dic = [userInfo objectForKey:@"aps"];
        if ([dic objectForKey:@"alert"]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:[dic objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    //[PFPush handlePush:userInfo];
    //Set badge number
    if([userInfo objectForKey:@"badge"])
    {
        NSInteger bagdeNumber = [[userInfo objectForKey:@"badge"] integerValue];
        [application setApplicationIconBadgeNumber:bagdeNumber];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}



@end
