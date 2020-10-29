//
//  AccountSettingsViewController.h
//  MobileMassage
//
//  Created by Thomas Woodfin on 12/4/14.
//  Copyright (c) 2014 Massage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"

@interface AccountSettingsViewController : AbstractViewController

@property (strong, nonatomic) IBOutlet UITextField *FirstName;
@property (strong, nonatomic) IBOutlet UITextField *LastName;
@property (strong, nonatomic) IBOutlet UITextField *MobileNumber;
@property (strong, nonatomic) IBOutlet UITextField *EmailAddress;
@property (strong, nonatomic) IBOutlet UITextField *ConfirmPassword;
@property (strong, nonatomic) IBOutlet UITextField *NewPasword;


- (IBAction)menu:(id)sender;
- (IBAction)update:(id)sender;
- (IBAction)information:(id)sender;
-(IBAction)backAction:(id)sender;


@end
