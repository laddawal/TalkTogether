//
//  DetailObjectViewController.m
//  TalkTogether
//
//  Created by PloyZb on 12/9/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "DetailObjectViewController.h"
#import "ResponViewController.h"
#import "addFAQViewController.h"
#import "EditFAQViewController.h"
#import "DisplayMap.h"

@interface DetailObjectViewController ()
{
    NSString *objectID;
    NSString *objectName;
    NSString *latitude,*longitude;
    NSString *barcodeID;
    NSString *userID;
    NSString *urlQR;
    NSString *request;
    NSString *newLatitude,*newLongitude;
    NSString *newBarcodeID;
    
    BOOL flagResponder;
    
    NSMutableArray *myObject;
    
    NSString *post;
    NSURL *url;
    BOOL error;
}
@end

@implementation DetailObjectViewController
@synthesize recieveObjectID;
@synthesize scrollView;
@synthesize viewName,viewQR,viewBarcode,viewGPS,viewFAQ,viewRequestResponder;
@synthesize mapView,barcodeIDLabel,nameDetail,qrImage,faqTable;
@synthesize saveQR,editGPS,save,setting,editFAQBtn,requestResponder,editBarcode;

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
    [self.scrollView setContentSize:CGSizeMake(320, 1900)];
    
    [nameDetail setDelegate:self];
    
    // bg subview
    viewName.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewName.png"]];
    viewQR.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewQR.png"]];
    viewBarcode.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewName.png"]];
    viewGPS.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewGPS.png"]];
    viewFAQ.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewGPS.png"]];
    viewRequestResponder.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewName.png"]];
    
    // รับ objectID จาหหน้าก่อนหน้า
    objectID = [recieveObjectID description];
    
    sendBox = [[postMessage alloc]init];
    
    // ดึง userID จาก NSUserDefault
    NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
    userID = [defaultUserID stringForKey:@"userID"];
}

