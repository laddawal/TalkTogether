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
}
@end

@implementation NameContactViewController

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
    
    // Create array to hold dictionaries
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
    
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle : UITableViewCellStyleDefault
                                       reuseIdentifier : CellIdentifier];
    }
    
    // ObjectName
    cell.textLabel.text = [[myObject objectAtIndex:indexPath.row] objectForKey:@"objectName"];
    return cell;
}

//-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    if([searchText length] == 0)
//    {
//        [displayObject removeAllObjects];
//        [displayObject addObjectsFromArray:allObject];
//    }
//    else
//    {
//        [displayObject removeAllObjects];
//        for(NSString * string in allObject)
//        {
//            NSRange r = [string rangeOfString:searchText options:NSCaseInsensitiveSearch];
//            if(r.location != NSNotFound)
//            {
//                [displayObject addObject:string];
//            }
//        }
//    }
//    
//    [_showObject reloadData];
//}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    // clear วัตถุที่ค้นหาครั้งที่แล้วออก
	[myObject removeAllObjects];
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder]; // hide keyboard เมื่อกด search
    _showObject.allowsSelection = YES;
    _showObject.scrollEnabled = YES;
    
    NSLog(@"Keyword : %@",[searchBar text]);
    
    //ส่ง Keyword ให้ php
    
    NSString *post = [NSString stringWithFormat:@"keyword=%@",[searchBar text]];
    
    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/searchObject.php"];
    
    NSMutableArray * jsonReturn = [sendBox post:post toUrl:url];
    
    if (jsonReturn != nil) {
        for (NSDictionary* fetchDict in jsonReturn){
            [myObject addObject:fetchDict];
        }
        NSLog(@"%@",myObject);
    }else{
        [sendBox getErrorMessage];
    }
    
    [_showObject reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    _showObject.allowsSelection = NO;
    _showObject.scrollEnabled = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    _showObject.allowsSelection = YES;
    _showObject.scrollEnabled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
//    [_searchBar becomeFirstResponder];
    
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
    
    // ไปหน้า chat
    ChatViewController *chatView =[self.storyboard instantiateViewControllerWithIdentifier:@"chatView"];
    
    chatView.recieveObjectID = [[myObject objectAtIndex:indexPath.row] objectForKey:@"objectID"];
    chatView.recieveUserID = userID;
    chatView.recieveSender = @"1"; // กำหนดให้ผู้ส่งคือผู้ใช้
    chatView.navigationItem.title = [[myObject objectAtIndex:indexPath.row] objectForKey:@"objectName"];
    
    [chatView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController:chatView animated:YES];
}

@end
