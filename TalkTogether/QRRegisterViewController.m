//
//  QRRegisterViewController.m
//  TalkTogether
//
//  Created by PloyZb on 11/4/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "QRRegisterViewController.h"
#import "ZBarSDK.h"
#import "QRCodeGenerator.h"

@interface QRRegisterViewController ()
{
    BOOL insertQRCode;
    
    NSString *userID;
}
@end

@implementation QRRegisterViewController
@synthesize qrImage;
@synthesize nameObject;

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
    
    insertQRCode = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        NSMutableArray * jsonReturn = [sendBox post:post toUrl:url];
        
        if (jsonReturn != nil) {
            for (NSDictionary* fetchDict in jsonReturn){
                NSString *returnObjectID = [NSString stringWithFormat:@"%@",[fetchDict objectForKey:@"objectID"]];
                NSLog(@"QRRegisterObjectID : %@",returnObjectID);

                // Generate QR From ObjectID
                qrImage.image = [QRCodeGenerator qrImageForString:returnObjectID imageSize:qrImage.bounds.size.width];
//
                // Insert QR To DB
                NSData *imageData = UIImageJPEGRepresentation(qrImage.image, 100);
//
//                NSURL *url = [NSURL URLWithString:@"localhost/TalkTogether/saveQrcode.php"];
                NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/saveQrcode.php"];

                [sendBox postImage:imageData withObjectID:returnObjectID toUrl:url];
                // ตรวจสอบการบันทึกภาพที่นี่
            }
        }else{
            // ทำเมื่อเกิด error
            ;
        }
    }
}

// Save QR Code to Gallery
- (IBAction)saveQrImg:(id)sender {
    UIImageWriteToSavedPhotosAlbum(qrImage.image,
                                   self, // send the message to 'self' when calling the callback
                                   @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), // the selector to tell the method to call on completion
                                   NULL); // you generally won't need a contextInfo here
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        NSLog(@"Can't Save!!!");
    } else {
        NSLog(@"Saved");
    }
}
@end