- (void) viewWillAppear:(BOOL)animated{
    myObject = [[NSMutableArray alloc] init];
    
    // ส่ง objectID เพื่อเอา FAQ
    post = [NSString stringWithFormat:@"objectID=%@",objectID];
    url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/getFAQ.php"];
    error = [sendBox post:post toUrl:url];
    
    if (!error) {
        int returnNum = [sendBox getReturnMessage];
        if (returnNum == 0) {
            NSMutableArray *jsonReturn = [sendBox getData];
            for (NSDictionary* fetchDict in jsonReturn){
                [myObject addObject:fetchDict];
            }
        }
    }else{
        [sendBox getErrorMessage];
    }
    [faqTable reloadData];
    
    // ถ้าไม่มี FAQ ให้ซ่อน faqTable
    if ([myObject count] == 0) {
        faqTable.hidden = YES;
    }else{
        faqTable.hidden = NO;
    }
    
    //ส่ง objectID ให้ php เพื่อเอารายละเอียดวัตถุ
    post = [NSString stringWithFormat:@"objectID=%@&userID=%@",objectID,userID];
    url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/getObjectDetail.php"];
    error = [sendBox post:post toUrl:url];
    
    if (!error) {
        int returnNum = [sendBox getReturnMessage];
        if (returnNum == 0) {
            NSMutableArray *jsonReturn = [sendBox getData];
            for (NSDictionary* fetchDict in jsonReturn){
                objectName = [NSString stringWithFormat:@"%@",[fetchDict objectForKey:@"objectName"]];
                latitude = [NSString stringWithFormat:@"%@",[fetchDict objectForKey:@"latitude"]];
                longitude = [NSString stringWithFormat:@"%@",[fetchDict objectForKey:@"longitude"]];
                barcodeID = [NSString stringWithFormat:@"%@",[fetchDict objectForKey:@"barcodeID"]];
//                urlQR = [NSString stringWithFormat:@"%@",[fetchDict objectForKey:@"QRcodeImg"]];
                request = [NSString stringWithFormat:@"%@",[fetchDict objectForKey:@"request"]];
            }
            
            // Name
            if ([[NSUserDefaults standardUserDefaults] stringForKey:@"objectName"] == NULL) { // เช็คว่ามี objectName ที่จะแก้ไหม ถ้าไม่แสดงอันที่มาจาก DB
                nameDetail.text = objectName;
            }else{ // ถ้ามีแสดงอันที่จะแก้
                nameDetail.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"objectName"];
            }
            
            // QR Code
            urlQR = [NSString stringWithFormat:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/uploads/%@.jpg",objectID];
            NSLog(@"%@",urlQR);
            url = [NSURL URLWithString:urlQR];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            qrImage.image = img;
            if ([urlQR isEqualToString:@"<null>"]) {
                qrImage.hidden = YES;
                saveQR.hidden = YES;
            }else{
                qrImage.hidden = NO;
                saveQR.hidden = NO;
            }
            
            // Map
            if ([[NSUserDefaults standardUserDefaults] stringForKey:@"latitude"] == NULL &&
                [[NSUserDefaults standardUserDefaults] stringForKey:@"longitude"] == NULL) { // เช็คว่ามี GPS ที่จะแก้ไหม ถ้าไม่มีแสดงอันที่มาจาก DB
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
                    ann.coordinate = region.center;
                    [mapView addAnnotation:ann];
                }
            }else{ // ถ้ามี แสดงอันที่จะแก้
                mapView.hidden = NO;
                [mapView setMapType:MKMapTypeStandard];
                [mapView setZoomEnabled:YES];
                [mapView setScrollEnabled:YES];
                MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
                region.center.latitude = [[[NSUserDefaults standardUserDefaults] stringForKey:@"latitude"] doubleValue];
                region.center.longitude = [[[NSUserDefaults standardUserDefaults] stringForKey:@"longitude"] doubleValue];
                region.span.longitudeDelta = 0.01f;
                region.span.latitudeDelta = 0.01f;
                [mapView setRegion:region animated:YES];
                
                [mapView setDelegate:self];
                
                DisplayMap *ann = [[DisplayMap alloc] init];
                ann.title = objectName; // objectName
                ann.coordinate = region.center;
                [mapView addAnnotation:ann];
            }
            
            // Barcode
            if ([[NSUserDefaults standardUserDefaults] stringForKey:@"barCodeID"] == NULL) { // เช็คว่ามี Barcode ที่ต้องแก้ไหมถ้า ไม่มีแสดงอันที่เอามาจาก DB
                if ([barcodeID isEqualToString:@"<null>"]) {
                    barcodeIDLabel.text = @"ไม่มี Barcode";
                }else{
                    barcodeIDLabel.text = barcodeID;
                }
            }else{ // ถ้ามี แสดงอันที่จะแก้
                barcodeIDLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"barCodeID"];
            }
            
            // Check Permission
            post = [NSString stringWithFormat:@"userID=%@&objectID=%@",userID,objectID];
            
            url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/getPermission.php"];
            
            error = [sendBox post:post toUrl:url];
            
            if (!error) {
                int returnNum = [sendBox getReturnMessage];
                if (returnNum == 0) { // เป็นผู้ดูแล
                    flagResponder = YES;
                    
                    [nameDetail setBorderStyle:UITextBorderStyleRoundedRect];
                    [nameDetail setEnabled:YES];
                    [setting setEnabled:YES];
                    editGPS.hidden = NO;
                    editFAQBtn.hidden = NO;
                    viewRequestResponder.hidden = YES;
                    editBarcode.hidden = NO;
                }else{ // เป็นผู้ติดต่อ
                    flagResponder = NO;
                    
                    if ([request isEqualToString:@"1"]) { // เคยส่งคำขอเป็นผู้ดูแลแล้ว
                        requestResponder.enabled = NO;
                        [requestResponder setTitle:@"ส่งคำขอเป็นผู้ดูแลแล้ว" forState:UIControlStateNormal];
                    }else{ // ยังไม่เคยส่งคำขอเป็นผู้ดูแล
                        requestResponder.enabled = YES;
                    }
                    [nameDetail setBorderStyle:UITextBorderStyleNone];
                    [nameDetail setEnabled:NO];
                    [setting setEnabled:NO];
                    saveQR.hidden = YES;
                    editGPS.hidden = YES;
                    save.hidden = YES;
                    editFAQBtn.hidden = YES;
                    viewRequestResponder.hidden = NO;
                    editBarcode.hidden = YES;
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

-(void)textFieldDidEndEditing:(UITextField *)textField{
    // เก็บ objectName ไว้ที่ NSUserDefault
    NSUserDefaults *name = [NSUserDefaults standardUserDefaults];
    [name setObject:[nameDetail text] forKey:@"objectName"];
}

// Save QR Code to Gallery
- (IBAction)saveQrImg:(id)sender {
    UIImageWriteToSavedPhotosAlbum(qrImage.image,
                                   self, // send the message to 'self' when calling the callback
                                   @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), // the selector to tell the method to call on completion
                                   NULL); // you generally won't need a contextInfo here
}

- (IBAction)sendResponder:(id)sender {
    post = [NSString stringWithFormat:@"userID=%@&objectID=%@",userID,objectID];
    url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/insertRequest.php"];
    error = [sendBox post:post toUrl:url];
    
    if (!error) {
        requestResponder.enabled = NO;
        [requestResponder setTitle:@"ส่งคำขอเป็นผู้ดูแลแล้ว" forState:UIControlStateNormal];
    }else{
        [sendBox getErrorMessage];
    }
}

- (IBAction)addFAQ:(id)sender {
    // ไปหน้าเพิ่ม FAQ
    addFAQViewController *addFAQView =[self.storyboard instantiateViewControllerWithIdentifier:@"addFAQView"];
    addFAQView.recieveObjectID = objectID;
    
    [addFAQView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController:addFAQView animated:YES];
}

- (IBAction)editDetail:(id)sender {
    // ดึง barCodeID,latitude,longitude จาก NSUserDefault
    newBarcodeID = [[NSUserDefaults standardUserDefaults] stringForKey:@"barCodeID"];
    newLatitude = [[NSUserDefaults standardUserDefaults] stringForKey:@"latitude"];
    newLongitude = [[NSUserDefaults standardUserDefaults] stringForKey:@"longitude"];
    
    // ลบ barCodeID,latitude,longitude จาก NSUserDefault
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"barCodeID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"objectName"];

    NSString *postEdit;
    NSURL *urlEdit;
    BOOL errorEdit;
    if (newBarcodeID != NULL){ // แก้ barcode
        postEdit = [NSMutableString stringWithFormat:@"objectID=%@&barcodeID=%@",objectID,newBarcodeID];
        urlEdit = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/editObjectBarcode.php"];
        errorEdit = [sendBox post:postEdit toUrl:urlEdit];
    }
    if(newLatitude != NULL && newLongitude != NULL){ // แก้ GPS
        postEdit = [NSMutableString stringWithFormat:@"objectID=%@&latitude=%@&longitude=%@",objectID,newLatitude,newLongitude];
        urlEdit = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/editObjectGPS.php"];
        errorEdit = [sendBox post:postEdit toUrl:urlEdit];
    }
    if(![objectName isEqualToString:nameDetail.text]){ // แก้ชื่อ
        postEdit = [NSMutableString stringWithFormat:@"objectID=%@&objectName=%@",objectID,nameDetail.text];
        urlEdit = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/editObjectName.php"];
        errorEdit = [sendBox post:postEdit toUrl:urlEdit];
    }
    
    if (!errorEdit) {
        UIAlertView *returnMessage = [[UIAlertView alloc]
                                      initWithTitle:@"แก้ไขรายละเอียดวัตถุเรียบร้อย"
                                      message:nil delegate:self
                                      cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [returnMessage show];
        [self viewWillAppear:YES];
    }else{
        [sendBox getErrorMessage];
    }
}

- (IBAction)goToResponView:(id)sender {
    // ไปหน้า Respon (รายชื่อผู้ดูแล)
    ResponViewController *responView =[self.storyboard instantiateViewControllerWithIdentifier:@"responView"];
    responView.recieveObjectID = objectID;
    
    [responView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController:responView animated:YES];
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)err usingContextInfo:(void*)ctxInfo {
    if (err) {
        UIAlertView *saveQrAlert = [[UIAlertView alloc]
                                    initWithTitle:@"จัดเก็บ QR Code ไม่สำเร็จ!!!"
                                    message:nil delegate:self
                                    cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [saveQrAlert show];
    } else {
        UIAlertView *saveQrAlert = [[UIAlertView alloc]
                                    initWithTitle:@"จัดเก็บ QR Code เรียบร้อย"
                                    message:nil delegate:self
                                    cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [saveQrAlert show];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myObject count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"faqCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle : UITableViewCellStyleDefault
                                      reuseIdentifier : CellIdentifier];
    }
    
    // ถ้าเป็นผู้ดูแลสามารถเลือก cell ได้
    if (flagResponder) {
        cell.userInteractionEnabled = YES;
    }else{
        cell.userInteractionEnabled = NO;
    }
    
    // คำถาม - คำตอบ
    cell.textLabel.text = [[myObject objectAtIndex:indexPath.row] objectForKey:@"question"];
    cell.detailTextLabel.text = [[myObject objectAtIndex:indexPath.row] objectForKey:@"answer"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ไปหน้า แก้ไข FAQ
    EditFAQViewController *editFAQView =[self.storyboard instantiateViewControllerWithIdentifier:@"editFAQView"];
    
    editFAQView.recieveFaqID = [[myObject objectAtIndex:indexPath.row] objectForKey:@"faqID"];
    
    [editFAQView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController:editFAQView animated:YES];
}

@end

