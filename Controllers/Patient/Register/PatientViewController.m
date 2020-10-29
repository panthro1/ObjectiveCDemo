//
//  PatientViewController.m
//  Doctor
//
//  Created by Arora Apps 002 on 17/11/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import "PatientViewController.h"
#import "AuthorizationViewController.h"
#import <Parse/Parse.h>

@interface PatientViewController()

@end

@implementation PatientViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [financialButton setTitle:nil forState:UIControlStateNormal];
    [financialButton setImage:[UIImage imageWithIcon:@"fa-chevron-left" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30] forState:UIControlStateNormal];
    [self setWarningInput];
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
    if (textField == _cellPhoneTextField) {
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
    if (textField == _firstNameTextField)
    {
        [_lastNameTextField becomeFirstResponder];
    }
    else if (textField ==_lastNameTextField)
    {
        [_cellPhoneTextField becomeFirstResponder];
    }
    else if (textField == _cellPhoneTextField)
    {
        [_emailTextField becomeFirstResponder];
    }
    else if (textField ==_emailTextField)
    {
        [_passwordTextField becomeFirstResponder];
    }
    else if (textField == _passwordTextField)
    {
        [_confirmpasswordTextField becomeFirstResponder];
    }
    else 
    {
       [textField resignFirstResponder];
    }
    
    return YES;
}

-(void)setWarningInput
{
    [_keyboardScroll contentSizeToFit];
    _keyboardScroll.contentSize = CGSizeMake(320, _keyboardScroll.contentSize.height);
}

-(IBAction)savebtnClick:(id)sender
{
    [TSMessage showNotificationWithTitle:@"Swurvin" subtitle:@"Please do not forget to update your billing address in profile in order to book roadside assitance." type:TSMessageNotificationTypeWarning];
    UIAlertView *errorAlertView;
    if([_firstNameTextField.text isEqualToString:@""])
    {
        errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please enter first name." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlertView show];
        
    }
    else if ([_lastNameTextField.text isEqualToString:@""])
    {
        errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please enter last name." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlertView show];
    }
    else if ([_cellPhoneTextField.text isEqualToString:@""])
    {
        errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please enter phone number." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlertView show];
    }
    else if ([_emailTextField.text isEqualToString:@""])
    {
        errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please enter email." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlertView show];
    }
    else if([_passwordTextField.text isEqualToString:@""])
    {
        errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please enter password." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlertView show];
    }
    else if(![_passwordTextField.text isEqualToString:_confirmpasswordTextField.text])
    {
        errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Password does not match." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlertView show];
    }
    else
    {
        [self doSignUp];
    }
    
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addProfile:(id)sender
{
    UIActionSheet* menuOptionsActionSheet = [[UIActionSheet alloc] initWithTitle:@"Take photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo album", nil];
    [menuOptionsActionSheet showInView:self.view];
}

#pragma mark - Action Sheet Delegate
#pragma mark -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self processSelectMenuOption:buttonIndex];
    
}
#pragma mark - Open Camera
#pragma mark -

/*
 * Process action index when press on Menu options
 */
-(void)processSelectMenuOption:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            //Camera
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showBuiltInCamera];
            });
        }
            break;
        case 1:
        {
            //Photo album
            dispatch_async(dispatch_get_main_queue(), ^{
                [self Opengallery];
            });
        }
            break;
        default:
            break;
    }
}

-(void)showBuiltInCamera
{
    if (picker)
    {
        picker.delegate=nil;
        picker=nil;
    }
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void)Opengallery
{
    if (picker)
    {
        picker.delegate=nil;
        picker=nil;
    }
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - Image Picker Delegate
#pragma mark -

-(void)imagePickerController:(UIImagePickerController*)picker2 didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    self.navigationController.navigationBarHidden = YES;
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"])
    {
        profileUploadEnable = TRUE;
        [_profileButton setImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"] forState:UIControlStateNormal];
        [picker2 dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma -mark Helper methods

-(void) doSignUp
{
    [self showWaiting];
    CustomerInfo* cus = [CustomerInfo new];
    cus.FirstName = _firstNameTextField.text;
    cus.LastName = _lastNameTextField.text;
    cus.Email = _emailTextField.text;
    cus.PhoneNumber = _cellPhoneTextField.text;
    [[BrainTreeService defaultBraintree] creatCustomerInfo:cus onDone:^(BOOL success, NSString * customerId) {
        if(success)
        {
            PFUser *patient = [PFUser user];
            patient.username = _emailTextField.text;
            patient[@"Name"] = [NSString stringWithFormat:@"%@ %@", _firstNameTextField.text, _lastNameTextField.text];
            if(profileUploadEnable)
            {
                NSData* data = UIImageJPEGRepresentation(_profileButton.imageView.image, 0.5f);
                PFFile *providePicFile = [PFFile fileWithName:@"profilePicture.jpg" data:data];
                [patient setObject:providePicFile forKey:@"providePic"];
            }
            patient[@"FirstName"] = _firstNameTextField.text;
            patient[@"LasttName"] = _lastNameTextField.text;
            patient[@"CellPhoneNumber"] = _cellPhoneTextField.text;
            patient[@"PhoneNumber"] = _cellPhoneTextField.text;
            patient.password = _passwordTextField.text;
            patient[@"Status"] = @"Patient";
            patient[@"emailaddress"]= _emailTextField.text;
            patient[@"email"] = _emailTextField.text;
            patient[@"CustomerId"] = customerId;
            [patient signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [self dismissWaiting];
                if (!error) {
                    [[[UIAlertView alloc]initWithTitle:@"Swurvin" message:@"Successfully created your profile." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                    AuthorizationViewController* vc = [mainStoryboard instantiateViewControllerWithIdentifier: (IPAD_VERSION ? @"AuthorizationViewController" : @"AuthorizationViewControlleriPhone")];
                    vc.isAuthorizationPatient = TRUE;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    NSDictionary *errorDetails = [error userInfo];
                    NSString *detail = [errorDetails objectForKey:@"error"];
                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:detail delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [errorAlertView show];
                }
            }];
        }
        else
        {
            [self dismissWaiting];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:customerId delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
        
    } onError:^(BOOL error) {
        [self dismissWaiting];
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"We are sorry, we cannot create your profile at this time. Please try later." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlertView show];
    }];
}

@end
