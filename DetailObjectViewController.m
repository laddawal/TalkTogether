//
//  DetailObjectViewController.m
//  TalkTogether
//
//  Created by PloyZb on 12/9/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "DetailObjectViewController.h"
#import "ResponViewController.h"

@interface DetailObjectViewController ()
{
    UIActionSheet *sheet;
    NSString *objectID;
}
@end

@implementation DetailObjectViewController
@synthesize recieveObjectID;
@synthesize scrollView;
@synthesize viewName,viewQR,viewBarcode,viewGPS;

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
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320, 700)];
    
    // bg subview
    viewName.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewName.png"]];
    viewQR.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewQR.png"]];
    viewBarcode.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewName.png"]];
    viewGPS.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewGPS.png"]];
    
    // รับ objectID จาหหน้าก่อนหน้า
    objectID = [recieveObjectID description];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openSheet:(id)sender {
    sheet = [[UIActionSheet alloc] initWithTitle:@"เลือก"
                                        delegate:self
                               cancelButtonTitle:@"ยกเลิก"
                          destructiveButtonTitle:nil
                               otherButtonTitles:@"แก้ไขวัตถุ", @"แก้ไขผู้ดูแล", @"จัดการ FAQ", nil];
    // Show the sheet
    [sheet showInView:self.view];
    //[sheet showInView:self.parentViewController.tabBarController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            NSLog(@"Case : 0");
            break;
        case 1:{
            // ไปหน้า Respon (รายชื่อผู้รับผิดชอบ)
            ResponViewController *responView =[self.storyboard instantiateViewControllerWithIdentifier:@"responView"];
            
            //    chatView.recieveUserID = [tmpDict objectForKey:@"userID"];
            //    chatView.recieveObjectID = objectID;
            //    chatView.recieveSender = @"2"; // กำหนดให้ผู้ส่งคือวัตถุ
            
            [responView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            
            [self.navigationController pushViewController:responView animated:YES];
        }
            break;
        case 2:
            NSLog(@"Case : 2");
            break;
        default:
            break;
    }
}
@end

