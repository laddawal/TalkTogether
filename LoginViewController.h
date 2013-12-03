//
//  LoginViewController.h
//  TalkTogether
//
//  Created by PloyZb on 10/31/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "postMessage.h"

@interface LoginViewController : UIViewController
{
    postMessage *sendBox;
}

//- (void)showAlert:(NSString *)message
//           result:(id)result
//            error:(NSError *)error;

@end
