//
//  ObjectChatViewController.m
//  TalkTogether
//
//  Created by PloyZb on 12/1/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "ObjectChatViewController.h"
#import "ChatViewController.h"
#import "EditObjectViewController.h"

@interface ObjectChatViewController ()

@end

@implementation ObjectChatViewController
{
    NSString *objectID;
    NSMutableArray *myObject;
}
@synthesize detailItem;
@synthesize showUser;

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
    
    // รับ objectID จาหหน้าก่อนหน้า
    objectID = [detailItem description];
    NSLog(@"objectIDObjectChat : %@",objectID);
    
    // ส่ง objectID ให้ php
    NSString *post = [NSString stringWithFormat:@"objectID=%@",objectID];
    
    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/getUserChatWithObject.php"];
    
    NSMutableArray * jsonReturn = [sendBox post:post toUrl:url];
    
    if (jsonReturn != nil) {
        for (NSDictionary* fetchDict in jsonReturn){
            [myObject addObject:fetchDict];
        }
        [showUser reloadData];
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
    
    static NSString *CellIdentifier = @"objectChatCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle : UITableViewCellStyleSubtitle
                                      reuseIdentifier : CellIdentifier];
    }
    
    int nbCount = [myObject count];
    if (nbCount == 0)
        cell.textLabel.text = @"";
    else
    {
        NSDictionary *tmpDict = [myObject objectAtIndex:indexPath.row];
        
        // userName
        
        NSString *text = [NSString stringWithFormat:@"%@",[tmpDict objectForKey:@"userName"]];
        cell.textLabel.text = text;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDict = [myObject objectAtIndex:indexPath.row];
    
    // ไปหน้า chat
    ChatViewController *chatView =[self.storyboard instantiateViewControllerWithIdentifier:@"chatView"];
    
    chatView.recieveUserID = [tmpDict objectForKey:@"userID"];
    chatView.recieveObjectID = objectID;
    chatView.recieveSender = @"2"; // กำหนดให้ผู้ส่งคือวัตถุ
    
    [chatView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController:chatView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editObject:(id)sender {
    // ไปหน้า editObject
    EditObjectViewController *editObjectView =[self.storyboard instantiateViewControllerWithIdentifier:@"editObjectView"];
    
    editObjectView.recieveObjectID = objectID;
//    editObjectView.recieveSender = @"2"; // กำหนดให้ผู้ส่งคือวัตถุ
    
    [editObjectView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController:editObjectView animated:YES];

}
@end
