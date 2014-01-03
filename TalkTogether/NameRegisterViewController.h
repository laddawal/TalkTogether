//
//  NameRegisterViewController.h
//  TalkTogether
//
//  Created by PloyZb on 11/12/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "postMessage.h"

@interface NameRegisterViewController : UIViewController <UITextFieldDelegate>
{
    postMessage *sendBox;
}

@property (strong, nonatomic) IBOutlet UITextField *objectName;

- (IBAction)nameRegisterBtn:(id)sender;

@end
