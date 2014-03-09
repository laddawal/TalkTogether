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
#import <MapKit/MapKit.h>

@interface GPSRegisterViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate,UITextFieldDelegate>
{
    postMessage *sendBox;
}

@property (strong, nonatomic) IBOutlet UITextField *objectName;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;

- (IBAction)register:(id)sender;
@end
