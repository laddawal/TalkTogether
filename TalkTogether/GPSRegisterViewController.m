//
//  GPSRegisterViewController.m
//  TalkTogether
//
//  Created by PloyZb on 11/20/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "GPSRegisterViewController.h"
#import "DisplayMap.h"

@interface GPSRegisterViewController ()
{
    NSString *userID;
    
    double latitude;
    double longitude;
}
@end

@implementation GPSRegisterViewController
@synthesize objectName;
@synthesize mapView;

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
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5; //user needs to press for 0.5 seconds
    [self.mapView addGestureRecognizer:lpgr];
    
    [objectName setDelegate:self];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    DisplayMap *annot = [[DisplayMap alloc] init];
    
    annot.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:annot];
    
    [self.mapView removeGestureRecognizer:gestureRecognizer];
    
    latitude = touchMapCoordinate.latitude;
    longitude = touchMapCoordinate.longitude;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)register:(id)sender {
    [objectName resignFirstResponder]; // Hide KeyBoard with button
    if ([[objectName text] isEqual:@""]) {
        UIAlertView *alertTextFieldNull =[[UIAlertView alloc]
                                          initWithTitle:@"กรุณาใส่ชื่อวัตถุ"
                                          message:nil delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertTextFieldNull show];
    }else if([mapView.annotations count] == 0){
        UIAlertView *alertLocationNull =[[UIAlertView alloc]
                                          initWithTitle:@"กรุณาระบุตำแหน่งวัตถุ"
                                          message:nil delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertLocationNull show];
    }else{
        // ดึง userID จาก NSUserDefault
        NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
        userID = [defaultUserID stringForKey:@"userID"];
        
        //ส่ง ObjectName & UserID ให้ php
        NSMutableString *post = [NSMutableString stringWithFormat:@"objectName=%@&userID=%@&latitude=%.7f&longitude=%.7f",[objectName text],userID,latitude,longitude];
        NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/insertGPS.php"];
        BOOL error = [sendBox post:post toUrl:url];
        
        if(!error){
            UIAlertView *returnMessage = [[UIAlertView alloc]
                                          initWithTitle:@"สำเร็จ!!"
                                          message:nil delegate:self
                                          cancelButtonTitle:nil otherButtonTitles:nil];
            [returnMessage show];
            [returnMessage dismissWithClickedButtonIndex:0 animated:YES];
            
            // clear TextField
            objectName.text = NULL;
            
            [self.navigationController popViewControllerAnimated:YES]; // กลับหน้าลงทะเบียน
        }else{
            [sendBox getErrorMessage];
        }
    }
}
@end
