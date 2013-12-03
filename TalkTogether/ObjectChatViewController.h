//
//  ObjectChatViewController.h
//  TalkTogether
//
//  Created by PloyZb on 12/1/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "postMessage.h"

@interface ObjectChatViewController : UIViewController
{
    postMessage *sendBox;
}

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UITableView *showUser;

- (IBAction)editObject:(id)sender;
@end
