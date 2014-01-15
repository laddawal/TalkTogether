//
//  EditBarcodeViewController.m
//  TalkTogether
//
//  Created by PloyZb on 1/14/57 BE.
//  Copyright (c) 2557 PloyZb. All rights reserved.
//

#import "EditBarcodeViewController.h"

@interface EditBarcodeViewController ()
{
    NSString *barcodeID;
}
@end

@implementation EditBarcodeViewController
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

- (IBAction)scan:(id)sender {
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
    barcodeID =  symbol.data ;
    
    // เก็บ barCodeID ไว้ที่ NSUserDefault
    NSUserDefaults *barcode = [NSUserDefaults standardUserDefaults];
    [barcode setObject:barcodeID forKey:@"barCodeID"];
    
    [reader dismissViewControllerAnimated:YES completion:nil]; // กลับหน้าแก้ไข Barcode
    [self.navigationController popViewControllerAnimated:YES]; // กลับหน้ารายละเอียดวัตถุ
}
@end
