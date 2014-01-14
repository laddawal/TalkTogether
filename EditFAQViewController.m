//
//  EditFAQViewController.m
//  TalkTogether
//
//  Created by PloyZb on 1/14/57 BE.
//  Copyright (c) 2557 PloyZb. All rights reserved.
//

#import "EditFAQViewController.h"

@interface EditFAQViewController ()
{
    NSString *faqID;
}
@end

@implementation EditFAQViewController
@synthesize recieveFaqID;
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
    
    // รับ faqID
    faqID = [recieveFaqID description];
    
    sendBox = [[postMessage alloc]init];
    
    NSString *post = [NSString stringWithFormat:@"faqID=%@",faqID];
    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/getFAQForEdit.php"];
    BOOL error = [sendBox post:post toUrl:url];
    
    if (!error) {
        int returnNum = [sendBox getReturnMessage];
        if (returnNum == 0) {
            NSMutableArray *jsonReturn = [sendBox getData];
            for (NSDictionary* fetchDict in jsonReturn){
                questionTextField.text = [fetchDict objectForKey:@"question"];
                answerTextField.text = [fetchDict objectForKey:@"answer"];
            }
        }
    }else{
        [sendBox getErrorMessage];
    }
    
    [questionTextField setDelegate:self];
    [answerTextField setDelegate:self];
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

- (IBAction)saveFAQ:(id)sender {
    NSString *post = [NSString stringWithFormat:@"faqID=%@&question=%@&answer=%@",faqID,[questionTextField text],[answerTextField text]];
    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/editFAQ.php"];
    BOOL error = [sendBox post:post toUrl:url];
    
    if (!error) {
        UIAlertView *returnMessage = [[UIAlertView alloc]
                                      initWithTitle:@"บันทึกเรียบร้อย"
                                      message:nil delegate:self
                                      cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [returnMessage show];
    }else{
        [sendBox getErrorMessage];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
