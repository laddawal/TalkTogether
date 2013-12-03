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

// สลับสี Cell Background
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%2 == 0) {
        UIColor *altCellColor = [UIColor colorWithWhite:0.7 alpha:0.5];
        cell.backgroundColor = altCellColor;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int nbCount = [myObject count];
    if (nbCount == 0)
        return 1;
    else
        return [myObject count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"nameContactCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle : UITableViewCellStyleSubtitle
                                       reuseIdentifier : CellIdentifier];
    }
    
    int nbCount = [myObject count];
    if (nbCount ==0)
        cell.textLabel.text = @"";
    else
    {
        NSDictionary *tmpDict = [myObject objectAtIndex:indexPath.row];
        
        // ObjectName
        NSString *text;
        text = [NSString stringWithFormat:@"%@",[tmpDict objectForKey:@"objectName"]];
        
        cell.textLabel.text = text;
    }
    return cell;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText length] == 0)
    {
        [displayObject removeAllObjects];
        [displayObject addObjectsFromArray:allObject];
    }
    else
    {
        [displayObject removeAllObjects];
        for(NSString * string in allObject)
        {
            NSRange r = [string rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(r.location != NSNotFound)
            {
                [displayObject addObject:string];
            }
        }
    }
    
    [_showObject reloadData];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	
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
        [_showObject reloadData];
    }else{
        [sendBox getErrorMessage];
    }
    
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
    NSDictionary *tmpDict = [myObject objectAtIndex:indexPath.row];
    
    // ดึง userID จาก NSUserDefault
    NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
    userID = [defaultUserID stringForKey:@"userID"];
    
    // ไปหน้า chat
    ChatViewController *chatView =[self.storyboard instantiateViewControllerWithIdentifier:@"chatView"];
    
    chatView.recieveObjectID = [tmpDict objectForKey:@"objectID"];
    chatView.recieveUserID = userID;
    chatView.recieveSender = @"1"; // กำหนดให้ผู้ส่งคือผู้ใช้
    
    [chatView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController:chatView animated:YES];
}

//- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
//    return NO;
//}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"NameContactChat"]) {
//        
//        NSIndexPath *indexPath = [self.showObject indexPathForSelectedRow];
//        
//        NSDictionary *tmpDict = [myObject objectAtIndex:indexPath.row];
//        
//        NSString *objectID = [tmpDict objectForKey:@"objectID"];
//        
//        [[segue destinationViewController] setDetailItem:objectID];
//    }
//    
//}

@end
