//
//  GPSContactViewController.m
//  TalkTogether
//
//  Created by PloyZb on 11/20/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "GPSContactViewController.h"
#import "ChatViewController.h"

@interface GPSContactViewController ()

@end

@implementation GPSContactViewController
{
    NSMutableArray *myObject;
    
    double latitude;
    double longitude;
    
    NSString *userID;
}

@synthesize locationManager;
@synthesize nearObject;

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
            
            latitude = newLocation.coordinate.latitude;
            longitude = newLocation.coordinate.longitude;
            
            //ส่ง latitude & longtitude ให้ php เพื่อหาตำแหน่งวัตถุที่ใกล้เคียง
            
            NSMutableString *post = [NSMutableString stringWithFormat:@"latitude=%+.7f&longitude=%+.7f",latitude,longitude];
            
            NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/insertGPS.php"];
            
            NSMutableArray * jsonReturn = [sendBox post:post toUrl:url];
            
            if (jsonReturn != nil) {
                for (NSDictionary* fetchDict in jsonReturn){
                    [myObject addObject:fetchDict];
                }
                [nearObject reloadData];
            }else{
                [sendBox getErrorMessage];
            }
        }
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
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle : UITableViewCellStyleSubtitle
                                      reuseIdentifier : CellIdentifier];
    }
    
    int nbCount = [myObject count];
    if (nbCount ==0)
        cell.textLabel.text = @"";
    else
    {
        NSDictionary *tmpDict = [myObject objectAtIndex:indexPath.row];
        
        // ObjectName
        NSString *text;
        text = [NSString stringWithFormat:@"objectName : %@",[tmpDict objectForKey:@"objectName"]];
        
        cell.textLabel.text = text;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDict = [myObject objectAtIndex:indexPath.row];
    
    // ดึง userID จาก NSUserDefault
    NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
    userID = [defaultUserID stringForKey:@"userID"];
    
    // ไปหน้า chat
    ChatViewController *chatView =[self.storyboard instantiateViewControllerWithIdentifier:@"chatView"];
    
    chatView.recieveObjectID = [tmpDict objectForKey:@"objectID"];
    chatView.recieveUserID = userID;
    chatView.recieveSender = @"1"; // กำหนดให้ผู้ส่งคือผู้ใช้
    
    [chatView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController:chatView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
