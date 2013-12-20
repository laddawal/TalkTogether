//
//  EverChatViewController.m
//  TalkTogether
//
//  Created by PloyZb on 12/20/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "EverChatViewController.h"

@interface EverChatViewController ()
{
    NSString *userID;
    NSMutableArray *myObject;
}
@end

@implementation EverChatViewController
@synthesize recieveUserID;

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
    
    // รับ userID จากหน้า mainMenu
    userID = [recieveUserID description];
    
//    NSLog(@"EverChatUserID : %@",userID);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myObject count];
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
    
    NSDictionary *tmpDict = [myObject objectAtIndex:indexPath.row];
    
    // ObjectName
    NSString *text;
    text = [NSString stringWithFormat:@"%@",[tmpDict objectForKey:@"objectName"]];
    
    cell.textLabel.text = text;
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
