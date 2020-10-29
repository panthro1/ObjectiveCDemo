//
//  PatientViewController.h
//  Doctor
//
//  Created by Arora Apps 002 on 17/11/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSPickerView.h"
#import "AuthorizationViewController.h"
#import "TextFieldValidator.h"
#import "TPKeyboardAvoidingScrollView.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface PatientViewController : BaseViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    //TextField
    IBOutlet UITextField* _firstNameTextField;
    IBOutlet UITextField* _lastNameTextField;
    IBOutlet UITextField* _cellPhoneTextField;
    IBOutlet UITextField* _passwordTextField;
    IBOutlet UITextField* _confirmpasswordTextField;
    IBOutlet UITextField* _emailTextField;
    //Buttons
    IBOutlet UIButton* _profileButton;
    IBOutlet UIButton* _linkAccountButton;
    IBOutlet TPKeyboardAvoidingScrollView* _keyboardScroll;
    UIImagePickerController *picker;
    BOOL profileUploadEnable;
   
}
//Actions
- (IBAction)savebtnClick:(id)sender;
- (IBAction)addProfile:(id)sender;


@end
