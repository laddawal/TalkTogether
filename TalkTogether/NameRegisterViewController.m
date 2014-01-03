//
//  NameRegisterViewController.m
//  TalkTogether
//
//  Created by PloyZb on 11/12/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "NameRegisterViewController.h"

@interface NameRegisterViewController ()
{
    NSString *userID;
}
@end

@implementation NameRegisterViewController
@synthesize objectName;

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
    
    sendBox = [[postMessage alloc]init];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]; // bg
    
    [objectName setDelegate:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nameRegisterBtn:(id)sender {
    
    [objectName resignFirstResponder]; // Hide KeyBoard with button
    
    if ([[objectName text] isEqual:@""]) {
        UIAlertView *alertTextFieldNull =[[UIAlertView alloc]
                             initWithTitle:@"กรุณาใส่ชื่อวัตถุ"
                             message:nil delegate:self
                             cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertTextFieldNull show];
    }else{
        // ดึง userID จาก NSUserDefault
        NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
        userID = [defaultUserID stringForKey:@"userID"];
        
        //ส่ง ObjectName & UserID ให้ php
        NSMutableString *post = [NSMutableString stringWithFormat:@"objectName=%@&userID=%@",[objectName text],userID];
        NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/insertObjectName.php"];
        BOOL error = [sendBox post:post toUrl:url];
        
        if (!error) {
            UIAlertView *returnMessage = [[UIAlertView alloc]
                                          initWithTitle:@"สำเร็จ!!"
                                          message:nil delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [returnMessage show];
            
            // clear TextField
            objectName.text = NULL;
        }else{
            [sendBox getErrorMessage];
        }
    }
}
@end