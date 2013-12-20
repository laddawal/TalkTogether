//
//  MainMenuViewController.m
//  TalkTogether
//
//  Created by PloyZb on 12/14/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "MainMenuViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "EverChatViewController.h"

@interface MainMenuViewController ()
{
    NSString *userID;
}
@end

@implementation MainMenuViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// close session facebook
- (IBAction)logout:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate closeSession];
    
    LoginViewController *loginView =[self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    [loginView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:loginView animated:NO completion:nil];
}

- (IBAction)everChat:(id)sender {
    // ดึง userID จาก NSUserDefault
    NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
    userID = [defaultUserID stringForKey:@"userID"];
    
    // ไปหน้า detail
    EverChatViewController *everChatView =[self.storyboard instantiateViewControllerWithIdentifier:@"everChatView"];
    
    everChatView.recieveUserID = userID;
    //    detailView.recieveUserID = userID;
    //    detailView.recieveSender = @"1"; // กำหนดให้ผู้ส่งคือผู้ใช้
    
    [everChatView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController:everChatView animated:YES];
}
@end
