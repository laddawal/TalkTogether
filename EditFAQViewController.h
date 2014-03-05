//
//  EditFAQViewController.h
//  TalkTogether
//
//  Created by PloyZb on 1/14/57 BE.
//  Copyright (c) 2557 PloyZb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "postMessage.h"

@interface EditFAQViewController : UIViewController <UITextFieldDelegate>
{
    postMessage *sendBox;
}

@property (strong, nonatomic) id recieveFaqID;
@property (strong, nonatomic) IBOutlet UITextField *questionTextField;
@property (strong, nonatomic) IBOutlet UITextField *answerTextField;
- (IBAction)saveFAQ:(id)sender;
@end
