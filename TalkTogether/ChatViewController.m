//
//  ChatViewController.m
//  TalkTogether
//
//  Created by PloyZb on 11/22/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "ChatViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "DetailObjectViewController.h"

@interface ChatViewController ()
{
    NSMutableArray *myObject;
    
    NSMutableArray *bubbleData;
    
    NSString *lastMessageID;
    NSString *objectID;
    NSString *userID;
    NSString *senderID;
    NSString *responderID;
    
    NSMutableString *post;
    NSURL *url;
    BOOL error;
    
    NSMutableArray *jsonReturn;
}
@end

@implementation ChatViewController
@synthesize myTable,message,textViewInput;
@synthesize recieveObjectID;
@synthesize recieveUserID;
@synthesize recieveSender;
@synthesize recieveResponderID;

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
    
    sendBox = [[postMessage alloc]init];
    
    // รับ objectID ,userID ,responderID และ sender จาหหน้าก่อนหน้า
    objectID = [recieveObjectID description];
    userID = [recieveUserID description];
    senderID = [recieveSender description];
    responderID = [recieveResponderID description];
    
    lastMessageID = [NSString stringWithFormat:@"0"];
	// Do any additional setup after loading the view, typically from a nib.
    
    bubbleData = [[NSMutableArray alloc] init];
    myTable.bubbleDataSource = self.myTable.bubbleDataSource;
    
    myTable.snapInterval = 60;
    
    myTable.showAvatars = YES;
    
    // Keyboard events
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    // กำหนดเวลา
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: 5
                                                      target: self
                                                    selector: @selector(updateMessage)
                                                    userInfo: nil
                                                     repeats: YES];
    [timer fire];
}

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = textViewInput.frame;
        frame.origin.y -= kbSize.height;
        textViewInput.frame = frame;
        
        frame = myTable.frame;
        frame.origin.y -= kbSize.height;
        myTable.frame = frame;
        
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = textViewInput.frame;
        frame.origin.y += kbSize.height;
        textViewInput.frame = frame;
        
        frame = myTable.frame;
        frame.origin.y += kbSize.height;
        myTable.frame = frame;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (IBAction)sendBtn:(id)sender {
    if (![message.text isEqualToString:@""]) { // ถ้า text field ว่าง จะไม่ส่งข้อมูล
        
        // ดึงข้อความจาก db ก่อนส่งข้อความใหม่ไป ป้องกันการส่งข้อความพร้อมกัน แล้วข้อความไม่ครบ
        //ส่ง ObjectID & UserID & lastMessageID ให้ php
        post = [NSMutableString stringWithFormat:@"objectID=%@&userID=%@&lastMessageID=%@",objectID,userID,lastMessageID];
        url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/getMessage.php"];
        error = [sendBox post:post toUrl:url];
        
        if (!error) {
            int returnNum = [sendBox getReturnMessage];
            if (returnNum == 0) {
                jsonReturn = [sendBox getData];
                for (NSDictionary *dataDict in jsonReturn) {
                    NSString *messageID = [dataDict objectForKey:@"messageID"];
                    NSString *strMessage = [dataDict objectForKey:@"message"];
                    NSString *sender = [dataDict objectForKey:@"sender"];
                    NSString *dateTime = [dataDict objectForKey:@"dateTime"];
                    lastMessageID = messageID;
                    
                    // แปลง เวลา จาก string เป็น date
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-M-d H:m:s"];
                    NSDate *date = [dateFormat dateFromString:dateTime];
                    
                    // ใส่ใน Table
                    if ([senderID isEqualToString:@"1"]) {
                        if ([sender isEqualToString:@"1"]) {
                            NSBubbleData *sayBubble = [NSBubbleData dataWithText:strMessage date:date type:BubbleTypeMine];
                            sayBubble.avatar = [UIImage imageNamed:@"user.png"]; // User Image
                            [bubbleData addObject:sayBubble];
                        }else{
                            NSBubbleData *sayBubble = [NSBubbleData dataWithText:strMessage date:date type:BubbleTypeSomeoneElse];
                            sayBubble.avatar = [UIImage imageNamed:@"car1.png"]; // Object Image
                            [bubbleData addObject:sayBubble];
                        }
                    }else{
                        if ([sender isEqualToString:@"2"]) {
                            NSBubbleData *sayBubble = [NSBubbleData dataWithText:strMessage date:date type:BubbleTypeMine];
                            sayBubble.avatar = [UIImage imageNamed:@"car1.png"]; // User Image
                            [bubbleData addObject:sayBubble];
                        }else{
                            NSBubbleData *sayBubble = [NSBubbleData dataWithText:strMessage date:date type:BubbleTypeSomeoneElse];
                            sayBubble.avatar = [UIImage imageNamed:@"user.png"]; // Object Image
                            [bubbleData addObject:sayBubble];
                        }
                    }
                    
                    // Start on last cell
                    [myTable setContentOffset:CGPointMake(myTable.contentSize.height,myTable.frame.size.height)];
                    [myTable reloadData];
                }
            }
            // ส่งข้อความ
            post = [NSMutableString stringWithFormat:@"objectID=%@&contactID=%@&message=%@&sender=%@&responder_ID=%@",objectID,userID,[message text],senderID,responderID];
            url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/insertMessage.php"];
            error = [sendBox post:post toUrl:url];
            
            if (!error) {
                int returnNum = [sendBox getReturnMessage];
                if (returnNum == 0) {
                    jsonReturn = [sendBox getData];
                    for (NSDictionary *dataDict in jsonReturn) {
                        NSString *messageID = [dataDict objectForKey:@"messageID"];
                        lastMessageID = messageID;
                    }
                    // แสดงข้อความ
                    NSBubbleData *sayBubble = [NSBubbleData dataWithText:message.text date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
                    
                    // Avatar Image
                    if ([senderID isEqualToString:@"1"]) {
                        sayBubble.avatar = [UIImage imageNamed:@"user.png"];
                    }else{
                        sayBubble.avatar = [UIImage imageNamed:@"car1.png"];
                    }
                    
                    [bubbleData addObject:sayBubble];
                    
                    // Start on last cell
                    [myTable setContentOffset:CGPointMake(myTable.contentSize.height,myTable.frame.size.height)];
                    [myTable reloadData];
                    
                    // clear text field
                    message.text = @"";
                }
            }else{
                [sendBox getErrorMessage];
            }
        }
        [message resignFirstResponder];
    }
}

- (IBAction)detailView:(id)sender {
    // ไปหน้า detail
    DetailObjectViewController *detailView =[self.storyboard instantiateViewControllerWithIdentifier:@"detailView"];
    
    detailView.recieveObjectID = objectID;
    
    [detailView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController:detailView animated:YES];
}

-(void)updateMessage{
    
    NSLog(@"hello lastMessage : %@",lastMessageID);
    
    //ส่ง ObjectID & UserID & lastMessageID ให้ php
    post = [NSMutableString stringWithFormat:@"objectID=%@&userID=%@&lastMessageID=%@",objectID,userID,lastMessageID];
    url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/getMessage.php"];
    error = [sendBox post:post toUrl:url];
    
    if (!error) {
        int returnNum = [sendBox getReturnMessage];
        if (returnNum == 0) {
            jsonReturn = [sendBox getData];
            for (NSDictionary *dataDict in jsonReturn) {
                NSString *messageID = [dataDict objectForKey:@"messageID"];
                NSString *strMessage = [dataDict objectForKey:@"message"];
                NSString *sender = [dataDict objectForKey:@"sender"];
                NSString *dateTime = [dataDict objectForKey:@"dateTime"];
                lastMessageID = messageID;

                // แปลง เวลา จาก string เป็น date
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-M-d H:m:s"];
                NSDate *date = [dateFormat dateFromString:dateTime];
                
                // ใส่ใน Table
                if ([senderID isEqualToString:@"1"]) {
                    if ([sender isEqualToString:@"1"]) {
                        NSBubbleData *sayBubble = [NSBubbleData dataWithText:strMessage date:date type:BubbleTypeMine];
                        sayBubble.avatar = [UIImage imageNamed:@"user.png"]; // User Image
                        [bubbleData addObject:sayBubble];
                    }else{
                        NSBubbleData *sayBubble = [NSBubbleData dataWithText:strMessage date:date type:BubbleTypeSomeoneElse];
                        sayBubble.avatar = [UIImage imageNamed:@"car1.png"]; // Object Image
                        [bubbleData addObject:sayBubble];
                    }
                }else{
                    if ([sender isEqualToString:@"2"]) {
                        NSBubbleData *sayBubble = [NSBubbleData dataWithText:strMessage date:date type:BubbleTypeMine];
                        sayBubble.avatar = [UIImage imageNamed:@"car1.png"]; // User Image
                        [bubbleData addObject:sayBubble];
                    }else{
                        NSBubbleData *sayBubble = [NSBubbleData dataWithText:strMessage date:date type:BubbleTypeSomeoneElse];
                        sayBubble.avatar = [UIImage imageNamed:@"user.png"]; // Object Image
                        [bubbleData addObject:sayBubble];
                    }
                }
                
                // Start on last cell
                [myTable setContentOffset:CGPointMake(myTable.contentSize.height,myTable.frame.size.height)];
                [myTable reloadData];
            }
        }
    }
}

@end
