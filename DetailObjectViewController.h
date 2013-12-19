//
//  DetailObjectViewController.h
//  TalkTogether
//
//  Created by PloyZb on 12/9/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailObjectViewController : UIViewController <UIActionSheetDelegate>

@property (strong, nonatomic) id recieveObjectID;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *viewName;
@property (strong, nonatomic) IBOutlet UIView *viewQR;
@property (strong, nonatomic) IBOutlet UIView *viewBarcode;
@property (strong, nonatomic) IBOutlet UIView *viewGPS;

- (IBAction)openSheet:(id)sender;
@end
