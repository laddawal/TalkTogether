//
//  ResponViewController.h
//  TalkTogether
//
//  Created by PloyZb on 12/10/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ResponViewController : UIViewController <FBFriendPickerDelegate>

@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;

@end
