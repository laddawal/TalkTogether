//
//  ResponViewController.m
//  TalkTogether
//
//  Created by PloyZb on 12/10/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "ResponViewController.h"
#import "addResponderViewController.h"

@interface ResponViewController ()
{
    NSMutableArray *selectedUserID;
    NSMutableArray *myObject;
    
    NSString *objectID;
    NSString *responderID;
    
    NSString *post;
    NSURL *url;
    BOOL error;
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
}

- (void)viewWillAppear:(BOOL)animated {
    
    sendBox = [[postMessage alloc]init];
    
    myObject = [[NSMutableArray alloc] init];
    selectedUserID = [[NSMutableArray alloc] init];
    
    //ส่ง objectID ให้ php เพื่อเอารายชื่อผู้ดูแลและเจ้าของ
    post = [NSString stringWithFormat:@"objectID=%@",objectID];
    url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/getResponder.php"];
    error = [sendBox post:post toUrl:url];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myObject count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"responCell";
    
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
    cell.textLabel.text = [[myObject objectAtIndex:indexPath.row] objectForKey:@"userName"];

    // Check Mark
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [selectedUserID removeObject:[[myObject objectAtIndex:indexPath.row] objectForKey:@"userID"]];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [selectedUserID addObject:[[myObject objectAtIndex:indexPath.row] objectForKey:@"userID"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addResponder:(id)sender {
    
    // ไปหน้า addResponder
    addResponderViewController *addRespobderView =[self.storyboard instantiateViewControllerWithIdentifier:@"addRespobderView"];
    
    addRespobderView.recieveObjectID = objectID;
    
    [addRespobderView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController:addRespobderView animated:YES];
}

- (IBAction)deleteResponder:(id)sender {
    if ([selectedUserID count] == [myObject count]) { // ลบไม่ได้ วัตถุต้องมีผู้ดูแลอย่างน้อย 1 คน
        UIAlertView *cantDelete = [[UIAlertView alloc]
                                           initWithTitle:@"วัตถุต้องมีผู้ดูแลอย่างน้อย 1 คน"
                                           message:nil delegate:self
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [cantDelete show];
    }else if([selectedUserID count] == 0){
        UIAlertView *cantDelete = [[UIAlertView alloc]
                                   initWithTitle:@"กรุณาเลือกผู้ดูแลที่ต้องการลบ"
                                   message:nil delegate:self
                                   cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [cantDelete show];
    }else{ // ลบได้
        for (int i = 0; i < [selectedUserID count]; i++) {
            post = [NSString stringWithFormat:@"objectID=%@&userID=%@",objectID,[selectedUserID objectAtIndex:i]];
            url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/deleteResponder.php"];
            [sendBox post:post toUrl:url];
        }
        
        if (!error) {
            UIAlertView *deleteResponderAlert = [[UIAlertView alloc]
                                                 initWithTitle:@"ลบผู้ดูแลเรียบร้อย"
                                                 message:nil delegate:self
                                                 cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [deleteResponderAlert show];
            [self viewWillAppear:YES];
        }else{
            [sendBox getErrorMessage];
        }
    }
}
@end
