//
//  AuthorizationViewController.m
//  doctor
//
//  Created by Thomas Woodfin on 11/29/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import "AuthorizationViewController.h"
//#import "payPalScanViewController.h"
#import "PatientRequestViewController.h"

@interface AuthorizationViewController ()

@end

@implementation AuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!_isAuthorizationPatient)
    {
        NSString *filePath= [[NSBundle mainBundle] pathForResource:@"DoctorTermOfUse" ofType:@"plist"];
        NSMutableDictionary* dicTermOfUse = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        _termOfUseTextView.text = [dicTermOfUse objectForKey:@"termofuse"];
        _termOfUseTextView.textColor = [UIColor whiteColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma -mark Actions

- (IBAction)authorizeButton:(id)sender
{
    /*payPalScanViewController* payPalScanVC = [self.storyboard instantiateViewControllerWithIdentifier:(IPAD_VERSION ? @"payPalScanViewControllerId" : @"payPalScanViewControllerIdiPhone")];
    [self.navigationController pushViewController:payPalScanVC animated:YES];*/
    if(_isAuthorizationPatient)
    {
        MasterDetailViewController* masterDetail = [self.storyboard instantiateViewControllerWithIdentifier: @"MasterDetailViewControllerId"];
        [self.navigationController pushViewController:masterDetail animated:YES];
    }
    else
    {
        [self loadRequests];
    }
}

- (void)loadRequests {
    PFQuery *postQuery = [PFQuery queryWithClassName:@"PatientRequest"];
    [postQuery whereKey:@"Doctor" equalTo:[PFUser currentUser]];
    [postQuery whereKey:@"requestStatus" equalTo:@"Accepted"];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            
            PatientRequestViewController* vc = [[PatientRequestViewController alloc] initWithNibName:(IPAD_VERSION ? @"PatientRequestViewController" : @"PatientRequestViewControlleriPhone") bundle:nil];
            //vc.requests = objects;
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            MasterDetailViewController* masterDetail = [mainStoryboard instantiateViewControllerWithIdentifier: @"MasterDetailViewControllerId"];
            masterDetail.ignoreAddMainMenu = TRUE;
            [masterDetail setCenterViewControllerWithMasterDetail:vc];
            [self.navigationController pushViewController:masterDetail animated:YES];
            
        }
    }];
}

- (IBAction)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
