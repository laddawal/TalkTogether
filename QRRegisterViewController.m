//
//  QRRegisterViewController.m
//  TalkTogether
//
//  Created by PloyZb on 11/4/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "QRRegisterViewController.h"
#import "QRCodeGenerator.h"

@interface QRRegisterViewController ()
{
    BOOL insertQRCode;
    
    NSString *userID;
    NSString *returnObjectID;
}
@end

@implementation QRRegisterViewController
@synthesize qrImage;
@synthesize nameObject;
@synthesize saveQrBtn;

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
    CGRect borderFrame = CGRectMake(0, 0, (qrImage.frame.size.width), (qrImage.frame.size.height));
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setBorderWidth:5.0];
    [borderLayer setBorderColor:[[UIColor whiteColor] CGColor]];
    [qrImage.layer addSublayer:borderLayer];
    
    sendBox = [[postMessage alloc]init];
    
    insertQRCode = false;
    
    [nameObject setDelegate:self];
    
    saveQrBtn.hidden = YES;
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

- (IBAction)generate:(id)sender {
    
    [nameObject resignFirstResponder]; // Hide KeyBoard with button
    
    if ([[nameObject text] isEqual:@""]) {
        UIAlertView *alertTextFieldNull =[[UIAlertView alloc]
                                          initWithTitle:@"กรุณาใส่ชื่อวัตถุ"
                                          message:nil delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertTextFieldNull show];
    }else{
        // ดึง userID จาก NSUserDefault
        NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
        userID = [defaultUserID stringForKey:@"userID"];
        
        //Send ObjectName
        NSMutableString *post = [NSMutableString stringWithFormat:@"objectName=%@&userID=%@",[nameObject text],userID];
        NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/insertObjectName.php"];
        
        BOOL error = [sendBox post:post toUrl:url];
        
        if (!error) {
            int returnNum = [sendBox getReturnMessage];
            if (returnNum == 0) {
                NSMutableArray *jsonReturn = [sendBox getData];
                for (NSDictionary* fetchDict in jsonReturn){
                    returnObjectID = [NSString stringWithFormat:@"%@",fetchDict];
                }
                
                if (![returnObjectID isEqualToString:@"<null>"]) { // ถ้า insertObjectName ได้
                    // Generate QR From ObjectID
                    saveQrBtn.hidden = NO;
                    qrImage.image = [QRCodeGenerator qrImageForString:returnObjectID imageSize:qrImage.bounds.size.width];
                    
                    // save QR Code ลง database
                    NSData *imageData = UIImageJPEGRepresentation(qrImage.image, 100);
                    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/saveQrcode.php"];
                    
                    error = [sendBox postImage:imageData withObjectID:returnObjectID toUrl:url];
                    if (error) { // สร้าง QR Code ไม่ได้
                        [sendBox getErrorMessage];
                    }
                }else{ // ถ้า insertObjectName ไม่ได้
                    saveQrBtn.hidden = YES;
                    UIAlertView *errorMessage =[[UIAlertView alloc]
                                   initWithTitle:@"การส่งข้อมูลผิดพลาด"
                                   message:nil delegate:self
                                   cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [errorMessage show];
                }
            }
        }else{
            [sendBox getErrorMessage];
        }
    }
}

// Save QR Code to Gallery
- (IBAction)saveQrImg:(id)sender {
    UIImageWriteToSavedPhotosAlbum(qrImage.image, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        UIAlertView *saveQrAlert = [[UIAlertView alloc]
                                      initWithTitle:@"จัดเก็บ QR Code ไม่สำเร็จ!!!"
                                      message:nil delegate:self
                                      cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [saveQrAlert show];
    } else {
        nameObject.text = @""; // clear textfield
        UIAlertView *saveQrAlert = [[UIAlertView alloc]
                                    initWithTitle:@"จัดเก็บ QR Code เรียบร้อย"
                                    message:nil delegate:self
                                    cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [saveQrAlert show];
    }
}
@end
