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
    
    // Background Navigation Bar
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    
    // Navigation Bar Title Shadow
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0,2);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName, nil]];
    
    // Navigation Bar Tint Color
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];


    // Override point for customization after application launch.
    
    [self.window makeKeyAndVisible];
    
    

    return YES;
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
