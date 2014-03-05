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
    
    // selected cell background color
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitRequest:(id)sender {
    if ([selectedUserID count] != 0) {
        for (int i = 0; i < [selectedUserID count]; i++) {
            post = [NSString stringWithFormat:@"objectID=%@&userID=%@",objectID,[selectedUserID objectAtIndex:i]];
            url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/confirmRequest.php"];
            [sendBox post:post toUrl:url];
            
            NSLog(@"%@",[selectedUserID objectAtIndex:i]);
        }
        
        if (!error) {
            UIAlertView *submitRequestAlert = [[UIAlertView alloc]
                                               initWithTitle:@"อนุมัติคำขอเรียบร้อย"
                                               message:nil delegate:self
                                               cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [submitRequestAlert show];
            [self viewWillAppear:YES];
        }else{
            [sendBox getErrorMessage];
        }
    }else{
        UIAlertView *cantSubmit = [[UIAlertView alloc]
                                           initWithTitle:@"กรุณาเลือกคำขอที่ต้องการอนุมัติ"
                                           message:nil delegate:self
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [cantSubmit show];
    }
    
}

- (IBAction)deleteRequest:(id)sender {
    if ([selectedUserID count] != 0) {
        for (int i = 0; i < [selectedUserID count]; i++) {
            post = [NSString stringWithFormat:@"objectID=%@&userID=%@",objectID,[selectedUserID objectAtIndex:i]];
            url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/deleteRequest.php"];
            [sendBox post:post toUrl:url];
        }
        
        if (!error) {
            UIAlertView *deleteRequestAlert = [[UIAlertView alloc]
                                               initWithTitle:@"ลบคำขอเรียบร้อย"
                                               message:nil delegate:self
                                               cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [deleteRequestAlert show];
            [self viewWillAppear:YES];
        }else{
            [sendBox getErrorMessage];
        }
    }else{
        UIAlertView *cantDelete = [[UIAlertView alloc]
                                   initWithTitle:@"กรุณาเลือกคำขอที่ต้องการลบ"
                                   message:nil delegate:self
                                   cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [cantDelete show];
    }
    
}
@end
