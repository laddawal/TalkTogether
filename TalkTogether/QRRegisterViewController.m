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

@end

@implementation QRRegisterViewController
{
    BOOL insertQRCode;
    
    NSString *userID;
}

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

//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    [receivedData setLength:0];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    sleep(2);
//    [receivedData appendData:data];
//}
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    // inform the user
//    UIAlertView *didFailWithErrorMessage = [[UIAlertView alloc] initWithTitle: @"NSURLConnection " message: @"didFailWithError"  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
//    [didFailWithErrorMessage show];
//	
//    //inform the user
//    NSLog(@"Connection failed! Error - %@", [error localizedDescription]);
//    
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    // Hide Progress
////    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    
//    if(!insertQRCode){
//        [loading dismissWithClickedButtonIndex:0 animated:YES];
//        if(receivedData)
//        {
//            id jsonObjects = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableContainers error:nil];
//            NSString *returnObjectID = [NSString stringWithFormat:@"%@",[jsonObjects objectForKey:@"objectID"]];
//            
//            if (![returnObjectID isEqual:@"-1"]&&![returnObjectID isEqual:@"-2"]) {
//            
//                // Generate QR From ObjectID
//                NSLog(@"ObjectID : %@",returnObjectID);
//                qrImage.image = [QRCodeGenerator qrImageForString:returnObjectID imageSize:qrImage.bounds.size.width];
//                
//                // Insert QR To DB
//                NSData *imageData = UIImageJPEGRepresentation(qrImage.image, 100);
//                
////                NSURL *url = [NSURL URLWithString:@"localhost/TalkTogether/saveQrcode.php"];
//                NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/saveQrcode.php"];
//
//                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
//                                                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
//                                                                   timeoutInterval:10.0];
//                [request setHTTPMethod:@"POST"];
//                // BOUNDARY
//                NSString *boundary = @"---------------------------14737809831466499882746641449";
//                // CONTENT TYPE
//                NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//                [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//                // MAKE BODY
//                NSMutableData *body = [NSMutableData data];
//                // IMAGE
//                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"img.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//                [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//                [body appendData:[NSData dataWithData:imageData]];
//                // OBJECT ID
//                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"objectID\"\r\n\r\n" ]dataUsingEncoding:NSUTF8StringEncoding]];
//                [body appendData:[[NSString stringWithString:returnObjectID] dataUsingEncoding:NSUTF8StringEncoding]];
//                // END
//                [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//                // SEND REQUEST
//                [request setHTTPBody:body];
//                
//                NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
//                
//                if (theConnection) {
//                    self.receivedData = [NSMutableData data];
//                } else {
//                    UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"NSURLConnection " message:@"Failed in viewDidLoad"  delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//                    [connectFailMessage show];
//                }
//                insertQRCode = true;
//            }else if([returnObjectID isEqual:@"-1"]){
//                // Not Complete
//                UIAlertView *alertNotComplete =[[UIAlertView alloc]
//                                                  initWithTitle:@"NOT COMPLETE"
//                                                  message:nil delegate:self
//                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alertNotComplete show];
//            }else{
//                // Connection Failed
//                UIAlertView *alertConFailed =[[UIAlertView alloc]
//                                                initWithTitle:@"CONNECTION FAILED"
//                                                message:nil delegate:self
//                                                cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alertConFailed show];
//            }
//        }
//    }else{
//        if(receivedData) // รับ return message จาก php
//        {
//            id jsonObjects = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableContainers error:nil];
//            
//            NSString *strReturnMessage = [jsonObjects objectForKey:@"returnMessage"];
//            NSLog(@"Message : %@",strReturnMessage);
//            
//            UIAlertView *alertReturnMessage =[[UIAlertView alloc]
//                                              initWithTitle:strReturnMessage
//                                              message:nil delegate:self
//                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alertReturnMessage show];
//            
//            // clear textfield when complete
//            if ([strReturnMessage isEqual: @"QRCODE UPLOAD COMPLETE"]) {
//                nameObject.text = @"";
//            }
//        }
//    }
//}

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

                BOOL finishSaveImage = [sendBox postImage:imageData withObjectID:returnObjectID toUrl:url];
                
                if(finishSaveImage){
                    NSLog(@"finish save image");
                }else{
                    NSLog(@"fail save image");
                }
            }
        }else{
            [sendBox getErrorMessage];
        }
        
        
//        NSMutableString *post = [NSMutableString stringWithFormat:@"objectName=%@&userID=%@",[nameObject text],userID];
//        
//        NSLog(@"%@",[nameObject text]);
//        
//        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
//        
//        NSURL *url = [NSURL URLWithString:@"localhost/TalkTogether/insertObjectName.php"];
////        NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/insertObjectName.php"];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
//                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
//                                                           timeoutInterval:10.0];
//        [request setHTTPMethod:@"POST"];
//        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//        [request setValue:@"application/x-www-form-urlencoded ; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
//        [request setHTTPBody:postData];
//        
//        NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
//        
//        // Show Progress Loading...
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        
//        loading = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Wait..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//        UIActivityIndicatorView *progress= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
//        progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
//        [loading addSubview:progress];
//        [progress startAnimating];
//        [loading show];
//        
//        if (theConnection) {
//            self.receivedData = [NSMutableData data];
//        } else {
//            UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"NSURLConnection " message:@"Failed in viewDidLoad"  delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//            [connectFailMessage show];
//        }
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
