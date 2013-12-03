//
//  GPSRegisterViewController.m
//  TalkTogether
//
//  Created by PloyZb on 11/20/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "GPSRegisterViewController.h"

@interface GPSRegisterViewController ()

@end

@implementation GPSRegisterViewController
{
    NSString *userID;
    
    double latitude;
    double longitude;
}
@synthesize location;
@synthesize objectName;
@synthesize locationManager;

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_background.png"]]; // bg
    
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
         
            // Show Location
            self.location.text=[NSString stringWithFormat:@"latitude: %+.7f\nlongitude: %+.7f\naccuracy: %f",
                                newLocation.coordinate.latitude,
                                newLocation.coordinate.longitude,
                                newLocation.horizontalAccuracy];
            
            latitude = newLocation.coordinate.latitude;
            longitude = newLocation.coordinate.longitude;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    [receivedData setLength:0];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    sleep(2);
//    [receivedData appendData:data];
//}
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    // inform the user
//    UIAlertView *didFailWithErrorMessage = [[UIAlertView alloc] initWithTitle: @"NSURLConnection " message: @"didFailWithError"  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
//    [didFailWithErrorMessage show];
//	
//    //inform the user
//    NSLog(@"Connection failed! Error - %@", [error localizedDescription]);
//    
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    // Hide Progress
//    //    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    
//    [loading dismissWithClickedButtonIndex:0 animated:YES];
//    
//    if(receivedData) // รับ return message จาก php
//    {
//        id jsonObjects = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableContainers error:nil];
//        
//        NSString *strReturnMessage = [NSString stringWithFormat:@"%@",[jsonObjects objectForKey:@"returnMessage"]];
//        NSLog(@"Message : %@",strReturnMessage);
//        
//        UIAlertView *alertReturnMessage =[[UIAlertView alloc]
//                                          initWithTitle:strReturnMessage
//                                          message:nil delegate:self
//                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertReturnMessage show];
//        
//        // clear UIImage
//        location.text = NULL;
//        
//        // clear TextField
//        objectName.text = NULL;
//    }
//}

- (IBAction)register:(id)sender {
    [objectName resignFirstResponder]; // Hide KeyBoard with button
    
    if ([[objectName text] isEqual:@""]) {
        UIAlertView *alertTextFieldNull =[[UIAlertView alloc]
                                          initWithTitle:@"กรุณาใส่ชื่อวัตถุ"
                                          message:nil delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertTextFieldNull show];
    }else{
        // ดึง userID จาก NSUserDefault
        NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
        userID = [defaultUserID stringForKey:@"userID"];
        
        //ส่ง ObjectName & UserID ให้ php
        
        NSMutableString *post = [NSMutableString stringWithFormat:@"objectName=%@&userID=%@&latitude=%+.7f&longitude=%+.7f",[objectName text],userID,latitude,longitude];
        
        NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/insertGPS.php"];
        
        NSMutableArray * jsonReturn = [sendBox post:post toUrl:url];
        
        if (jsonReturn != nil) {
            for (NSDictionary* fetchDict in jsonReturn){
                NSString *strReturnMessage = [NSString stringWithFormat:@"%@",[fetchDict objectForKey:@"returnMessage"]];
                
                UIAlertView *alertReturnMessage =[[UIAlertView alloc]
                                                  initWithTitle:strReturnMessage
                                                  message:nil delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertReturnMessage show];
                
                // clear UIImage
                location.text = NULL;
                
                // clear TextField
                objectName.text = NULL;
            }
        }else{
            [sendBox getErrorMessage];
        }
        
        
//        NSMutableString *post = [NSMutableString stringWithFormat:@"objectName=%@&userID=%@&latitude=%+.7f&longitude=%+.7f",[objectName text],userID,latitude,longitude];
//        
//        NSLog(@"%@",[objectName text]);
//        
//        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
//        
//        NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/insertGPS.php"];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
//                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
//                                                           timeoutInterval:10.0];
//        [request setHTTPMethod:@"POST"];
//        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//        [request setValue:@"application/x-www-form-urlencoded ; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
//        [request setHTTPBody:postData];
//        
//        NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
//        
//        // Show Progress Loading...
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        
//        loading = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Wait..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//        UIActivityIndicatorView *progress= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
//        progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
//        [loading addSubview:progress];
//        [progress startAnimating];
//        [loading show];
//        
//        if (theConnection) {
//            self.receivedData = [NSMutableData data];
//        } else {
//            UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"NSURLConnection " message:@"Failed in viewDidLoad"  delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//            [connectFailMessage show];
//        }
    }
}
@end
