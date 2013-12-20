//
//  BarcodeContactViewController.m
//  TalkTogether
//
//  Created by PloyZb on 11/19/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "BarcodeContactViewController.h"
#import "ChatViewController.h"

@interface BarcodeContactViewController ()
{
    NSString *barCodeID;
    NSString *userID;
    NSString *objectID;
    NSString *objectName;
}
@end

@implementation BarcodeContactViewController
@synthesize barCodeImg;

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
    
    // border uiImage
    CALayer *borderLayer = [CALayer layer];
    CGRect borderFrame = CGRectMake(0, 0, (barCodeImg.frame.size.width), (barCodeImg.frame.size.height));
    [borderLayer setBackgroundColor:[[UIColor lightGrayColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setBorderWidth:5.0];
    [borderLayer setBorderColor:[[UIColor whiteColor] CGColor]];
    [barCodeImg.layer addSublayer:borderLayer];

}

- (IBAction)scanBtn:(id)sender {
    NSLog(@"Scan");
    
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self.navigationController pushViewController:reader animated:YES];
//    [self presentViewController:reader animated:YES completion:nil];

}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    NSLog(@"Image Picker");
    
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    barCodeImg.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    barCodeID =  symbol.data ;
    NSLog(@"BarcodeID : %@",barCodeID);
    
    //ส่ง barcodeID ให้ php
    NSMutableString *post = [NSMutableString stringWithFormat:@"barcodeID=%@",barCodeID];
    
    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/searchBarcode.php"];
    
    NSMutableArray * jsonReturn = [sendBox post:post toUrl:url];
    
    if (jsonReturn != nil) {
        for (NSDictionary* fetchDict in jsonReturn){
            objectID = [NSString stringWithFormat:@"%@",[fetchDict objectForKey:@"objectID"]];
            objectName = [NSString stringWithFormat:@"%@",[fetchDict objectForKey:@"objectName"]];
            NSLog(@"BarcodeObjectID : %@",objectID);
        }
        
        // ดึง userID จาก NSUserDefault
        NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
        userID = [defaultUserID stringForKey:@"userID"];
        
        // ไปหน้า chat
        ChatViewController *chatView =[self.storyboard instantiateViewControllerWithIdentifier:@"chatView"];
        chatView.recieveObjectID = objectID;
        chatView.recieveUserID = userID;
        chatView.recieveSender = @"1"; // กำหนดให้ผู้ส่งคือผู้ใช้
        chatView.navigationItem.title = objectName;
        
        [chatView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [reader.navigationController pushViewController:chatView animated:YES];
    }else{
        [sendBox getErrorMessage];
        [reader.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
