//
//  BarcodeRegisterViewController.m
//  TalkTogether
//
//  Created by PloyZb on 11/19/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "BarcodeRegisterViewController.h"

@interface BarcodeRegisterViewController ()
{
    NSString *barCodeID;
    NSString *userID;
}
@end

@implementation BarcodeRegisterViewController
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scanBtn:(id)sender {
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarel used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self.navigationController pushViewController:reader animated:YES];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    barCodeImg.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    barCodeID =  symbol.data ;
    
    // ดึง userID จาก NSUserDefault
    NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
    userID = [defaultUserID stringForKey:@"userID"];
    
    //ส่ง ObjectName & UserID ให้ php
    
    NSMutableString *post = [NSMutableString stringWithFormat:@"barCodeID=%@&userID=%@",barCodeID,userID];
    
    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/insertBarcode.php"];
    
    [sendBox post:post toUrl:url];
            
    // clear UIImage
    barCodeImg.image = NULL;
    
//    [sendBox getErrorMessage];
    
    [reader.navigationController popViewControllerAnimated:YES];
}

@end
