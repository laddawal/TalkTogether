//
//  ResponViewController.h
//  TalkTogether
//
//  Created by PloyZb on 12/10/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "postMessage.h"

@interface ResponViewController : UIViewController
{
    postMessage *sendBox;
}

@property (strong, nonatomic) IBOutlet UITableView *myTable;

@property (strong, nonatomic) id recieveObjectID;

- (IBAction)addResponder:(id)sender;
- (IBAction)deleteResponder:(id)sender;
@end
