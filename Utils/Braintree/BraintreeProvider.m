//
//  BraintreeProvider.m
//  doctor
//
//  Created by Thomas.Woodfin on 8/19/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import "BraintreeProvider.h"

@implementation BraintreeProvider

+(BraintreeProvider*)sharedInstance
{
    static BraintreeProvider* _braintreeProvider;
    if(!_braintreeProvider)
    {
        _braintreeProvider = [[BraintreeProvider alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanCardAction) name:@"ScanCard" object:nil];
        _braintreeProvider.braintree = [Braintree braintreeWithClientToken:CLIENT_TOKEN];
    }
    return _braintreeProvider;
}

-(void)presentDropUI:(UIViewController*)nav delegate:(id)delegate
{
    _Controller = nav;
    dropInViewController = [self.braintree dropInViewControllerWithDelegate:self];
    //Fix later
    //dropInViewController.dropInContentView.hasAvailableScanCard = 3;
    dropInViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dropInViewControllerDidCancel:)];
    dropInViewController.callToActionText = @"DONE";
    dropInViewController.title = @"ADD PAYMENT";
    [dropInViewController fetchPaymentMethods];
    navigationController = [[UINavigationController alloc] initWithRootViewController:dropInViewController];
    [_Controller presentViewController:navigationController animated:YES completion:nil];
}

#pragma -mark BrainTree Impl

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)cardInfo inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    [paymentViewController dismissViewControllerAnimated:YES completion:^{
        [self addCardFormWithInfo:cardInfo];
        [_Controller presentViewController:navigationController animated:NO completion:nil];
    }];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    [paymentViewController dismissViewControllerAnimated:YES completion:^{
        [_Controller presentViewController:navigationController animated:NO completion:nil];
    }];
}

-(void)scanCardAction
{
    [navigationController dismissViewControllerAnimated:NO completion:^{
        CardIOPaymentViewController *v = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
        
        [_Controller presentViewController:v
                           animated:YES
                         completion:nil];
    }];
}

- (void)dropInViewController:(__unused BTDropInViewController *)viewController didSucceedWithPaymentMethod:(BTPaymentMethod *)paymentMethod1 {
    paymentMethod = paymentMethod1;
    [_Controller dismissViewControllerAnimated:NO completion:nil];
    if(_braintreeDelegate)
    {
        [_braintreeDelegate braintreeProviderFinished:paymentMethod];
    }
}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [_Controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)addCardFormWithInfo:(CardIOCreditCardInfo *)info {
    //Fix later
//    BTUICardFormView *cardForm = dropInViewController.dropInContentView.cardForm;
//    
//    if (info) {
//        cardForm.number = info.cardNumber;
//        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
//        dateComponents.month = info.expiryMonth;
//        dateComponents.year = info.expiryYear;
//        dateComponents.calendar = [NSCalendar calendarWithIdentifier:NSGregorianCalendar];
//        [cardForm setExpirationDate:dateComponents.date];
//    }
}

