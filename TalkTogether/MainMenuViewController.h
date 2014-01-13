//
//  MainMenuViewController.h
//  TalkTogether
//
//  Created by PloyZb on 12/14/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "postMessage.h"

@interface MainMenuViewController : UIViewController
{
    postMessage *sendBox;
}

@property (strong, nonatomic) IBOutlet UIButton *chatHistoryBtn;

- (IBAction)logout:(id)sender;
- (IBAction)everChat:(id)sender;

@end
