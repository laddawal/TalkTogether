//
//  EverChatViewController.m
//  TalkTogether
//
//  Created by PloyZb on 12/20/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "EverChatViewController.h"
#import "ChatViewController.h"

@interface EverChatViewController ()
{
    NSString *userID;
    NSMutableArray *myObject;
    NSMutableArray *displayObject;
}
@end

@implementation EverChatViewController
@synthesize recieveUserID;
@synthesize myTable;

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
}

- (void) viewWillAppear:(BOOL)animated
{
    sendBox = [[postMessage alloc]init];
    
    // Create array to hold dictionaries
    myObject = [[NSMutableArray alloc] init];
    
    // ดึง userID จาก NSUserDefault
    NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
    userID = [defaultUserID stringForKey:@"userID"];
    
    // ส่ง userID ให้ php
    NSString *post = [NSString stringWithFormat:@"userID=%@",userID];
    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/getChatHistory"];
    BOOL error = [sendBox post:post toUrl:url];
    
    if (!error) {
        int returnNum = [sendBox getReturnMessage];
        if (returnNum == 0) {
            NSMutableArray *jsonReturn = [sendBox getData];
            for (NSDictionary* fetchDict in jsonReturn){
                [myObject addObject:fetchDict];
            }
            displayObject =[[NSMutableArray alloc] initWithArray:myObject];
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
    return [displayObject count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"everChatCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // selected cell color
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithRed:134.0/255.0 green:114.0/255.0 blue:93.0/255.0 alpha:1.0]];
    [cell setSelectedBackgroundView:bgColorView];
    
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle : UITableViewCellStyleDefault
                                      reuseIdentifier : CellIdentifier];
    }
    
    NSDictionary *tmpDict = [displayObject objectAtIndex:indexPath.row];
    
    // ObjectName
    NSString *text;
    text = [NSString stringWithFormat:@"%@",[tmpDict objectForKey:@"objectName"]];
    
    cell.textLabel.text = text;
    if ([[[displayObject objectAtIndex:indexPath.row] objectForKey:@"responder_ID"] isEqualToString:userID]) {
        cell.detailTextLabel.text = @"วัตถุ -> ผู้ใช้";
        // รูปด้านซ้าย
        cell.imageView.image = [UIImage imageNamed:@"woman.png"];
        // รูปด้านขวา
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"woman.png"]];
        [cell.accessoryView setFrame:CGRectMake(0, 0, 42, 42)];
    }else{
        cell.detailTextLabel.text = @"ผู้ใช้ -> วัตถุ";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ไปหน้า chat
    ChatViewController *chatView =[self.storyboard instantiateViewControllerWithIdentifier:@"chatView"];
    
    chatView.recieveObjectID = [[displayObject objectAtIndex:indexPath.row] objectForKey:@"object_ID"];
    if ([[[displayObject objectAtIndex:indexPath.row] objectForKey:@"responder_ID"] isEqualToString:userID]) {
        chatView.recieveSender = @"2"; // กำหนดให้ผู้ส่งคือวัตถุ
        chatView.recieveResponderID = userID;
        chatView.recieveContactID = [[displayObject objectAtIndex:indexPath.row] objectForKey:@"contact_ID"];
    }else{
        chatView.recieveSender = @"1"; // กำหนดให้ผู้ส่งคือผู้ใช้
        chatView.recieveResponderID = [[displayObject objectAtIndex:indexPath.row] objectForKey:@"responder_ID"];
        chatView.recieveContactID = userID;
    }
    chatView.navigationItem.title = [[displayObject objectAtIndex:indexPath.row] objectForKey:@"objectName"];
    
    [chatView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController:chatView animated:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText length] == 0)
    {
        [displayObject removeAllObjects];
        [displayObject addObjectsFromArray:myObject];
    }
    else{
        [displayObject removeAllObjects];
        for (NSDictionary *item in myObject) {
            NSString *string = [item objectForKey:@"objectName"];
            NSRange range = [string rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (range.location !=  NSNotFound) {
                [displayObject addObject:item];
            }
        }
    }
    [myTable reloadData];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    myTable.allowsSelection = YES;
    myTable.scrollEnabled = YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    // tableViewObj.allowsSelection = NO;
    myTable.scrollEnabled = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    myTable.allowsSelection = YES;
    myTable.scrollEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
