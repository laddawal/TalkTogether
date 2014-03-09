//
//  NameContactViewController.m
//  TalkTogether
//
//  Created by PloyZb on 11/5/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "NameContactViewController.h"
#import "ChatViewController.h"

@interface NameContactViewController ()
{
    NSMutableArray *allObject;
    NSMutableArray *displayObject;
    NSMutableArray *myObject;
    
    NSString *userID;
    NSString *responderID;
}
@end

@implementation NameContactViewController
@synthesize showObject;

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
    
    myObject = [[NSMutableArray alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myObject count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"nameContactCell";
    
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

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    // clear วัตถุที่ค้นหาครั้งที่แล้วออก
	[myObject removeAllObjects];
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder]; // hide keyboard เมื่อกด search
    showObject.allowsSelection = YES;
    showObject.scrollEnabled = YES;
    
    //ส่ง Keyword ให้ php
    
    NSString *post = [NSString stringWithFormat:@"keyword=%@",[searchBar text]];
    
    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/searchObject.php"];
    
    BOOL error = [sendBox post:post toUrl:url];
    
    if (!error) {
        int returnNum = [sendBox getReturnMessage];
        if (returnNum == 0) {
            NSMutableArray *jsonReturn = [sendBox getData];
            for (NSDictionary* fetchDict in jsonReturn){
                [myObject addObject:fetchDict];
            }
            displayObject =[[NSMutableArray alloc] initWithArray:myObject];
            [showObject reloadData];
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

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    showObject.allowsSelection = NO;
    showObject.scrollEnabled = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    showObject.allowsSelection = YES;
    showObject.scrollEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [showObject reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
