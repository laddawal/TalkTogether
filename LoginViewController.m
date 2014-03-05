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
{
    BOOL flagFacebookID;
}
@end

@implementation LoginViewController

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
        
        //Send FacebookID to php เพื่อค้นเอา userID กลับมาใช้งาน
        NSString *post = [NSString stringWithFormat:@"facebookID=%@&userName=%@",user.id,user.name];
        NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/loginUser.php"];
        BOOL error = [sendBox post:post toUrl:url];
        
        if (!error) {
            int returnNum = [sendBox getReturnMessage];
            if (returnNum == 0) {
                NSMutableArray *jsonReturn = [sendBox getData];
                
                NSString *strUserID;
                for (NSDictionary* fetchDict in jsonReturn){
                    strUserID = [NSString stringWithFormat:@"%@",[fetchDict objectForKey:@"userID"]];
                }
                
                // เก็บ userID ไว้ที่ NSUserDefault
                NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
                [defaultUserID setObject:strUserID forKey:@"userID"];
                
                // ไปหน้า main menu
                MainMenuViewController *mainMenu =[self.storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
                [mainMenu setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                [self presentViewController:mainMenu animated:NO completion:nil];
            }
        }else{
            [sendBox getErrorMessage];
        }
        flagFacebookID = false;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
