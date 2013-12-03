//
//  QRContactViewController.h
//  TalkTogether
//
//  Created by PloyZb on 11/18/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface QRContactViewController : UIViewController < ZBarReaderDelegate,UIAlertViewDelegate >

@property (strong, nonatomic) IBOutlet UIImageView *qrImg;
- (IBAction)scanBtn:(id)sender;

@end
