//
//  ResponViewController.m
//  TalkTogether
//
//  Created by PloyZb on 12/10/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "ResponViewController.h"
#import "EditResponderViewController.h"
#import "addResponderViewController.h"

@interface ResponViewController ()
{
//    NSMutableArray *listOfItems;
    NSMutableArray *myObject;
    
    NSString *objectID;
    NSString *responderID;
}
@end

@implementation ResponViewController
@synthesize recieveObjectID;
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
    
    // รับ objectID จาหหน้ารายละเอียด
    objectID = [recieveObjectID description];
    
//    // Section Group 1
//    NSArray *arrGroup1 = [NSArray arrayWithObjects:@"Item 1", @"Item 2", @"Item 3", @"Item 4", nil];
//    NSDictionary *dictGroup1 = [NSDictionary dictionaryWithObject:arrGroup1 forKey:@"GroupItem"];
//    
//    // Section Group 2
//    NSArray *arrGroup2 = [NSArray arrayWithObjects:@"Item 5", @"Item 6", @"Item 7", @"Item 8", nil];
//    NSDictionary *dictGroup2 = [NSDictionary dictionaryWithObject:arrGroup2 forKey:@"GroupItem"];
//    
//    [listOfItems addObject:dictGroup1];
//    [listOfItems addObject:dictGroup2];
}

- (void)viewWillAppear:(BOOL)animated {
    
    sendBox = [[postMessage alloc]init];
    
    //    listOfItems = [[NSMutableArray alloc] init];
    
    // Create array to hold dictionaries
    myObject = [[NSMutableArray alloc] init];
    
    //ส่ง objectID ให้ php เพื่อเอารายชื่อผู้ดูแลและเจ้าของ
    NSString *post = [NSString stringWithFormat:@"objectID=%@",objectID];
    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/getResponder.php"];
    BOOL error = [sendBox post:post toUrl:url];
    
    if (!error) {
        int returnNum = [sendBox getReturnMessage];
        if (returnNum == 0) {
            NSMutableArray *jsonReturn = [sendBox getData];
            for (NSDictionary* fetchDict in jsonReturn){
                [myObject addObject:fetchDict];
            }
        }
    }else{
        [sendBox getErrorMessage];
    }
    [myTable reloadData];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    
//    return [listOfItems count];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    NSDictionary *dictionary = [listOfItems objectAtIndex:section];
//    NSArray *array = [dictionary objectForKey:@"GroupItem"];
//    return [array count];
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    if(section == 0)
//        return @"เจ้าของ";
//    else
//        return @"ผู้ดูแล";
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myObject count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    static NSString *CellIdentifier = @"responCell";
//    
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        // Use the default cell style.
//        cell = [[UITableViewCell alloc] initWithStyle : UITableViewCellStyleSubtitle
//                                       reuseIdentifier : CellIdentifier];
//    }
//    
//    NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
//    NSArray *array = [dictionary objectForKey:@"GroupItem"];
//    NSString *cellValue = [array objectAtIndex:indexPath.row];
//    cell.textLabel.text = cellValue;
//    
//    return cell;
    
    static NSString *CellIdentifier = @"responCell";
    
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
    cell.textLabel.text = [[myObject objectAtIndex:indexPath.row] objectForKey:@"userName"];
    if ([[[myObject objectAtIndex:indexPath.row] objectForKey:@"permission"] isEqualToString:@"1"]) {
        cell.detailTextLabel.text = @"เจ้าของ";
    }else{
        cell.detailTextLabel.text = @"ผู้ดูแล";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ไปหน้า editResponder
    EditResponderViewController *editRespobderView =[self.storyboard instantiateViewControllerWithIdentifier:@"editRespobderView"];
    
    editRespobderView.recieveUserID = [[myObject objectAtIndex:indexPath.row] objectForKey:@"userID"];
    editRespobderView.recievePermission = [[myObject objectAtIndex:indexPath.row] objectForKey:@"permission"];
    editRespobderView.recieveObjectID = objectID;
    editRespobderView.recieveResponderName = [[myObject objectAtIndex:indexPath.row] objectForKey:@"userName"];
    
    [editRespobderView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController:editRespobderView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addResponder:(id)sender {
//    // ดึง userID จาก NSUserDefault
//    NSUserDefaults *defaultUserID = [NSUserDefaults standardUserDefaults];
//    NSString *userID = [defaultUserID stringForKey:@"userID"];
    
    // ไปหน้า addResponder
    addResponderViewController *addRespobderView =[self.storyboard instantiateViewControllerWithIdentifier:@"addRespobderView"];
    
    addRespobderView.recieveObjectID = objectID;
//    addRespobderView.recieveUserID = userID;
    
    [addRespobderView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController:addRespobderView animated:YES];
}
@end
