//
//  EditResponderViewController.h
//  TalkTogether
//
//  Created by PloyZb on 12/25/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "postMessage.h"

@interface EditResponderViewController : UIViewController
{
    postMessage *sendBox;
}

@property (strong, nonatomic) id recieveUserID;
@property (strong, nonatomic) id recieveObjectID;
@property (strong, nonatomic) id recievePermission;
@property (strong, nonatomic) id recieveResponderName;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentItem;
@property (strong, nonatomic) IBOutlet UILabel *responderNameLabel;

- (IBAction)segmentChange:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)deleteResponder:(id)sender;
@end
