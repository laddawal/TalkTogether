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
    
    // border uiImage
    CALayer *borderLayer = [CALayer layer];
    CGRect borderFrame = CGRectMake(0, 0, (barCodeImg.frame.size.width), (barCodeImg.frame.size.height));
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setBorderWidth:5.0];
    [borderLayer setBorderColor:[[UIColor whiteColor] CGColor]];
    [barCodeImg.layer addSublayer:borderLayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scanBtn:(id)sender {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;

    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentViewController:reader animated:YES completion:nil];
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
    
    [reader dismissViewControllerAnimated:YES completion:nil]; // กลับหน้าลงทะเบียนด้วย Barcode
    
    // ดึง userID จาก NSUserDefault
    NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
    userID = [defaultUserID stringForKey:@"userID"];
    
    //ส่ง ObjectName & UserID ให้ php
    NSMutableString *post = [NSMutableString stringWithFormat:@"barCodeID=%@&userID=%@",barCodeID,userID];
    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/insertBarcode.php"];
    BOOL error = [sendBox post:post toUrl:url];
    if (!error) {
        UIAlertView *returnMessage = [[UIAlertView alloc]
                                      initWithTitle:@"สำเร็จ!!"
                                      message:nil delegate:self
                                      cancelButtonTitle:nil otherButtonTitles:nil];
        [returnMessage show];
        [returnMessage dismissWithClickedButtonIndex:0 animated:YES];
        [self.navigationController popViewControllerAnimated:YES]; // กลับหน้าลงทะเบียน
    }else{
        [sendBox getErrorMessage];
    }
}
@end
