//
//  AccountSettingsViewController.m
//  MobileMassage
//
//  Created by Thomas Woodfin on 12/4/14.
//  Copyright (c) 2014 Massage. All rights reserved.
//

#import "AccountSettingsViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface AccountSettingsViewController ()

@end

@implementation AccountSettingsViewController
@synthesize FirstName;
@synthesize LastName;
@synthesize MobileNumber;
@synthesize EmailAddress;
@synthesize NewPasword;
@synthesize ConfirmPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    PFUser *patientsDetails = [PFUser currentUser];
    self.FirstName.text = patientsDetails[@"FirstName"];
    self.LastName.text = patientsDetails[@"LasttName"];
    self.MobileNumber.text = patientsDetails[@"PhoneNumber"];
    self.EmailAddress.text = patientsDetails[@"emailaddress"] ;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)menu:(id)sender {
    //[self toogleMasterView:sender];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)update:(id)sender {
    [self information:nil];
    
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)information:(id)sender {
    
    if (self.FirstName.text.length < 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Select Your First Name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil
                              ];
        [alert show];
        return;
        
    }
    
    if (self.LastName.text.length < 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Select Your Last Name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil
                              ];
        [alert show];
        return;
    }
    
    NSUInteger nMonth = [self.MobileNumber.text length];
    if (nMonth < 1 || nMonth > 14) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Your Mobile Number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil
                              ];
        [alert show];
        return;
    }
    
    PFUser *patientsDetails = [PFUser currentUser];
    if([self.NewPasword hasText])
    {
        if (self.ConfirmPassword.text.length < 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Confirm Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil
                                  ];
            [alert show];
            return;
        }
        
        if(![self.NewPasword.text isEqualToString:self.ConfirmPassword.text])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Confirm Password Does Not Match." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil
                                  ];
            [alert show];
            return;
        }
        if([self.NewPasword hasText])
        {
            patientsDetails[@"password"] = self.NewPasword.text;
        }
    }
    

    patientsDetails[@"FirstName"] = self.FirstName.text;
    patientsDetails[@"LasttName"] = self.LastName.text;
    patientsDetails[@"PhoneNumber"] = self.MobileNumber.text;
    patientsDetails[@"emailaddress"] = self.EmailAddress.text;
    patientsDetails[@"email"] = self.EmailAddress.text;

    [self showWaiting];
    [patientsDetails saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self dismissWaiting];
        if(!error)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your information is updated." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your information is updated failure." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }];
}
@end
