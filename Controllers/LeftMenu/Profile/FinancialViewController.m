//
//  FinancialViewController.m
//  doctor
//
//  Created by Thomas Woodfin on 6/19/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import "FinancialViewController.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>
#import "AddressEntrySelection.h"

@interface FinancialViewController ()<UITextFieldDelegate>

@end

@implementation FinancialViewController

@synthesize Nametxt,Addresstxt,cellphonenumbertxt, popoverController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _workTxt.textColor = [UIColor darkGrayColor];
    _homeTxt.textColor = [UIColor darkGrayColor];
    [self setWarningInput];
    PFUser *patientsDetails = [PFUser currentUser];
    PFFile *userImageFile = patientsDetails[@"providePic"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            profileImageView.layer.masksToBounds = TRUE;
            profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2;
            profileImageView.image = [UIImage imageWithData:imageData];
        }
    }];
    Nametxt.text = patientsDetails[@"FirstName"];
    _zipcodetxt.text = patientsDetails[@"ZipCode"];
    _lastNameTextField.text = patientsDetails[@"LasttName"];
    cellphonenumbertxt.text = patientsDetails[@"PhoneNumber"];
    _emailAddress.text = patientsDetails[@"emailaddress"] ;
    Addresstxt.text = patientsDetails[@"Address"] ;
    _cityStateZipCodeTxt.text = patientsDetails[@"citystateZip"];
    _otherPhoneNumberTxt.text = patientsDetails[@"otherPhone"] ;
    _bankNameTxt.text = patientsDetails[@"bankName"];
    _paypalEmailTxt.text = patientsDetails[@"paypalEmail"];
    _paypalEmailTxt.enabled = FALSE;
    _creditCardNumberTxt.enabled = FALSE;
    NSString* credit = [NSString stringWithFormat:@"%lld",[patientsDetails[@"creditCardNumber"] longLongValue]];
    if(credit && ![credit isEqualToString:@""] && credit.length > 1)
    {
        _creditCardNumberTxt.text = credit;
    }
    NSString* bankAccount = [NSString stringWithFormat:@"%lld",[patientsDetails[@"bankAccountNumber"] longLongValue]];
    if(bankAccount && ![bankAccount isEqualToString:@""] && bankAccount.length > 1)
    {
        _bankAccountNumberTxt.text = bankAccount;
    }
    
    NSString* routingNumber = [NSString stringWithFormat:@"%lld",[patientsDetails[@"routingNumber"] longLongValue]];
    if(routingNumber && ![routingNumber isEqualToString:@""] && routingNumber.length > 1)
    {
        _routingNumberTxt.text = routingNumber;
    }
    [financialButton setTitle:nil forState:UIControlStateNormal];
    [financialButton setImage:[UIImage imageWithIcon:@"fa-chevron-left" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30] forState:UIControlStateNormal];
    _keyboardScroll.contentSize = CGSizeMake(0, _keyboardScroll.contentSize.height);
    
}

-(void)viewDidAppear:(BOOL)animated
{
    PFUser *patientsDetails = [PFUser currentUser];
    if(patientsDetails[@"addworkAddress"] && ![patientsDetails[@"addworkAddress"] isEqualToString:@""])
    {
        _workTxt.text = patientsDetails[@"addworkAddress"];
    }
    else
    {
        _workTxt.text = @"Add work";
    }
    if(patientsDetails[@"addhomeAddress"] && ![patientsDetails[@"addhomeAddress"] isEqualToString:@""])
    {
        _homeTxt.text = patientsDetails[@"addhomeAddress"];
    }
    else
    {
        _homeTxt.text = @"Add home";
    }
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UItextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == cellphonenumbertxt || textField == _otherPhoneNumberTxt) {
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        BOOL deleting = [newText length] < [textField.text length];
        
        NSString *stripppedNumber = [newText stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [newText length])];
        NSUInteger digits = [stripppedNumber length];
        
        if (digits > 10)
            stripppedNumber = [stripppedNumber substringToIndex:10];
        
        UITextRange *selectedRange = [textField selectedTextRange];
        NSInteger oldLength = [textField.text length];
        
        if (digits == 0)
            textField.text = @"";
        else if (digits < 3 || (digits == 3 && deleting))
            textField.text = [NSString stringWithFormat:@"(%@", stripppedNumber];
        else if (digits < 6 || (digits == 6 && deleting))
            textField.text = [NSString stringWithFormat:@"(%@) %@", [stripppedNumber substringToIndex:3], [stripppedNumber substringFromIndex:3]];
        else
            textField.text = [NSString stringWithFormat:@"(%@) %@-%@", [stripppedNumber substringToIndex:3], [stripppedNumber substringWithRange:NSMakeRange(3, 3)], [stripppedNumber substringFromIndex:6]];
        
        UITextPosition *newPosition = [textField positionFromPosition:selectedRange.start offset:[textField.text length] - oldLength];
        UITextRange *newRange = [textField textRangeFromPosition:newPosition toPosition:newPosition];
        [textField setSelectedTextRange:newRange];
        
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==Nametxt)
    {
        [_lastNameTextField becomeFirstResponder];
    }
    else if (textField==_lastNameTextField)
    {
        [_cityStateZipCodeTxt becomeFirstResponder];
    }
    else if (textField==_cityStateZipCodeTxt)
    {
        [_zipcodetxt becomeFirstResponder];
    }
    else if (textField==_zipcodetxt)
    {
        [Addresstxt becomeFirstResponder];
    }
    else if (textField==Addresstxt)
    {
        [cellphonenumbertxt becomeFirstResponder];
    }
    else if (textField==cellphonenumbertxt)
    {
        [_otherPhoneNumberTxt becomeFirstResponder];
    }
    else if (textField==_otherPhoneNumberTxt)
    {
        [_emailAddress becomeFirstResponder];
    }
    else if (textField==_emailAddress)
    {
        [_paypalEmailTxt becomeFirstResponder];
    }
    else if (textField==_paypalEmailTxt)
    {
        [_creditCardNumberTxt becomeFirstResponder];
    }
    else if (textField==_creditCardNumberTxt)
    {
        [_bankNameTxt becomeFirstResponder];
    }
    else if (textField==_bankNameTxt)
    {
        [_bankAccountNumberTxt becomeFirstResponder];
    }
    else if (textField==_bankAccountNumberTxt)
    {
        [_routingNumberTxt becomeFirstResponder];
    }
    else if (textField==_routingNumberTxt)
    {
        [_newpasswordTxt becomeFirstResponder];
    }
    else if (textField==_newpasswordTxt)
    {
        [_confirmpasswordTxt becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)addPlaces:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view; 
    AddressEntrySelection* addressSelection = [self.storyboard instantiateViewControllerWithIdentifier:@"AddressEntrySelection"];
    addressSelection.isAddHome = (view.tag == 0 ? TRUE : FALSE);
    [self.navigationController pushViewController:addressSelection animated:YES];
}

