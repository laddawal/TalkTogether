//
//  addResponderViewController.m
//  TalkTogether
//
//  Created by PloyZb on 12/26/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "addResponderViewController.h"

@interface addResponderViewController ()
{
//    NSString *userID;
    NSMutableArray *myObject;
    NSMutableArray *selectedUserID;
    NSString *objectID;
    
    NSString *post;
    NSURL *url;
    BOOL error;
}
@end

@implementation addResponderViewController
//@synthesize recieveUserID;
@synthesize myTable;
@synthesize recieveObjectID;

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
    
//    // รับ userID
//    userID = [recieveUserID description];
//    NSLog(@"userID : %@",userID);
    
    // รับ objectID
    objectID = [recieveObjectID description];
}

- (void)viewWillAppear:(BOOL)animated {
    
    sendBox = [[postMessage alloc]init];
    
    // Create array to hold dictionaries
    myObject = [[NSMutableArray alloc] init];
    selectedUserID = [[NSMutableArray alloc] init];
    
    //ส่ง objectID ให้ php เพื่อเอาคำร้องขอเป็นผู้ดูแล
    post = [NSString stringWithFormat:@"objectID=%@",objectID];
    url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/getRequest.php"];
    error = [sendBox post:post toUrl:url];
    
    if (!error) {
        int returnNum = [sendBox getReturnMessage];
        if (returnNum == 0) {
            NSMutableArray *jsonReturn = [sendBox getData];
            for (NSDictionary* fetchDict in jsonReturn){
                [myObject addObject:fetchDict];
            }
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
    [myTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myObject count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"addResponderCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle : UITableViewCellStyleDefault
                                      reuseIdentifier : CellIdentifier];
    }
    
    // ObjectName
    cell.textLabel.text = [[myObject objectAtIndex:indexPath.row] objectForKey:@"userName"];
    
    // Check Mark
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [selectedUserID removeObject:[[myObject objectAtIndex:indexPath.row] objectForKey:@"userID"]];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [selectedUserID addObject:[[myObject objectAtIndex:indexPath.row] objectForKey:@"userID"]];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        // ลบวัตถุใน database
//        // ส่ง objectID ให้ php
//        NSString *post = [NSString stringWithFormat:@"objectID=%@",[[displayObject objectAtIndex:indexPath.row] objectForKey:@"objectID"]];
//        NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/deleteObject.php"];
//        BOOL error = [sendBox post:post toUrl:url];
//        
//        if (!error) {
//            UIAlertView *returnMessage = [[UIAlertView alloc]
//                                          initWithTitle:@"สำเร็จ!!"
//                                          message:nil delegate:self
//                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [returnMessage show];
//            [showObj reloadData];
//            
//            // ลบวัตถุใน table
//            [displayObject removeObjectAtIndex:indexPath.row];
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        }else{
//            [sendBox getErrorMessage];
//        }
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitRequest:(id)sender {
    for (int i = 0; i <= [selectedUserID count]; i++) {
        post = [NSString stringWithFormat:@"objectID=%@&userID=%@",objectID,selectedUserID[i]];
        url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/confirmRequest.php"];
        error = [sendBox post:post toUrl:url];
        
//        if (!error) {
//            
//        }else{
//            [sendBox getErrorMessage];
//        }
    }
}
@end
