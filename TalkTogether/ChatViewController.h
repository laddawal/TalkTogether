//
//  ChatViewController.h
//  TalkTogether
//
//  Created by PloyZb on 11/22/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"
#import "postMessage.h"

@interface ChatViewController : UIViewController
{
    postMessage *sendBox;
}

@property (strong, nonatomic) IBOutlet UIBubbleTableView *myTable;
@property (strong, nonatomic) IBOutlet UIView *textViewInput;
@property (strong, nonatomic) IBOutlet UITextField *message;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *detailObjectBtn;

@property (strong, nonatomic) id recieveObjectID;
@property (strong, nonatomic) id recieveContactID;
@property (strong, nonatomic) id recieveSender;
@property (strong, nonatomic) id recieveResponderID;

- (IBAction)sendBtn:(id)sender;
- (IBAction)detailView:(id)sender;

@end
