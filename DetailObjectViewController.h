//
//  DetailObjectViewController.h
//  TalkTogether
//
//  Created by PloyZb on 12/9/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "postMessage.h"

@interface DetailObjectViewController : UIViewController <MKMapViewDelegate,UITextFieldDelegate>
{
    postMessage *sendBox;
}

@property (strong, nonatomic) id recieveObjectID;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *viewName;
@property (strong, nonatomic) IBOutlet UIView *viewQR;
@property (strong, nonatomic) IBOutlet UIView *viewBarcode;
@property (strong, nonatomic) IBOutlet UIView *viewGPS;
@property (strong, nonatomic) IBOutlet UIView *viewFAQ;
@property (strong, nonatomic) IBOutlet UIView *viewRequestResponder;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *barcodeIDLabel;
@property (strong, nonatomic) IBOutlet UITextField *nameDetail;
@property (strong, nonatomic) IBOutlet UIImageView *qrImage;
@property (strong, nonatomic) IBOutlet UITableView *faqTable;

@property (strong, nonatomic) IBOutlet UIButton *saveQR;
@property (strong, nonatomic) IBOutlet UIButton *editGPS;
@property (strong, nonatomic) IBOutlet UIButton *save;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *setting;
@property (strong, nonatomic) IBOutlet UIButton *editFAQBtn;
@property (strong, nonatomic) IBOutlet UIButton *editBarcode;
@property (strong, nonatomic) IBOutlet UIButton *generateQr;
@property (strong, nonatomic) IBOutlet UIImageView *bgQr;

- (IBAction)saveQrImg:(id)sender;
- (IBAction)sendResponder:(id)sender;
- (IBAction)addFAQ:(id)sender;
- (IBAction)editDetail:(id)sender;
- (IBAction)goToResponView:(id)sender;
- (IBAction)generateQr:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *requestResponder;
@end
