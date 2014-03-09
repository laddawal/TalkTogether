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
    
    UIImageView *badgeImageView;
    NSString *iconNum;
}
@end

@implementation MainMenuViewController
@synthesize chatHistoryBtn;

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

- (void) viewWillAppear:(BOOL)animated{
    sendBox = [[postMessage alloc]init];
    
    // ดึง userID จาก NSUserDefault
    NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
    userID = [defaultUserID stringForKey:@"userID"];
    
    // เช็คข้อความใหม่
    NSString *post = [NSString stringWithFormat:@"userID=%@",userID];
    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/getNotification.php"];
    BOOL error = [sendBox post:post toUrl:url];
    
    // hide notification
    badgeImageView.hidden = YES;
    if (!error) {
        int returnNum = [sendBox getReturnMessage];
        if (returnNum == 0) {
            NSMutableArray *jsonReturn = [sendBox getData];
            for (NSDictionary* fetchDict in jsonReturn){
                iconNum = [NSString stringWithFormat:@"%@",fetchDict];
            }
            
            // Bunton Badge Number
            UILabel *yourLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
            yourLabel.text = iconNum;
            yourLabel.textColor = [UIColor whiteColor];
            [yourLabel sizeToFit];
            
            CGRect labelFrame = yourLabel.frame;
            
            UIImage *badgeImage = [[UIImage imageNamed:@"badge.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
            badgeImageView = [[UIImageView alloc]initWithImage:badgeImage];
            
            badgeImageView.contentMode = UIViewContentModeScaleToFill;
            badgeImageView.backgroundColor = [UIColor clearColor];
            
            labelFrame.size.width += 13; // padding ซ้าย ขวา
            
            badgeImageView.frame = labelFrame;
            
            yourLabel.center = CGPointMake(badgeImageView.frame.size.width/2, badgeImageView.frame.size.height/2);
            
            [badgeImageView addSubview:yourLabel];
            
            badgeImageView.frame = CGRectOffset(badgeImageView.frame, 80, 0);
            
            [chatHistoryBtn addSubview:badgeImageView];
        }
    }
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
    
    [everChatView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController:everChatView animated:YES];
}
@end
