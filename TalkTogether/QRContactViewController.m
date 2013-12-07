//
//  QRContactViewController.m
//  TalkTogether
//
//  Created by PloyZb on 11/18/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "QRContactViewController.h"
#import "ChatViewController.h"

@interface QRContactViewController ()

@end

@implementation QRContactViewController
{
    NSString *objectID;
    NSString *userID;
}
@synthesize qrImg;

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
    
    [self.navigationController pushViewController:reader animated:YES];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    qrImg.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    objectID =  symbol.data ;
    
//    if (ใช่ QR เรา) {
        // ดึง userID จาก NSUserDefault
        NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
        userID = [defaultUserID stringForKey:@"userID"];
    
        // ไปหน้า chat
        ChatViewController *chatView =[self.storyboard instantiateViewControllerWithIdentifier:@"chatView"];
        chatView.recieveObjectID = objectID;
        chatView.recieveUserID = userID;
        chatView.recieveSender = @"1"; // กำหนดให้ผู้ส่งคือผู้ใช้
    
        [chatView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [reader.navigationController pushViewController:chatView animated:YES];
//    }else{
//        [reader.navigationController popViewControllerAnimated:YES];
//    }
}

@end
