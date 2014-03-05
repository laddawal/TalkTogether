//
//  GPSContactViewController.m
//  TalkTogether
//
//  Created by PloyZb on 11/20/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "GPSContactViewController.h"
#import "ChatViewController.h"
#import "DisplayMap.h"

@interface GPSContactViewController ()
{
    NSMutableArray *myObject;
    
    double latitude;
    double longitude;
    
    NSString *userID;
}
@end

@implementation GPSContactViewController
@synthesize locationManager;
@synthesize nearObject;
@synthesize nearObjMap;

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
    
    sendBox = [[postMessage alloc]init];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]; // bg
    
    // Create array to hold dictionaries
    myObject = [[NSMutableArray alloc] init];
    
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

- (void)viewWillAppear:(BOOL)animated {
    [nearObject reloadData];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    CLLocationCoordinate2D currentCoordinates = newLocation.coordinate;
    
//    NSLog(@"Entered new Location with the coordinates Latitude: %f Longitude: %f", currentCoordinates.latitude, currentCoordinates.longitude);
    
    //Optional: turn off location services once we've gotten a good location
    [manager stopUpdatingLocation];
    
    latitude = currentCoordinates.latitude;
    longitude = currentCoordinates.longitude;
    
    //ส่ง latitude & longtitude ให้ php เพื่อหาวัตถุที่อยู่ในตำแหน่งใกล้เคียง
    NSMutableString *post = [NSMutableString stringWithFormat:@"latitude=%.7f&longitude=%.7f",latitude,longitude];
    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/searchGPS.php"];
    BOOL error = [sendBox post:post toUrl:url];
    
    if (!error) {
        int returnNum = [sendBox getReturnMessage];
        if (returnNum == 0) {
            NSMutableArray *jsonReturn = [sendBox getData];
            for (NSDictionary* fetchDict in jsonReturn){
                [myObject addObject:fetchDict];
                // กำหนด latitude longtitude ลงในแผนที่
                nearObjMap.hidden = NO;
                [nearObjMap setMapType:MKMapTypeStandard];
                [nearObjMap setZoomEnabled:YES];
                [nearObjMap setScrollEnabled:YES];
                MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
                region.center.latitude = [[fetchDict objectForKey:@"latitude"] doubleValue];
                region.center.longitude = [[fetchDict objectForKey:@"longitude"] doubleValue];
                region.span.longitudeDelta = 0.01f;
                region.span.latitudeDelta = 0.01f;
                [nearObjMap setRegion:region animated:YES];
                
                [nearObjMap setDelegate:self];
                
                DisplayMap *ann = [[DisplayMap alloc] init];
                ann.title = [fetchDict objectForKey:@"objectName"];
                ann.coordinate = region.center;
                ann.subtitle = [fetchDict objectForKey:@"objectID"];
                [nearObjMap addAnnotation:ann];
            }
            [nearObject reloadData];
        }else{
            UIAlertView *returnMessage = [[UIAlertView alloc]
                                          initWithTitle:@"ไม่พบข้อมูล"
                                          message:nil delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [returnMessage show];
        }
    }else{
        [sendBox getErrorMessage];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    // ดึง userID จาก NSUserDefault
    NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
    userID = [defaultUserID stringForKey:@"userID"];
    
    // ดึงผู้รับผิดชอบ
    NSMutableString *post = [NSMutableString stringWithFormat:@"objectID=%@&userID=%@",view.annotation.subtitle,userID];
    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/randomResponder.php"];
    BOOL error = [sendBox post:post toUrl:url];
    
    if (!error) {
        NSMutableArray *jsonReturn = [sendBox getData];
        NSString *responderID;
        for (NSDictionary* fetchDict in jsonReturn){
            responderID = [fetchDict objectForKey:@"responder_ID"];
        }
        
        // ไปหน้า chat
        ChatViewController *chatView =[self.storyboard instantiateViewControllerWithIdentifier:@"chatView"];
        
        chatView.recieveObjectID = view.annotation.subtitle;
        chatView.recieveContactID = userID;
        chatView.recieveSender = @"1"; // กำหนดให้ผู้ส่งคือผู้ใช้
        chatView.recieveResponderID = responderID;
        chatView.navigationItem.title = view.annotation.title;
        
        [chatView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        
        [self.navigationController pushViewController:chatView animated:YES];
    }else{
        [sendBox getErrorMessage];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myObject count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"gpsContactCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // selected cell color
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithRed:134.0/255.0 green:114.0/255.0 blue:93.0/255.0 alpha:1.0]];
    [cell setSelectedBackgroundView:bgColorView];
    
    // selected cell text color
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    cell.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
    
    // cell text color
    cell.textLabel.textColor = [UIColor brownColor];
    
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle : UITableViewCellStyleDefault
                                      reuseIdentifier : CellIdentifier];
    }
    
    // ObjectName
    cell.textLabel.text = [[myObject objectAtIndex:indexPath.row] objectForKey:@"objectName"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ดึง userID จาก NSUserDefault
    NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
    userID = [defaultUserID stringForKey:@"userID"];
    
    // ดึงผู้รับผิดชอบ
    NSMutableString *post = [NSMutableString stringWithFormat:@"objectID=%@&userID=%@",[[myObject objectAtIndex:indexPath.row] objectForKey:@"objectID"],userID];
    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/randomResponder.php"];
    BOOL error = [sendBox post:post toUrl:url];
    
    if (!error) {
        NSMutableArray *jsonReturn = [sendBox getData];
        NSString *responderID;
        for (NSDictionary* fetchDict in jsonReturn){
            responderID = [fetchDict objectForKey:@"responder_ID"];
        }
    
        // ไปหน้า chat
        ChatViewController *chatView =[self.storyboard instantiateViewControllerWithIdentifier:@"chatView"];
        
        chatView.recieveObjectID = [[myObject objectAtIndex:indexPath.row] objectForKey:@"objectID"];
        chatView.recieveContactID = userID;
        chatView.recieveSender = @"1"; // กำหนดให้ผู้ส่งคือผู้ใช้
        chatView.recieveResponderID = responderID;
        chatView.navigationItem.title = [[myObject objectAtIndex:indexPath.row] objectForKey:@"objectName"];
        
        [chatView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        
        [self.navigationController pushViewController:chatView animated:YES];
    }else{
        [sendBox getErrorMessage];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
