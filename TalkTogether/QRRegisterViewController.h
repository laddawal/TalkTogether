//
//  QRRegisterViewController.h
//  TalkTogether
//
//  Created by PloyZb on 11/4/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "postMessage.h"

@interface QRRegisterViewController : UIViewController <ZBarReaderDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    postMessage *sendBox;
}

@property (strong, nonatomic) IBOutlet UITextField *nameObject;
@property (strong, nonatomic) IBOutlet UIImageView *qrImage;

- (IBAction)generate:(id)sender;
- (IBAction)saveQrImg:(id)sender;
@end