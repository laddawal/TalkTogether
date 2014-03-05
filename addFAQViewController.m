//
//  addFAQViewController.m
//  TalkTogether
//
//  Created by PloyZb on 1/14/57 BE.
//  Copyright (c) 2557 PloyZb. All rights reserved.
//

#import "addFAQViewController.h"

@interface addFAQViewController ()
{
    NSString *objectID;
    NSString *userID;
}
@end

@implementation addFAQViewController
@synthesize recieveObjectID;
@synthesize questionTextField;
@synthesize answerTextField;

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]; // bg
    
    // รับ objectID
    objectID = [recieveObjectID description];
    
    // ดึง userID จาก NSUserDefault
    NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
    userID = [defaultUserID stringForKey:@"userID"];
    
    [questionTextField setDelegate:self];
    [answerTextField setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveFAQ:(id)sender {
    sendBox = [[postMessage alloc]init];
    
    NSString *post = [NSString stringWithFormat:@"userID=%@&objectID=%@&question=%@&answer=%@",userID,objectID,[questionTextField text],[answerTextField text]];
    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/insertFAQ.php"];
    BOOL error = [sendBox post:post toUrl:url];
    
    if (!error) {
        // clear textField
        questionTextField.text = @"";
        answerTextField.text = @"";
        
        UIAlertView *returnMessage = [[UIAlertView alloc]
                                      initWithTitle:@"บันทึกเรียบร้อย"
                                      message:nil delegate:self
                                      cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [returnMessage show];
    }else{
        [sendBox getErrorMessage];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
