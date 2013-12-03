//
//  GPSRegisterViewController.h
//  TalkTogether
//
//  Created by PloyZb on 11/20/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "postMessage.h"

@interface GPSRegisterViewController : UIViewController <CLLocationManagerDelegate>
{
    postMessage *sendBox;
}

@property (strong, nonatomic) IBOutlet UITextView *location;
@property (strong, nonatomic) IBOutlet UITextField *objectName;

//Add a location manager property to this app delegate
@property (strong, nonatomic) CLLocationManager *locationManager;

- (IBAction)register:(id)sender;
@end
