//
//  EditGPSViewController.h
//  TalkTogether
//
//  Created by PloyZb on 1/14/57 BE.
//  Copyright (c) 2557 PloyZb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface EditGPSViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate>

//Add a location manager property to this app delegate
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@end
