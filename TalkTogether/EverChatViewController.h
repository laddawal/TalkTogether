//
//  EverChatViewController.h
//  TalkTogether
//
//  Created by PloyZb on 12/20/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "postMessage.h"

@interface EverChatViewController : UIViewController
{
    postMessage *sendBox;
}

@property (strong, nonatomic) id recieveUserID;
@property (strong, nonatomic) IBOutlet UITableView *myTable;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