//PFUser *PatientsDetails = [PFUser user];
//PatientsDetails.username = _emailTextField.text;
//PatientsDetails[@"Name"] = [NSString stringWithFormat:@"%@ %@", _firstNameTextField.text, _lastNameTextField.text];
//if(profileUploadEnable)
//{
//    NSData* data = UIImageJPEGRepresentation(_profileButton.imageView.image, 0.5f);
//    PFFile *providePicFile = [PFFile fileWithName:@"profilePicture.jpg" data:data];
//    [PatientsDetails setObject:providePicFile forKey:@"providePic"];
//}
//NSString* phonenumber = _cellPhoneTextField.text;
//PatientsDetails[@"FirstName"] = _firstNameTextField.text;
//PatientsDetails[@"LasttName"] = _lastNameTextField.text;
//PatientsDetails[@"CellPhoneNumber"] = phonenumber;
//PatientsDetails[@"PhoneNumber"] = phonenumber;
//PatientsDetails.password = _passwordTextField.text;
//PatientsDetails[@"Status"] = @"Patient";
//PatientsDetails[@"emailaddress"]= _emailTextField.text;
//PatientsDetails[@"email"] = _emailTextField.text;
//[PatientsDetails signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//    if (!error) {
//        CustomerInfo* cus = [CustomerInfo new];
//        cus.FirstName = _firstNameTextField.text;
//        cus.LastName = _lastNameTextField.text;
//        cus.Email = _emailTextField.text;
//        cus.PhoneNumber = phonenumber;
//        [[BrainTreeService defaultBraintree] creatCustomerInfo:cus onDone:^(BOOL success, NSString * customerId) {
//            if(success)
//            {
//                PFObject* payment = [PFObject objectWithClassName:@"Payment"];
//                payment[@"CustomerId"] = customerId;
//                payment[@"isSelected"] = [NSNumber numberWithBool:YES];
//                [[BrainTreeService defaultBraintree] addPaymentMethod:paymentMethod.nonce tocustomerId:customerId onDone:^(BOOL success, NSString *paymentToken) {
//                    if(success)
//                    {
//                        payment[@"PaymentToken"] = paymentToken;
//                        if([paymentMethod isKindOfClass:[BTPayPalPaymentMethod class]])
//                        {
//                            payment[@"PaymentName"] = ((BTPayPalPaymentMethod*)paymentMethod).email;
//                            payment[@"PaymentType"] = @"PayPal";
//                            
//                        }
//                        else
//                        {
//                            BTUICardFormView *cardForm = dropInViewController.dropInContentView.cardForm;
//                            payment[@"PaymentName"] = cardForm.number;
//                            payment[@"PaymentType"] = ((BTCardPaymentMethod*)paymentMethod).typeString;
//                        }
//                        [payment save];
//                        PFRelation* relation = [PatientsDetails relationForKey:@"Payment"];
//                        [relation addObject:payment];
//                        [PatientsDetails saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                            [self dismissWaiting];
//                            if(succeeded)
//                            {
//                                [[[UIAlertView alloc]initWithTitle:@"Swurvin" message:@"Successfully created your profile." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
//                                // UI Changes - Devang
//                                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//                                AuthorizationViewController* vc = [mainStoryboard instantiateViewControllerWithIdentifier: (IPAD_VERSION ? @"AuthorizationViewController" : @"AuthorizationViewControlleriPhone")];
//                                vc.isAuthorizationPatient = TRUE;
//                                //[self presentViewController:vc animated:YES completion:Nil];
//                                [self.navigationController pushViewController:vc animated:YES];
//                            }
//                            else
//                            {
//                                
//                                [PatientsDetails deleteInBackground];
//                                [PFUser logOut];
//                                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                                [errorAlertView show];
//                            }
//                        }];
//                    }
//                    else
//                    {
//                        [self dismissWaiting];
//                        [PatientsDetails deleteInBackground];
//                        [PFUser logOut];
//                        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:paymentToken delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                        [errorAlertView show];
//                    }
//                } onError:^(BOOL error) {
//                    [self dismissWaiting];
//                    [PatientsDetails deleteInBackground];
//                    [PFUser logOut];
//                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                    [errorAlertView show];
//                }];
//            }
//            else
//            {
//                [self dismissWaiting];
//                [PatientsDetails deleteInBackground];
//                [PFUser logOut];
//                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:customerId delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                [errorAlertView show];
//            }
//            
//        } onError:^(BOOL error) {
//            [self dismissWaiting];
//            [PatientsDetails deleteInBackground];
//            [PFUser logOut];
//            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [errorAlertView show];
//        }];
//        
//    }
//    else
//    {
//        [self dismissWaiting];
//        NSDictionary *errorDetails=[error userInfo];
//        NSString *detail=[errorDetails objectForKey:@"error"];
//        NSLog(@"%@",error);
//        NSString *errorString = [NSString stringWithFormat:@"username %@ already taken",_emailTextField.text];
//        NSDictionary *errorDict = error.userInfo;
//        if ([[errorDict objectForKey:@"error"] isEqualToString:errorString]){
//            NSLog(@"The user name already exists.");
//        }
//        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:detail delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [errorAlertView show];
//    }
//}];

@end
