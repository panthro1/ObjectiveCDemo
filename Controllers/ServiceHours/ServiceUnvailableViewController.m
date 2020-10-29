//
//  ServiceUnvailableViewController.m
//  doctor
//
//  Created by Thomas.Woodfin on 5/7/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import "ServiceUnvailableViewController.h"
#import "HelperUtils.h"

@interface ServiceUnvailableViewController ()

@end

@implementation ServiceUnvailableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)retryServiceAction:(id)sender
{
    //Do check time past
    if([HelperUtils isReadyForBookDoctor])//before 8PM
    {
        [DSRequestDoctor sharedIntsance].operatorTime = TRUE;
    }
    else // after 8PM
    {
        [DSRequestDoctor sharedIntsance].operatorTime = FALSE;
    }
    if(_delegateService)
    {
        [_delegateService ServiceUnvailableRetry];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
