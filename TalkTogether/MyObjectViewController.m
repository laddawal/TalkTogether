//
//  MyObjectViewController.m
//  TalkTogether
//
//  Created by PloyZb on 12/1/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "MyObjectViewController.h"
#import "DetailObjectViewController.h"

@interface  MyObjectViewController()
{
    NSMutableArray *myObject;
    
    NSString *userID;
    
    NSMutableArray *displayObject;
}
@end

@implementation MyObjectViewController
@synthesize showObj;

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

- (void)viewWillAppear:(BOOL)animated {
    sendBox = [[postMessage alloc]init];

    myObject = [[NSMutableArray alloc] init];
    
    // ดึง userID จาก NSUserDefault
    NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
    userID = [defaultUserID stringForKey:@"userID"];
    
    // ส่ง userID ให้ php
    NSString *post = [NSString stringWithFormat:@"userID=%@",userID];
    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/getUserObject.php"];
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
    [showObj reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [displayObject count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"myObjectCell";
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
    cell.textLabel.text = [[displayObject objectAtIndex:indexPath.row] objectForKey:@"objectName"];
    
    // ObjectImg
    if ([[NSString stringWithFormat:@"%@",[[displayObject objectAtIndex:indexPath.row] objectForKey:@"image"]] isEqualToString:@"1"]) { // มี Object Image
        NSString *part = [NSString stringWithFormat:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/objectImage/%@.jpg",[[displayObject objectAtIndex:indexPath.row] objectForKey:@"objectID"]];
        NSURL *url = [NSURL URLWithString:part];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        
        cell.imageView.image = img;
    }else{ // ไม่มี Object Image
        cell.imageView.image = [UIImage imageNamed:@"noImage.png"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ไปหน้า detail
    DetailObjectViewController *detailView =[self.storyboard instantiateViewControllerWithIdentifier:@"detailView"];
    
    detailView.recieveObjectID = [[displayObject objectAtIndex:indexPath.row] objectForKey:@"objectID"];
    
    [detailView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController:detailView animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // ลบวัตถุใน database
        // ส่ง objectID ให้ php  
        NSString *post = [NSString stringWithFormat:@"objectID=%@",[[displayObject objectAtIndex:indexPath.row] objectForKey:@"objectID"]];
        NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/deleteObject.php"];
        BOOL error = [sendBox post:post toUrl:url];
        
        if (!error) {
            UIAlertView *returnMessage = [[UIAlertView alloc]
                                          initWithTitle:@"สำเร็จ!!"
                                          message:nil delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [returnMessage show];
            [self viewWillAppear:YES];
        }else{
            [sendBox getErrorMessage];
        }
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
            NSString *stringObj = [item objectForKey:@"objectName"];
            NSRange rangeObj = [stringObj rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (rangeObj.location !=  NSNotFound) {
                [displayObject addObject:item];
            }
        }
    }
    [showObj reloadData];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    showObj.allowsSelection = YES;
    showObj.scrollEnabled = YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    showObj.scrollEnabled = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    showObj.allowsSelection = YES;
    showObj.scrollEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
