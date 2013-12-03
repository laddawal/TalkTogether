//
//  MyObjectViewController.m
//  TalkTogether
//
//  Created by PloyZb on 12/1/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "MyObjectViewController.h"
#import "ObjectChatViewController.h"

@interface  MyObjectViewController()

@end

@implementation MyObjectViewController
{
    NSMutableArray *myObject;
    
    NSString *userID;
}

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
    
    // ดึง userID จาก NSUserDefault
    NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
    userID = [defaultUserID stringForKey:@"userID"];
    
    // ส่ง userID ให้ php
    
    NSString *post = [NSString stringWithFormat:@"userID=%@",userID];
    
    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/getUserObject.php"];
    
    NSMutableArray * jsonReturn = [sendBox post:post toUrl:url];
    
    if (jsonReturn != nil) {
        for (NSDictionary* fetchDict in jsonReturn){
            [myObject addObject:fetchDict];
        }
        [_showObj reloadData];
    }else{
        [sendBox getErrorMessage];
    }
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
    
    static NSString *CellIdentifier = @"myObjectCell";
    
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
        text = [NSString stringWithFormat:@"objectName : %@",[tmpDict objectForKey:@"objectName"]];
        cell.textLabel.text = text;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDict = [myObject objectAtIndex:indexPath.row];
    
    // ไปหน้า objectChat
    ObjectChatViewController *objectChatView =[self.storyboard instantiateViewControllerWithIdentifier:@"objectChatView"];
    
    objectChatView.detailItem = [tmpDict objectForKey:@"objectID"];
    
    [objectChatView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController:objectChatView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
