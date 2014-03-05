//
//  BarcodeRegisterViewController.h
//  TalkTogether
//
//  Created by PloyZb on 11/19/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "postMessage.h"

@interface BarcodeRegisterViewController : UIViewController <ZBarReaderDelegate>
{
    postMessage *sendBox;
}

@property (strong, nonatomic) IBOutlet UIImageView *barCodeImg;

- (IBAction)scanBtn:(id)sender;
@end
