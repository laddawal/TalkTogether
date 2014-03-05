//
//  EditBarcodeViewController.h
//  TalkTogether
//
//  Created by PloyZb on 1/14/57 BE.
//  Copyright (c) 2557 PloyZb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface EditBarcodeViewController : UIViewController <ZBarReaderDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *barCodeImg;
- (IBAction)scan:(id)sender;

@end
