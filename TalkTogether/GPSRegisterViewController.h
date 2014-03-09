//
//  GPSRegisterViewController.h
//  TalkTogether
//
//  Created by PloyZb on 11/20/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "postMessage.h"
#import <MapKit/MapKit.h>

@interface GPSRegisterViewController : UIViewController <MKMapViewDelegate,UITextFieldDelegate>
{
    postMessage *sendBox;
}

@property (strong, nonatomic) IBOutlet UITextField *objectName;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)register:(id)sender;
@end
