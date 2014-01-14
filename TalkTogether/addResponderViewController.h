//
//  addResponderViewController.h
//  TalkTogether
//
//  Created by PloyZb on 12/26/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "postMessage.h"

@interface addResponderViewController : UIViewController <UIActionSheetDelegate>
{
    postMessage *sendBox;
}
@property (strong, nonatomic) IBOutlet UITableView *myTable;

@property (strong, nonatomic) id recieveObjectID;

- (IBAction)submitRequest:(id)sender;
- (IBAction)deleteRequest:(id)sender;
@end
