//
//  EditObjectViewController.m
//  TalkTogether
//
//  Created by PloyZb on 11/12/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "EditObjectViewController.h"

@interface EditObjectViewController ()

@end

@implementation EditObjectViewController
{
    NSString *objectID;
}
@synthesize recieveObjectID;

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]; // bg
    
    // รับ objectID จาหหน้าก่อนหน้า
    objectID = [recieveObjectID description];
    NSLog(@"objectIDEditObject : %@",objectID);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
