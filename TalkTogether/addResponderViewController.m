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
    NSMutableArray *displayObject;
    NSString *objectID;
    NSString *selectedUserID;
    
    NSString *post;
    NSURL *url;
    BOOL error;
}
@end

@implementation addResponderViewController
//@synthesize recieveUserID;
@synthesize myTable;
@synthesize searchResponder;
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
    
    //ส่ง objectID ให้ php เพื่อเอารายละเอียดวัตถุ
    post = [NSString stringWithFormat:@"objectID=%@",objectID];
    url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/getUserAddResponder.php"];
    error = [sendBox post:post toUrl:url];
    
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
    static NSString *CellIdentifier = @"addResponderCell";
    
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
    
    // ObjectName
    cell.textLabel.text = [[displayObject objectAtIndex:indexPath.row] objectForKey:@"userName"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedUserID = [[displayObject objectAtIndex:indexPath.row] objectForKey:@"userID"];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"หน้าที่"
                                                       delegate:self
                                              cancelButtonTitle:@"ยกเลิก"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"เจ้าของ", @"ผู้ดูแล", nil];
    // Show the sheet
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
            // กำหนดให้ ผู้ที่ถูกเลือก เป็นเจ้าของ
            post = [NSString stringWithFormat:@"userID=%@&objectID=%@&permission=1",selectedUserID,objectID];
            
            url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/insertPermission.php"];
            
            error = [sendBox post:post toUrl:url];
            
            if (!error) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [sendBox getErrorMessage];
            }
        }
            break;
        case 1:{
            // กำหนดให้ ผู้ที่ถูกเลือก เป็นผู้ดูแล
            post = [NSString stringWithFormat:@"userID=%@&objectID=%@&permission=2",selectedUserID,objectID];
            
            url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/insertPermission.php"];
            
            error = [sendBox post:post toUrl:url];
            
            if (!error) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [sendBox getErrorMessage];
            }
        }
            break;
    }
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
            NSString *string = [item objectForKey:@"userName"];
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
