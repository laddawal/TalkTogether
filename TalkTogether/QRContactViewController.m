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
{
    NSString *objectID;
    NSString *userID;
    NSString *objectName;
}
@end

@implementation QRContactViewController
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
    
    sendBox = [[postMessage alloc]init];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]; // bg
    
    // border uiImage
    CALayer *borderLayer = [CALayer layer];
    CGRect borderFrame = CGRectMake(0, 0, (qrImg.frame.size.width), (qrImg.frame.size.height));
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setBorderWidth:5.0];
    [borderLayer setBorderColor:[[UIColor whiteColor] CGColor]];
    [qrImg.layer addSublayer:borderLayer];
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
    
    qrImg.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    objectID =  symbol.data ;
    
    [reader dismissViewControllerAnimated:YES completion:nil]; // กลับหน้าระบุวัตถุด้วย QR Code
//    [reader dismissViewControllerAnimated:YES completion:^{
//        [(UINavigationController *)self.presentingViewController popToRootViewControllerAnimated:YES];
//    }];
//    [self.navigationController popViewControllerAnimated:YES];
    
    NSLog(@"objectID : %@",objectID);
    
    //ส่ง objectID ให้ php เพื่อหา objectName
    NSString *post = [NSString stringWithFormat:@"objectID=%@",objectID];
    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/getObjectName.php"];
    BOOL error = [sendBox post:post toUrl:url];
    
    if (!error) {
        int returnNum = [sendBox getReturnMessage];
        if (returnNum == 0) {
            NSMutableArray *jsonReturn = [sendBox getData];
            for (NSDictionary* fetchDict in jsonReturn){
                objectName = [fetchDict objectForKey:@"objectName"];
            }
            // ดึง userID จาก NSUserDefault
            NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
            userID = [defaultUserID stringForKey:@"userID"];
            
            // ดึงผู้รับผิดชอบ
            NSMutableString *post = [NSMutableString stringWithFormat:@"objectID=%@&userID=%@",objectID,userID];
            NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/randomResponder.php"];
            BOOL error = [sendBox post:post toUrl:url];
            
            if (!error) {
                NSMutableArray *jsonReturn = [sendBox getData];
                NSString *responderID;
                for (NSDictionary* fetchDict in jsonReturn){
                    responderID = [fetchDict objectForKey:@"responder_ID"];
                }
            
                // ไปหน้า chat
                ChatViewController *chatView =[self.storyboard instantiateViewControllerWithIdentifier:@"chatView"];
                chatView.recieveObjectID = objectID;
                chatView.recieveContactID = userID;
                chatView.recieveSender = @"1"; // กำหนดให้ผู้ส่งคือผู้ใช้
                chatView.recieveResponderID = responderID;
                chatView.navigationItem.title = objectName;
                
                [chatView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                [self.navigationController pushViewController:chatView animated:YES];
            }else{
                [sendBox getErrorMessage];
            }
        }else{
            UIAlertView *returnMessage = [[UIAlertView alloc]
                                          initWithTitle:@"ไม่พบข้อมูล"
                                          message:nil delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [returnMessage show];
        }
    }else{
        [sendBox getErrorMessage];
    }
}

@end
