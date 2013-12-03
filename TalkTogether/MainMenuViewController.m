//
//  MainMenuViewController.m
//  TalkTogether
//
//  Created by PloyZb on 11/2/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "MainMenuViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface MainMenuViewController ()

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_background.png"]]; // bg
    
//    // ดึง userID จาก NSUserDefault
//    NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
//    NSString *userID = [defaultUserID stringForKey:@"userID"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    // Close session facebook
- (IBAction)logout:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate closeSession];
    
    LoginViewController *login =[self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    [login setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:login animated:NO completion:nil];
}
@end
