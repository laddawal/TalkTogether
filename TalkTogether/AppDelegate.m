//
//  AppDelegate.m
//  TalkTogether
//
//  Created by PloyZb on 10/31/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        NSLog(@"In fallback handler");
                    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // FBSample logic
    // if the app is going away, we close the session object
    [FBSession.activeSession close];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // If you have not added the -ObjC linker flag, you may need to uncomment the following line because
    // Nib files require the type to have been loaded before they can do the wireup successfully.
    // http://stackoverflow.com/questions/1725881/unknown-class-myclass-in-interface-builder-file-error-at-runtime
    // [FBProfilePictureView class];
    
    [FBLoginView class];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // Background Navigation Bar
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav.png"] forBarMetrics:UIBarMetricsDefault];
    
    // Navugation Bar Tint Color
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"tabBar.png"] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
    
    // Override point for customization after application launch.
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // FBSample logic
    // Call the 'activateApp' method to log an app event for use in analytics and advertising reporting.
    [FBAppEvents activateApp];
    
    // FBSample logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    if([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])
    {
//        NSLog(@"Multitasking Supported");
        
        // Clear Notification & iconAppBadgeNumber
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
        
        __block UIBackgroundTaskIdentifier background_task;
        background_task = [application beginBackgroundTaskWithExpirationHandler:^ {
            
            //Clean up code. Tell the system that we are done.
            [application endBackgroundTask: background_task];
            background_task = UIBackgroundTaskInvalid;
        }];
        
        //To make the code block asynchronous
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //### background task starts
            NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
            NSString *userID = [defaultUserID stringForKey:@"userID"];
            
            sendBox = [[postMessage alloc]init];
            while(TRUE)
            {
                // เช็คข้อความใหม่
                NSMutableString *post = [NSMutableString stringWithFormat:@"userID=%@",userID];
                NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/getNotification.php"];
                BOOL error = [sendBox post:post toUrl:url];
                
                NSString *iconNum;
                
                if (!error) {
                    int returnNum = [sendBox getReturnMessage];
                    if (returnNum == 0) {
                        NSMutableArray *jsonReturn = [sendBox getData];
                        for (NSDictionary* fetchDict in jsonReturn){
                            iconNum = [NSString stringWithFormat:@"%@",fetchDict];
                        }
                    }
                }
                
                UILocalNotification *localNotification = [[UILocalNotification alloc] init]; //Create the local notification
//                [localNotification setFireDate:[NSDate dateWithTimeIntervalSinceNow:0]]; //Set the date when the alert will be launched
                
                [localNotification setAlertAction:@"Launch"]; //The button's text that launches the application and is shown in the alert
//                [localNotification setAlertBody:@"12345"]; //Set the message in the notification from the textField's text
                [localNotification setHasAction: YES]; //Set that pushing the button will launch the application
                [localNotification setApplicationIconBadgeNumber:[iconNum intValue]]; //Set the Application Icon
                
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification]; //Schedule the notification with the system
                
                [NSThread sleepForTimeInterval:60]; //wait for 60 sec
            }
            //#### background task ends

            //Clean up code. Tell the system that we are done.
            [application endBackgroundTask: background_task];
            background_task = UIBackgroundTaskInvalid; 
        });
    }
    else
    {
//        NSLog(@"Multitasking Not Supported");
    }
}

- (void) closeSession{
    [[FBSession activeSession] closeAndClearTokenInformation];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userID"];
    
    // ดึง userID จาก NSUserDefault
//    NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
//    NSString *userID = [defaultUserID stringForKey:@"userID"];
//    NSLog(@"userID : %@",userID);

//    [[NSUserDefaults standardUserDefaults] synchronize];

}

@end
