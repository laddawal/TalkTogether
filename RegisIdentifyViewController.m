//
//  RegisIdentifyViewController.m
//  TalkTogether
//
//  Created by PloyZb on 12/8/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "RegisIdentifyViewController.h"

@interface RegisIdentifyViewController ()

@end

@implementation RegisIdentifyViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
