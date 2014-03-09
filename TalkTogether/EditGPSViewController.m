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
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5; //user needs to press for 0.5 seconds
    [self.mapView addGestureRecognizer:lpgr];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    DisplayMap *annot = [[DisplayMap alloc] init];
    
    annot.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:annot];
    
    [self.mapView removeGestureRecognizer:gestureRecognizer];
    
    latitude = touchMapCoordinate.latitude;
    longitude = touchMapCoordinate.longitude;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender {
    NSString *latitudeStr = [NSString stringWithFormat:@"%.7f",latitude];
    NSString *longitudeStr = [NSString stringWithFormat:@"%.7f",longitude];
    
    // เก็บ latitude,longitude ไว้ที่ NSUserDefault
    NSUserDefaults *gps = [NSUserDefaults standardUserDefaults];
    [gps setObject:latitudeStr forKey:@"latitude"];
    [gps setObject:longitudeStr forKey:@"longitude"];
    
    [self.navigationController popViewControllerAnimated:YES]; // กลับหน้ารายละเอียดวัตถุ
}
@end
