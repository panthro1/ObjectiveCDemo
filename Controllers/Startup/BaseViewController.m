//
//  BaseViewController.m
//  doctor
//
//  Created by Thomas.Woodfin on 7/17/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import "BaseViewController.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)showWaiting
{
    [SVProgressHUD show];
}

-(void)showWaiting:(NSString*)title
{
    [SVProgressHUD showInfoWithStatus:title];
}

-(void)dismissWaiting
{
    [SVProgressHUD dismiss];
}

@end
