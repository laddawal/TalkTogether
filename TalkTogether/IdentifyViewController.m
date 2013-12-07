//
//  IdentifyViewController.m
//  TalkTogether
//
//  Created by PloyZb on 12/1/56 BE.
//  Copyright (c) 2556 PloyZb. All rights reserved.
//

#import "IdentifyViewController.h"

@interface IdentifyViewController ()

@end

@implementation IdentifyViewController

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
