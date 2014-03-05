//
//  GPSContactViewController.h
//  TalkTogether
//
//  Created by PloyZb on 11/20/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "postMessage.h"

@interface GPSContactViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate>
{
    postMessage *sendBox;
}

@property (strong, nonatomic) IBOutlet MKMapView *nearObjMap;

//Add a location manager property to this app delegate
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
