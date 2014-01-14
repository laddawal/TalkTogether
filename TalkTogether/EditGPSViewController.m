//
//  EditGPSViewController.m
//  TalkTogether
//
//  Created by PloyZb on 1/14/57 BE.
//  Copyright (c) 2557 PloyZb. All rights reserved.
//

#import "EditGPSViewController.h"
#import "DisplayMap.h"

@interface EditGPSViewController ()
{
    double latitude;
    double longitude;
}
@end

@implementation EditGPSViewController
@synthesize locationManager;
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]; // bg
    
    // Create object
    locationManager=[[CLLocationManager alloc] init];
    
    locationManager.delegate=self;
    
    //The desired accuracy that you want, not guaranteed though
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    
    //The distance in meters a device must move before an update event is triggered
    locationManager.distanceFilter=500;
    self.locationManager=locationManager;
    
    if([CLLocationManager locationServicesEnabled]){
        [self.locationManager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if (abs(howRecent) < 15.0)
    {
        //Location timestamp is within the last 15.0 seconds, let's use it!
        if(newLocation.horizontalAccuracy<35.0){
            //Location seems pretty accurate, let's use it!
            NSLog(@"latitude %+.7f, longitude %+.7f\n",
                  newLocation.coordinate.latitude,
                  newLocation.coordinate.longitude);
            NSLog(@"Horizontal Accuracy:%f", newLocation.horizontalAccuracy);
            
            //Optional: turn off location services once we've gotten a good location
            [manager stopUpdatingLocation];
            
            latitude = newLocation.coordinate.latitude;
            longitude = newLocation.coordinate.longitude;
            
            // กำหนด latitude longtitude ลงในแผนที่
            mapView.hidden = NO;
            [mapView setMapType:MKMapTypeStandard];
            [mapView setZoomEnabled:YES];
            [mapView setScrollEnabled:YES];
            MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
            region.center.latitude = latitude;
            region.center.longitude = longitude;
            region.span.longitudeDelta = 0.01f;
            region.span.latitudeDelta = 0.01f;
            [mapView setRegion:region animated:YES];
            
            [mapView setDelegate:self];
            
            DisplayMap *ann = [[DisplayMap alloc] init];
            ann.title = @"ตำแหน่งใหม่";
            ann.coordinate = region.center;
            [mapView addAnnotation:ann];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
