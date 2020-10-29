//
//  FinancialViewController.h
//  doctor
//
//  Created by Thomas Woodfin on 6/19/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSPickerView.h"
#import "AuthorizationViewController.h"
#import "TextFieldValidator.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface FinancialViewController : BaseViewController
{
@private
    UIPickerView *picView;
    IBOutlet UITextField* _cityStateZipCodeTxt;
    IBOutlet UITextField* _zipcodetxt;
    IBOutlet UITextField* _lastNameTextField;
    IBOutlet UITextField* _otherPhoneNumberTxt;
    IBOutlet UITextField* _paypalEmailTxt;
    IBOutlet UITextField* _creditCardNumberTxt;
    IBOutlet UITextField* _bankNameTxt;
    IBOutlet UITextField* _bankAccountNumberTxt;
    IBOutlet UITextField* _routingNumberTxt;
    IBOutlet UITextField* _newpasswordTxt;
    IBOutlet UITextField* _confirmpasswordTxt;
    IBOutlet UILabel* _homeTxt;
    IBOutlet UILabel* _workTxt;
    IBOutlet TPKeyboardAvoidingScrollView* _keyboardScroll;
    IBOutlet UIImageView* profileImageView;
    
}

/*
 * Define Properties
 */
@property (nonatomic,retain) UIPopoverController *popoverController;
@property(nonatomic,retain)IBOutlet TextFieldValidator *Nametxt,*Addresstxt,*cellphonenumbertxt;
@property (strong, nonatomic) IBOutlet TextFieldValidator *emailAddress;

/*
 * Define methoda
 */
- (IBAction)savebtnClick:(id)sender;
- (IBAction)backAction:(id)sender;



@end
