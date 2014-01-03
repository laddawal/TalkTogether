//
//  EditResponderViewController.m
//  TalkTogether
//
//  Created by PloyZb on 12/25/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "EditResponderViewController.h"

@interface EditResponderViewController ()
{
    NSString *objectID;
    NSString *userID;
    NSString *permission;
    NSString *permissionChange;
    NSString *responderName;
}
@end

@implementation EditResponderViewController
@synthesize recieveUserID;
@synthesize recievePermission;
@synthesize recieveObjectID;
@synthesize segmentItem;
@synthesize recieveResponderName;
@synthesize responderNameLabel;

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
    
    sendBox = [[postMessage alloc]init];
    
    
    
    // รับ userID,responderName และ Permission
    userID = [recieveUserID description];
    permission = [recievePermission description];
    objectID = [recieveObjectID description];
    responderName = [recieveResponderName description];
    
    responderNameLabel.text = responderName;
    
    // Update Segment Control
    permissionChange = permission;
    [self updateSegment];
}

-(void) updateSegment
{
    if ([permissionChange isEqualToString:@"1"]) {
        segmentItem.selectedSegmentIndex = 0;
    }else{
        segmentItem.selectedSegmentIndex = 1;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentChange:(id)sender {
    UISegmentedControl *segmented = (UISegmentedControl *)sender;
    switch (segmented.selectedSegmentIndex) {
        case 0:
            permissionChange = @"1";
            break;
            
        case 1:
            permissionChange = @"2";
            break;
    }
}

- (IBAction)save:(id)sender {
    if (![permissionChange isEqualToString:permission]) {
        //ส่ง userID,objectID,permission ให้ php แก้ไข permission
        NSString *post = [NSString stringWithFormat:@"userID=%@&objectID=%@&permission=%@",userID,objectID,permissionChange];
        
        NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/editPermission.php"];
        
        BOOL error = [sendBox post:post toUrl:url];
        
        if (!error) {
            // Update Segment Control
            if ([permissionChange isEqualToString:@"1"]) {
                segmentItem.selectedSegmentIndex = 0;
            }else{
                segmentItem.selectedSegmentIndex = 1;
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [sendBox getErrorMessage];
        }
    }
}

- (IBAction)deleteResponder:(id)sender {
    //ส่ง userID,objectID ให้ php ลบออกจากความเป็นผู้รับผิดชอบ
    NSString *post = [NSString stringWithFormat:@"userID=%@&objectID=%@",userID,objectID];
    
    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/deleteResponder.php"];
    
    BOOL error = [sendBox post:post toUrl:url];
    
    if (!error) {
        int returnNum = [sendBox getReturnMessage];
        if (returnNum == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertView *returnMessage = [[UIAlertView alloc]
                                          initWithTitle:@"ต้องมีผู้รับผิดชอบอย่างน้อย 1 คน"
                                          message:@"กรุณาเพิ่มผู้รับผิดชอบก่อนลบ" delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [returnMessage show];
        }
    }else{
        [sendBox getErrorMessage];
    }
}
@end
