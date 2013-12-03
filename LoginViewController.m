//
//  LoginViewController.m
//  TalkTogether
//
//  Created by PloyZb on 10/31/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "LoginViewController.h"
#import "MainMenuViewController.h"
#import "AppDelegate.h"

@interface LoginViewController () <FBLoginViewDelegate>

@end

@implementation LoginViewController
{
    BOOL flagFacebookID;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginView1.png"]]; // bg

    flagFacebookID = true;
    
    sendBox = [[postMessage alloc]init];
    
    // Create Login View
    FBLoginView *loginview = [[FBLoginView alloc]initWithReadPermissions:@[@"basic_info"]];
    
    loginview.frame = CGRectOffset(loginview.frame, 10, 10);
    
    // ตำแหน่งปุ่ม login
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        loginview.frame = CGRectOffset(loginview.frame, 40, 495);
    }
    
    loginview.delegate = self;
    
    [self.view addSubview:loginview];
    
    [loginview sizeToFit];

}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    if (flagFacebookID) {
        NSLog(@"facebookID : %@",user.id);
        
        //Send FacebookID to php เพื่อค้นเอา userID กลับมาใช้งาน
        
        NSString *post = [NSString stringWithFormat:@"facebookID=%@&userName=%@",user.id,user.name];
        
        NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/loginUser.php"];
        
        NSMutableArray * jsonReturn = [sendBox post:post toUrl:url];
        
        if (jsonReturn != nil) {
            NSString *strUserID;
            for (NSDictionary* fetchDict in jsonReturn){
                strUserID = [NSString stringWithFormat:@"%@",[fetchDict objectForKey:@"userID"]];
            }            
            
            NSLog(@"LoginUserID : %@",strUserID);
            
            // เก็บ userID ไว้ที่ NSUserDefault
            NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
            [defaultUserID setObject:strUserID forKey:@"userID"];
            
            // ไปหน้า main menu
            MainMenuViewController *mainMenu =[self.storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
            [mainMenu setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [self presentViewController:mainMenu animated:NO completion:nil];
        }else{
            [sendBox getErrorMessage];
        }
        
        flagFacebookID = false;
        
    }
}

//- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
//    NSString *alertMessage, *alertTitle;
//    if (error.fberrorShouldNotifyUser) {
//        // If the SDK has a message for the user, surface it. This conveniently
//        // handles cases like password change or iOS6 app slider state.
//        alertTitle = @"Facebook Error";
//        alertMessage = error.fberrorUserMessage;
//    } else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
//        // It is important to handle session closures since they can happen
//        // outside of the app. You can inspect the error for more context
//        // but this sample generically notifies the user.
//        alertTitle = @"Session Error";
//        alertMessage = @"Your current session is no longer valid. Please log in again.";
//    } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
//        // The user has cancelled a login. You can inspect the error
//        // for more context. For this sample, we will simply ignore it.
//        NSLog(@"user cancelled login");
//    } else {
//        // For simplicity, this sample treats other errors blindly.
//        alertTitle  = @"Unknown Error";
//        alertMessage = @"Error. Please try again later.";
//        NSLog(@"Unexpected error:%@", error);
//    }
//    
//    if (alertMessage) {
//        [[[UIAlertView alloc] initWithTitle:alertTitle
//                                    message:alertMessage
//                                   delegate:nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles:nil] show];
//    }
//}

//// Convenience method to perform some action that requires the "publish_actions" permissions.
//- (void) performPublishAction:(void (^)(void)) action {
//    // we defer request for permission to post to the moment of post, then we check for the permission
//    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
//        // if we don't already have the permission, then we request it now
//        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
//                                              defaultAudience:FBSessionDefaultAudienceFriends
//                                            completionHandler:^(FBSession *session, NSError *error) {
//                                                if (!error) {
//                                                    action();
//                                                } else if (error.fberrorCategory != FBErrorCategoryUserCancelled){
//                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Permission denied"
//                                                                                                        message:@"Unable to get permission to post"
//                                                                                                       delegate:nil
//                                                                                              cancelButtonTitle:@"OK"
//                                                                                              otherButtonTitles:nil];
//                                                    [alertView show];
//                                                }
//                                            }];
//    } else {
//        action();
//    }
//    
//}

//- (void)showAlert:(NSString *)message
//           result:(id)result
//            error:(NSError *)error {
//    
//    NSString *alertMsg;
//    NSString *alertTitle;
//    if (error) {
//        alertTitle = @"Error";
//        // Since we use FBRequestConnectionErrorBehaviorAlertUser,
//        // we do not need to surface our own alert view if there is an
//        // an fberrorUserMessage unless the session is closed.
//        if (error.fberrorUserMessage && FBSession.activeSession.isOpen) {
//            alertTitle = nil;
//            
//        } else {
//            // Otherwise, use a general "connection problem" message.
//            alertMsg = @"Operation failed due to a connection problem, retry later.";
//        }
//    } else {
//        NSDictionary *resultDict = (NSDictionary *)result;
//        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.", message];
//        NSString *postId = [resultDict valueForKey:@"id"];
//        if (!postId) {
//            postId = [resultDict valueForKey:@"postId"];
//        }
//        if (postId) {
//            alertMsg = [NSString stringWithFormat:@"%@\nPost ID: %@", alertMsg, postId];
//        }
//        alertTitle = @"Success";
//    }
//    
//    if (alertTitle) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
//                                                            message:alertMsg
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
