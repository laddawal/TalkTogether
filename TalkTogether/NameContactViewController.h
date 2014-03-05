//
//  NameContactViewController.h
//  TalkTogether
//
//  Created by PloyZb on 11/5/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "postMessage.h"

@interface NameContactViewController : UIViewController
{
    postMessage *sendBox;
}

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *showObject;

@end
