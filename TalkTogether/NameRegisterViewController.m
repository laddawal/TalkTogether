//
//  NameRegisterViewController.m
//  TalkTogether
//
//  Created by PloyZb on 11/12/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "NameRegisterViewController.h"

@interface NameRegisterViewController ()
{
    NSString *userID;
    NSString *objectID;
}
@end

@implementation NameRegisterViewController
@synthesize objectName;
@synthesize imgView;

UIImage *pickedImage;

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
    
    [objectName setDelegate:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)getPhoto:(id)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:picker animated:YES completion:Nil];
}

-(UIImage*)imageWithImage:(UIImage*)pickedImage scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [pickedImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:Nil];
    
    pickedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    CGSize newSize;
    newSize.width = 200;
    newSize.height = 200;
    pickedImage = [self imageWithImage:pickedImage scaledToSize:newSize];
    
    imgView.image = pickedImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nameRegisterBtn:(id)sender {
    
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
        NSMutableString *post = [NSMutableString stringWithFormat:@"objectName=%@&userID=%@",[objectName text],userID];
        NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/insertObjectName.php"];
        BOOL error = [sendBox post:post toUrl:url];
        
        if (!error) {
            if (imgView.image != NULL) { // save objectImg ลง database
                int returnNum = [sendBox getReturnMessage];
                if (returnNum == 0) {
                    NSMutableArray *jsonReturn = [sendBox getData];
                    for (NSDictionary *dataDict in jsonReturn) {
                        objectID = [NSString stringWithFormat:@"%@",dataDict];
                    }
                    NSData *imageData = UIImageJPEGRepresentation(imgView.image, 100);
                    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/saveObjectImg.php"];
                    
                    error = [sendBox postImage:imageData withObjectID:objectID toUrl:url];
                    if (!error) { // save objectImg สำเร็จ
                        UIAlertView *returnMessage = [[UIAlertView alloc]
                                                      initWithTitle:@"สำเร็จ!!"
                                                      message:nil delegate:self
                                                      cancelButtonTitle:nil otherButtonTitles:nil];
                        [returnMessage show];
                        [returnMessage dismissWithClickedButtonIndex:0 animated:YES];
                        
                        // clear TextField
                        objectName.text = NULL;
                        imgView.image = NULL;
                        
                        [self.navigationController popViewControllerAnimated:YES]; // กลับหน้าลงทะเบียน
                    }else{ // save objectImg ไม่สำเร็จ
                        [sendBox getErrorMessage];
                    }
                }
            }else{
                UIAlertView *returnMessage = [[UIAlertView alloc]
                                              initWithTitle:@"สำเร็จ!!"
                                              message:nil delegate:self
                                              cancelButtonTitle:nil otherButtonTitles:nil];
                [returnMessage show];
                [returnMessage dismissWithClickedButtonIndex:0 animated:YES];
                
                // clear TextField
                objectName.text = NULL;
                imgView.image = NULL;
                
                [self.navigationController popViewControllerAnimated:YES]; // กลับหน้าลงทะเบียน
            }
        }else{
            [sendBox getErrorMessage];
        }
    }
}

@end