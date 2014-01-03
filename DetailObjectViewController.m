//
//  DetailObjectViewController.m
//  TalkTogether
//
//  Created by PloyZb on 12/9/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "DetailObjectViewController.h"
#import "ResponViewController.h"
#import "DisplayMap.h"

@interface DetailObjectViewController ()
{
    NSString *objectID;
    NSString *objectName;
    NSString *latitude,*longitude;
    NSString *barcodeID;
    NSString *userID;
    NSString *urlQR;
}
@end

@implementation DetailObjectViewController
@synthesize recieveObjectID;
@synthesize scrollView;
@synthesize viewName,viewQR,viewBarcode,viewGPS,viewFAQ;
@synthesize mapView;
@synthesize barcodeIDLabel;
@synthesize nameDetail;
@synthesize qrImage;
@synthesize saveQR,editGPS,save,setting;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320, 1250)];
    
    [nameDetail setDelegate:self];
    
    // bg subview
    viewName.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewName.png"]];
    viewQR.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewQR.png"]];
    viewBarcode.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewName.png"]];
    viewGPS.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewGPS.png"]];
    viewFAQ.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewName.png"]];
    
    // รับ objectID จาหหน้าก่อนหน้า
    objectID = [recieveObjectID description];
    
    sendBox = [[postMessage alloc]init];
    
    //ส่ง objectID ให้ php เพื่อเอารายละเอียดวัตถุ
    NSString *post = [NSString stringWithFormat:@"objectID=%@",objectID];
    
    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/getObjectDetail.php"];
    
    BOOL error = [sendBox post:post toUrl:url];
    
    if (!error) {
        int returnNum = [sendBox getReturnMessage];
        if (returnNum == 0) {
            NSMutableArray *jsonReturn = [sendBox getData];
            for (NSDictionary* fetchDict in jsonReturn){
                objectName = [NSString stringWithFormat:@"%@",[fetchDict objectForKey:@"objectName"]];
                latitude = [NSString stringWithFormat:@"%@",[fetchDict objectForKey:@"latitude"]];
                longitude = [NSString stringWithFormat:@"%@",[fetchDict objectForKey:@"longitude"]];
                barcodeID = [NSString stringWithFormat:@"%@",[fetchDict objectForKey:@"barcodeID"]];
                urlQR = [NSString stringWithFormat:@"%@",[fetchDict objectForKey:@"QRcodeImg"]];
            }
            
            // Name
            nameDetail.text = objectName;
            
            // QR Code
            NSURL *url = [NSURL URLWithString:urlQR];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            qrImage.image = img;
            if (qrImage == NULL) {
                qrImage.hidden = YES;
            }else{
                qrImage.hidden = NO;
            }
            
            // Map
            if ([latitude isEqualToString:@"<null>"] && [longitude isEqualToString:@"<null>"]) {
                mapView.hidden = YES;
            }else{
                mapView.hidden = NO;
                [mapView setMapType:MKMapTypeStandard];
                [mapView setZoomEnabled:YES];
                [mapView setScrollEnabled:YES];
                MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
                region.center.latitude = [latitude doubleValue];
                region.center.longitude = [longitude doubleValue];
                region.span.longitudeDelta = 0.01f;
                region.span.latitudeDelta = 0.01f;
                [mapView setRegion:region animated:YES];
                
                [mapView setDelegate:self];
                
                DisplayMap *ann = [[DisplayMap alloc] init];
                ann.title = objectName; // objectName
                //	ann.subtitle = @"เลขที่ 1693 ถนนพหลโยธิน เขตจตุจักร กรุงเทพมหานคร";
                ann.coordinate = region.center;
                [mapView addAnnotation:ann];
            }
            
            // Barcode
            if ([barcodeID isEqualToString:@"<null>"]) {
                barcodeIDLabel.text = @"ไม่มี Barcode";
            }else{
                barcodeIDLabel.text = barcodeID;
            }
            
            // Check Permission
            // ดึง userID จาก NSUserDefault
            NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
            userID = [defaultUserID stringForKey:@"userID"];
            post = [NSString stringWithFormat:@"userID=%@&objectID=%@",userID,objectID];
            
            url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/getPermission.php"];
            
            error = [sendBox post:post toUrl:url];
            
            if (!error) {
                int returnNum = [sendBox getReturnMessage];
                if (returnNum == 0) {
                    NSMutableArray *jsonReturn = [sendBox getData];
                    NSString *permission;
                    for (NSDictionary* fetchDict in jsonReturn){
                        permission = [NSString stringWithFormat:@"%@",[fetchDict objectForKey:@"permission"]];
                    }
                    if ([permission isEqualToString:@"1"]) {
                        [nameDetail setBorderStyle:UITextBorderStyleRoundedRect];
                        [nameDetail setEnabled:YES];
                        saveQR.hidden = NO;
                        editGPS.hidden = NO;
                        save.hidden = NO;
                        [setting setEnabled:YES];
                    }else{
                        [nameDetail setBorderStyle:UITextBorderStyleNone];
                        [nameDetail setEnabled:NO];
                        saveQR.hidden = YES;
                        editGPS.hidden = YES;
                        save.hidden = YES;
                        [setting setEnabled:NO];
                    }
                }
            }
        }
    }else{
        [sendBox getErrorMessage];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openSheet:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"เลือก"
                                        delegate:self
                               cancelButtonTitle:@"ยกเลิก"
                          destructiveButtonTitle:nil
                               otherButtonTitles:@"ตั้งค่าผู้รับผิดชอบ", @"จัดการ FAQ", nil];
    // Show the sheet
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
            // ไปหน้า Respon (รายชื่อผู้รับผิดชอบ)
            ResponViewController *responView =[self.storyboard instantiateViewControllerWithIdentifier:@"responView"];
            responView.recieveObjectID = objectID;
            
            [responView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            
            [self.navigationController pushViewController:responView animated:YES];
        }
            break;
        case 1:
            NSLog(@"Case : 2");
            break;
        default:
            break;
    }
}
@end

