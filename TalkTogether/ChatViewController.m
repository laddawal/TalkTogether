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

@interface ChatViewController ()

@end

@implementation ChatViewController
{
    NSMutableArray *myObject;
    
    NSMutableArray *bubbleData;
    
    NSString *lastMessageID;
    
    NSString *objectID;
    NSString *userID;
    UIImage *userPic;
    
    NSString *senderID;
}
@synthesize myTable,message,textViewInput;
@synthesize recieveObjectID;
@synthesize recieveUserID;
@synthesize recieveSender;

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

    myTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_background.png"]]; // bg table
    
    sendBox = [[postMessage alloc]init];
    
    // รับ objectID ,userID และ sender จาหหน้าก่อนหน้า
    objectID = [recieveObjectID description];
    userID = [recieveUserID description];
    senderID = [recieveSender description];
    NSLog(@"objectIDChat : %@",objectID);
    NSLog(@"userIDChat : %@",userID);
    NSLog(@"senderChat : %@",senderID);
    
    lastMessageID = [NSString stringWithFormat:@"0"];
	// Do any additional setup after loading the view, typically from a nib.
    
//    NSBubbleData *heyBubble = [NSBubbleData dataWithText:@"Hey, halloween is soon" date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
//    heyBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
//    
//    NSBubbleData *photoBubble = [NSBubbleData dataWithImage:[UIImage imageNamed:@"halloween.jpg"] date:[NSDate dateWithTimeIntervalSinceNow:-290] type:BubbleTypeSomeoneElse];
//    photoBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
//    
//    NSBubbleData *replyBubble = [NSBubbleData dataWithText:@"Wow.. Really cool picture out there. iPhone 5 has really nice camera, yeah?" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
//    replyBubble.avatar = nil;
    
    bubbleData = [[NSMutableArray alloc] init];
    myTable.bubbleDataSource = self.myTable.bubbleDataSource;
    
    // The line below sets the snap interval in seconds. This defines how the bubbles will be grouped in time.
    // Interval of 120 means that if the next messages comes in 2 minutes since the last message, it will be added into the same group.
    // Groups are delimited with header which contains date and time for the first message in the group.
    
    myTable.snapInterval = 120;
    
    // The line below enables avatar support. Avatar can be specified for each bubble with .avatar property of NSBubbleData.
    // Avatars are enabled for the whole table at once. If particular NSBubbleData misses the avatar, a default placeholder will be set (missingAvatar.png)
    
    myTable.showAvatars = YES;
    
    // Uncomment the line below to add "Now typing" bubble
    // Possible values are
    //    - NSBubbleTypingTypeSomebody - shows "now typing" bubble on the left
    //    - NSBubbleTypingTypeMe - shows "now typing" bubble on the right
    //    - NSBubbleTypingTypeNone - no "now typing" bubble
    
    myTable.typingBubble = NSBubbleTypingTypeSomebody;
    
//    [myTable reloadData];
    
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

- (IBAction)sendBtn:(id)sender {
    myTable.typingBubble = NSBubbleTypingTypeNobody;
    NSBubbleData *sayBubble = [NSBubbleData dataWithText:message.text date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
    sayBubble.avatar = [UIImage imageNamed:@"navigationBar.png"]; // Object Image
    [bubbleData addObject:sayBubble];
    
    // Start on last cell
    [myTable setContentOffset:CGPointMake(myTable.contentSize.height,myTable.frame.size.height)];
    [myTable reloadData];
    
    
    NSMutableString *post = [NSMutableString stringWithFormat:@"objectID=%@&contactID=%@&message=%@&sender=%@",objectID,userID,[message text],senderID];
    NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/insertMessage.php"];
    
    NSMutableArray *jsonReturn = [sendBox post:post toUrl:url];
    
    if (jsonReturn != nil) {
        for (NSDictionary *dataDict in jsonReturn) {
            
            NSString *messageID = [dataDict objectForKey:@"messageID"];
            lastMessageID = messageID;
        }
    }else{
        [sendBox getErrorMessage];
    }
    
    // clear text field
    message.text = @"";
    
    [message resignFirstResponder];
}

-(void)updateMessage{
    
    NSLog(@"hello lastMessage : %@",lastMessageID);
    
    //ส่ง ObjectName & UserID ให้ php
    NSMutableString *post = [NSMutableString stringWithFormat:@"objectID=%@&userID=%@&lastMessageID=%@",objectID,userID,lastMessageID];
    
     NSURL *url = [NSURL URLWithString:@"http://angsila.cs.buu.ac.th/~53160117/TalkTogether/getMessage.php"];
    
    NSMutableArray *jsonReturn = [sendBox post:post toUrl:url];
    
    if (jsonReturn != nil) {
        for (NSDictionary *dataDict in jsonReturn) {
            
            NSString *messageID = [dataDict objectForKey:@"messageID"];
            NSString *strMessage = [dataDict objectForKey:@"message"];
            NSString *sender = [dataDict objectForKey:@"sender"];
            NSLog(@"messageID : %@",messageID);
            lastMessageID = messageID;
            
            // ใส่ใน Table
            if ([sender isEqualToString:@"1"]) {
                myTable.typingBubble = NSBubbleTypingTypeNobody;
                NSBubbleData *sayBubble = [NSBubbleData dataWithText:strMessage date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
//                sayBubble.avatar = userPic; // User Image
                [bubbleData addObject:sayBubble];
            }else{
                myTable.typingBubble = NSBubbleTypingTypeNobody;
                NSBubbleData *sayBubble = [NSBubbleData dataWithText:strMessage date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeSomeoneElse];
//                sayBubble.avatar = [UIImage imageNamed:@"navigationBar.png"]; // Object Image
                [bubbleData addObject:sayBubble];
            }
            
            // Start on last cell
            [myTable setContentOffset:CGPointMake(myTable.contentSize.height,myTable.frame.size.height)];
            [myTable reloadData];
        }                   
    }else{
        //[sendBox getErrorMessage];
    }
}

@end