-(void)setWarningInput
{
    _homeTxt.tag = 0;
    _workTxt.tag = 1;
    UITapGestureRecognizer* tapEvent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPlaces:)];
    _homeTxt.userInteractionEnabled = YES;
    [_homeTxt addGestureRecognizer:tapEvent];
    UITapGestureRecognizer* tapEvent1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPlaces:)];
    _workTxt.userInteractionEnabled = YES;
    [_workTxt addGestureRecognizer:tapEvent1];
    [_keyboardScroll contentSizeToFit];
}

#pragma mark - Button Action
-(IBAction)savebtnClick:(id)sender
{
    UIAlertView* wanirngAlert;
    if ([Nametxt.text isEqualToString:@""])
    {
        wanirngAlert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please enter first name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [wanirngAlert show];
    }
    else if ([_lastNameTextField.text isEqualToString:@""])
    {
        wanirngAlert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please enter last name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [wanirngAlert show];
    }
    else if ([cellphonenumbertxt.text isEqualToString:@""])
    {
        wanirngAlert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please enter phone number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [wanirngAlert show];
    }
    else if ([_emailAddress.text isEqualToString:@""])
    {
        wanirngAlert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please enter email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [wanirngAlert show];
    }
    else
    {
        if(![_newpasswordTxt.text isEqualToString:@""])
        {
            if(![_confirmpasswordTxt.text isEqualToString:_newpasswordTxt.text])
            {
                UIAlertView* wanirngAlert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Password does not match." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [wanirngAlert show];
                return;
            }
        }
        PFUser *PatientsDetails = [PFUser currentUser];
        PatientsDetails[@"Name"] = [NSString stringWithFormat:@"%@ %@", Nametxt.text, _lastNameTextField.text];
        if(![_newpasswordTxt.text isEqualToString:@""])
        {
            PatientsDetails.password = _newpasswordTxt.text;
        }
        PatientsDetails[@"FirstName"] = Nametxt.text;
        PatientsDetails[@"LasttName"] = _lastNameTextField.text;
        PatientsDetails[@"Address"]=Addresstxt.text;
        PatientsDetails[@"CellPhoneNumber"]=cellphonenumbertxt.text;
        PatientsDetails[@"PhoneNumber"]=cellphonenumbertxt.text;
        PatientsDetails[@"otherPhone"]=_otherPhoneNumberTxt.text;
        PatientsDetails[@"emailaddress"]=self.emailAddress.text;
        PatientsDetails[@"email"]=self.emailAddress.text;
        PatientsDetails[@"ZipCode"]= _zipcodetxt.text;
        PatientsDetails[@"citystateZip"]= _cityStateZipCodeTxt.text;
        if(_paypalEmailTxt)
        {
            PatientsDetails[@"paypalEmail"]= _paypalEmailTxt.text;
        }
        PatientsDetails[@"addworkAddress"] = _workTxt.text;
        PatientsDetails[@"addhomeAddress"] = _homeTxt.text;
        if(_creditCardNumberTxt && ![_creditCardNumberTxt.text isEqualToString:@""])
        {
            PatientsDetails[@"creditCardNumber"]= [NSNumber numberWithLongLong:[_creditCardNumberTxt.text longLongValue]];
        }
        if(_bankNameTxt)
        {
            PatientsDetails[@"bankName"]= _bankNameTxt.text;
        }
        if(_bankAccountNumberTxt && ![_bankAccountNumberTxt.text isEqualToString:@""])
        {
            PatientsDetails[@"bankAccountNumber"]= [NSNumber numberWithLongLong:[_bankAccountNumberTxt.text longLongValue]];
        }
        if(_routingNumberTxt && ![_routingNumberTxt.text isEqualToString:@""])
        {
            PatientsDetails[@"routingNumber"]= [NSNumber numberWithLongLong:[_routingNumberTxt.text longLongValue]];
        }
        [self showWaiting];
        [PatientsDetails saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self dismissWaiting];
            if (!error) {
                
                [[[UIAlertView alloc]initWithTitle:@"Swurvin" message:@"Successfully updated your profile." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                
            }
            else
            {
                [[[UIAlertView alloc]initWithTitle:@"Swurvin" message:@"We are sorry. We cannot update at this time. Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            }
        }];
    }
}

#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
