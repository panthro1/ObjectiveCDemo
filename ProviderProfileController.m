//
//  ProviderProfileController.m
//  doctorsos
//
//  Created by Muhammad Imran on 12/10/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import "ProviderProfileController.h"
#import "HelperUtils.h"
#import "ProblemTableViewController.h"
#import "AuthorizationViewController.h"

#define SCREEN_SIZE_WIDTH [[ UIScreen mainScreen] bounds ].size.width
#define SCREEN_SIZE_HEIGHT [[ UIScreen mainScreen] bounds ].size.height

@interface ProviderProfileController ()<ProblemListDelegate, UITextFieldDelegate>
{
    NSMutableArray* _medicalArr;
    PFGeoPoint* currentGeoPoint;
}
@end

@implementation ProviderProfileController
@synthesize popoverController;
@synthesize Save;

- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    [scrolView contentSizeToFit];
    listState = @[@"AL", @"AK", @"AZ", @"AR",@"CA", @"CO",@"CT", @"DE",@"FL", @"GA",@"HI", @"ID",@"IL"
                  , @"IN",@"IA", @"KS",@"KY", @"LA",@"ME", @"MD",@"MA", @"MI",@"MN", @"MS",@"MO", @"MT",@"NE"
                  , @"NV",@"NH", @"NJ",@"NM", @"NY",@"NC", @"ND",@"OH", @"OK",@"OR", @"PA",@"RI", @"SC",@"SD", @"TN",@"TX", @"UT",@"VT", @"VA",@"WA", @"WV",@"WI", @"WY"];
    [financialButton setTitle:nil forState:UIControlStateNormal];
    [financialButton setImage:[UIImage imageWithIcon:@"fa-chevron-left" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:30] forState:UIControlStateNormal];
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        currentGeoPoint = geoPoint;
    }];
    scrolView.contentSize = CGSizeMake(0, scrolView.contentSize.height);
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
}

-(IBAction)stateList:(id)sender
{
    RSPickerView *picker1 = [[RSPickerView alloc]initWithOptions:listState];
    picker1.type = RSPickerTypeStandard;
    picker1.tag = 1;
    picker1.del = self;
    _listState = TRUE;
    [picker1 showInView:self.view];
}

-(void)RSPicker:(RSPickerView *)picker1 didDismissWithSelection:(id)selection inTextField:(UITextField *)textField Response:(NSString *)response
{
    if(picker1.tag == 1)
    {
        _regionTextField.text = response;
    }
    else
    {
        medicalSpecialitytxt.text=response;
    }
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)userLocation1 {
    CLLocationCoordinate2D loc = [userLocation1.location coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000.0f, 1000.0f);
    [aMapView setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UItextField Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == _regionTextField)
    {
        [textField resignFirstResponder];
        [self stateList:nil];
    }
    return TRUE;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == phonenumber) {
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
            textField.text = [NSString stringWithFormat:@"(%@) %@", [stripppedNumber substringToIndex:2], [stripppedNumber substringFromIndex:2]];
        else
            textField.text = [NSString stringWithFormat:@"(%@) %@-%@", [stripppedNumber substringToIndex:3], [stripppedNumber substringWithRange:NSMakeRange(3, 3)], [stripppedNumber substringFromIndex:6]];
        
        UITextPosition *newPosition = [textField positionFromPosition:selectedRange.start offset:[textField.text length] - oldLength];
        UITextRange *newRange = [textField textRangeFromPosition:newPosition toPosition:newPosition];
        [textField setSelectedTextRange:newRange];
        
        return NO;
    }
    else if (textField == _ssnTextField) {
        if ((_ssnTextField.text.length == 3)||(_ssnTextField.text.length == 6))
            //Handle backspace being pressed
            if (![string isEqualToString:@""])
                _ssnTextField.text = [_ssnTextField.text stringByAppendingString:@"-"];
        return !([textField.text length] > 10 && [string length] > range.length);
    }
    else if (textField == _dateofbirthTextField)
    {
        if ((_dateofbirthTextField.text.length == 4)||(_dateofbirthTextField.text.length ==7))
            //Handle backspace being pressed
            if (![string isEqualToString:@""])
                _dateofbirthTextField.text = [_dateofbirthTextField.text stringByAppendingString:@"-"];
        return !([textField.text length] > 9 && [string length] > range.length);
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
    else if (textField == _lastNameTextField)
    {
        [_dateofbirthTextField becomeFirstResponder];
    }
    else if (textField == _dateofbirthTextField)
    {
        [_streetAddressTextField becomeFirstResponder];
    }
    else if (textField == _streetAddressTextField)
    {
        [_ssnTextField becomeFirstResponder];
    }
    else if (textField == _ssnTextField)
    {
        [_localcityTextField becomeFirstResponder];
    }
    else if (textField == _localcityTextField)
    {
        [_regionTextField becomeFirstResponder];
    }
    else if (textField == _regionTextField)
    {
        [_postcodeTextField becomeFirstResponder];
    }
    else if (textField == _postcodeTextField)
    {
        [phonenumber becomeFirstResponder];
    }
    else if (textField == phonenumber)
    {
        [_emailAddressTextField becomeFirstResponder];
    }
    else if (textField == _emailAddressTextField)
    {
        [passowordtxt becomeFirstResponder];
    }
    else if (textField == passowordtxt)
    {
        [confirmpassowordtxt becomeFirstResponder];
    }
    else if (textField == confirmpassowordtxt)
    {
        [self medicalSpecialitySelect:nil];
    }
    else if (textField == medicalLicensetxt)
    {
        [DriverLicensetxt becomeFirstResponder];
    }
    else if (textField == DriverLicensetxt)
    {
        [carinsurencetxt becomeFirstResponder];
    }
    else if (textField == carinsurencetxt)
    {
        [medicalmalpracticetxt becomeFirstResponder];
    }
    else if (textField == medicalmalpracticetxt)
    {
        [banknametxt becomeFirstResponder];
    }
    else if (textField == banknametxt)
    {
        [accountnumbertxt becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma -mark Location Delegates
- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (newLocation.verticalAccuracy>0 && newLocation.verticalAccuracy < 100) {
        userLocation = newLocation;
        [locationManager stopUpdatingLocation];
        
    }
    userLocation = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    UIAlertView *alertView  = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There is some problem with location service" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alertView show];
    userLocation = nil;
    
}

#pragma mark - Button Action
-(IBAction)savebtnClick:(id)sender
{
    if ([_firstNameTextField.text length]<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"SOS Doctor" message:@"Please enter first name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    if ([_lastNameTextField.text length]<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"SOS Doctor" message:@"Please enter last name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    if ([_dateofbirthTextField.text length]<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"SOS Doctor" message:@"Please enter date of birth" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    if ([_streetAddressTextField.text length]<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"SOS Doctor" message:@"Please enter street address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    if ([_ssnTextField.text length]<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"SOS Doctor" message:@"Please enter SSN" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    if ([_localcityTextField.text length]<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"SOS Doctor" message:@"Please enter city" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    if ([_regionTextField.text length]<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"SOS Doctor" message:@"Please select state" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    if ([_postcodeTextField.text length]<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"SOS Doctor" message:@"Please enter zip code" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    //Name Validation
    NSString *stringPlace = @"[a-z  A-Z]*";
    NSPredicate *testPlace = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringPlace];
    BOOL name = [testPlace evaluateWithObject:_firstNameTextField.text];
    if(!name)
    {
        [[[UIAlertView alloc]initWithTitle:@"SOS Doctor" message:@"Please enter alphabets only (Doesn't support speal symbols)." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    name = [testPlace evaluateWithObject:_lastNameTextField.text];
    if(!name)
    {
        [[[UIAlertView alloc]initWithTitle:@"SOS Doctor" message:@"Please enter alphabets only (Doesn't support speal symbols)." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    //PhoneNumber Validation
    if ([phonenumber.text isEqualToString:@""]) {
        [[[UIAlertView alloc]initWithTitle:@"SOS Doctor" message:@"Please enter phone number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }

    if ([_emailAddressTextField.text length]<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"SOS Doctor" message:@"Please enter email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    if ([passowordtxt.text length]<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"SOS Doctor" message:@"Please enter your password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    else if ([confirmpassowordtxt.text length]<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"SOS Doctor" message:@"Please confirm your password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    else if (![passowordtxt.text isEqualToString:confirmpassowordtxt.text])
    {
        [[[UIAlertView alloc]initWithTitle:@"SOS Doctor" message:@"Password does not match." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    else if ([medicalSpecialitytxt.text length]<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"SOS Doctor" message:@"Please select your medical speciality." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    else if (providerImage == nil) {
        
        [[[UIAlertView alloc]initWithTitle:@"SOS Doctor" message:@"Please Add Profile Picture." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }else if (medicalLicenseImage == nil) {
       
        [[[UIAlertView alloc]initWithTitle:@"SOS Doctor" message:@"Please Add Medical License Picture." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    else if ([banknametxt.text length]<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"SOS Doctor" message:@"Please enter bank name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    else if ([accountnumbertxt.text length]<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"SOS Doctor" message:@"Please enter bank account number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    else if ([routingNumbertxt.text length]<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"SOS Doctor" message:@"Please enter routing number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    else
    {
        
        [self showWaiting];
        BraintreeModel* braintreeModel = [[BraintreeModel alloc] init];
        braintreeModel.FirstName = _firstNameTextField.text;
        braintreeModel.LastName = _lastNameTextField.text;
        braintreeModel.PhoneNumber = phonenumber.text;
        braintreeModel.AccountNumber = accountnumbertxt.text;
        braintreeModel.LegalName = banknametxt.text;
        braintreeModel.Email = _emailAddressTextField.text;
        braintreeModel.RoutingNumber = routingNumbertxt.text;
        braintreeModel.DateOfBirth = _dateofbirthTextField.text;
        braintreeModel.StreetAddress = _streetAddressTextField.text;
        braintreeModel.SSN = _ssnTextField.text;
        braintreeModel.Locality = _localcityTextField.text;
        braintreeModel.Religion = _regionTextField.text;
        braintreeModel.PostCode = _postcodeTextField.text;
        [[BrainTreeService defaultBraintree] creatSubMerchant:braintreeModel onDone:^(BOOL success, NSString* SubMerchantId) {
            if(success == TRUE)
            {
                NSData* data = UIImageJPEGRepresentation(providerImage, 0.5f);
                PFFile *providePicFile = [PFFile fileWithName:@"profilePicture.jpg" data:data];
                data = UIImageJPEGRepresentation(medicalLicenseImage, 0.5f);
                PFFile *imageFilemedicallicense = [PFFile fileWithName:@"medicalLicenseImage.jpg" data:data];
                PFUser *ProviderDetails = [PFUser user];
                ProviderDetails.username = _emailAddressTextField.text;
                ProviderDetails.password = passowordtxt.text;
                ProviderDetails[@"Name"] = [NSString stringWithFormat:@"%@ %@", _firstNameTextField.text, _lastNameTextField.text];
                ProviderDetails[@"FirstName"] = _firstNameTextField.text;
                ProviderDetails[@"LasttName"] = _lastNameTextField.text;
                ProviderDetails[@"Status"] = @"Provider";
                ProviderDetails[@"email"] = _emailAddressTextField.text;
                ProviderDetails[@"emailaddress"] = _emailAddressTextField.text;
                ProviderDetails[@"PhoneNumber"] = phonenumber.text;
                ProviderDetails[@"Address"] =  _streetAddressTextField.text;
                ProviderDetails[@"City"] = _localcityTextField.text;
                ProviderDetails[@"ZipCode"]= _postcodeTextField.text;
                ProviderDetails[@"Religion"]= _regionTextField.text;
                ProviderDetails[@"medicalSpeciality"] = medicalSpecialitytxt.text;
                ProviderDetails[@"bankName"] = banknametxt.text;
                ProviderDetails[@"citystateZip"] = _regionTextField.text;
                
                if(![accountnumbertxt.text isEqualToString:@""])
                {
                    ProviderDetails[@"bankAccountNumber"] = [NSNumber numberWithInt:[accountnumbertxt.text intValue]];
                }
                ProviderDetails[@"routingNumber"] = [NSNumber numberWithInt:[routingNumbertxt.text intValue]];
                
                [ProviderDetails setObject:providePicFile forKey:@"providePic"];
                [ProviderDetails setObject:imageFilemedicallicense forKey:@"Medicalicense"];
                if (DriverLicenseImage != nil) {
                    data = UIImageJPEGRepresentation(DriverLicenseImage, 0.5f);
                    PFFile *imageFiledrivinglicense = [PFFile fileWithName:@"DriverLicenseImage.jpg" data:data];
                    [ProviderDetails setObject:imageFiledrivinglicense forKey:@"DrvingLicense"];
                }
                if (carmakeImage != nil) {
                    data = UIImageJPEGRepresentation(carmakeImage, 0.5f);
                    PFFile *imageFilecarmakelicense = [PFFile fileWithName:@"carmakeImage.jpg" data:data];
                    [ProviderDetails setObject:imageFilecarmakelicense forKey:@"Carmake"];
                }
                if (carinsurenceImage != nil) {
                    data = UIImageJPEGRepresentation(carinsurenceImage, 0.5f);
                    PFFile *imageFilecarinsuranxcelicense = [PFFile fileWithName:@"carinsurenceImage.jpg" data:data];
                    [ProviderDetails setObject:imageFilecarinsuranxcelicense forKey:@"Carinsurancelicense"];
                }
                if (medicalmalpracticeImage != nil) {
                    data = UIImageJPEGRepresentation(medicalmalpracticeImage, 0.5f);
                    PFFile *imageFilemedicalpractice = [PFFile fileWithName:@"medicalmalpracticeImage.jpg" data:data];
                    [ProviderDetails setObject:imageFilemedicalpractice forKey:@"Medicalpractice"];
                }
                
                if (userLocation) {
                    PFGeoPoint *geoLocation = [PFGeoPoint geoPointWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
                    ProviderDetails [@"location"] = geoLocation;
                } else if (currentGeoPoint) {
                    ProviderDetails [@"location"] = currentGeoPoint;
                }
                ProviderDetails[@"SubMerchantId"] = SubMerchantId;
                [ProviderDetails signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        [self dismissWaiting];
                        [[[UIAlertView alloc]initWithTitle:@"SOS Doctor" message:@"Successfully created your profile." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                        AuthorizationViewController* vc = [mainStoryboard instantiateViewControllerWithIdentifier: (IPAD_VERSION ? @"AuthorizationViewController" : @"AuthorizationViewControlleriPhone")];
                        vc.isAuthorizationPatient = FALSE;
                        [self.navigationController pushViewController:vc animated:YES];
                    } else {
                        [self dismissWaiting];
                        NSDictionary *errorDetails = [error userInfo];
                        NSString *detail=[errorDetails objectForKey:@"error"];
                        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"SOS Doctor" message:detail delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [errorAlertView show];
                    }
                }];
            }
            else
            {
                [self dismissWaiting];
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"SOS Doctor" message:SubMerchantId delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
            }
            
        } onError:^(BOOL error) {
            [self dismissWaiting];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"SOS Doctor" message:@"We are sorry, we cannot create your profile at this time. Please try later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }];
    }
}

- (IBAction)medicalSelect:(UIButton *)sender
{
    _medicalArr = [[NSMutableArray alloc]initWithObjects: @"Family Practitioner", @"Internist", @"Pediatricians", @"DO", @"Nurse NP [Practitioner]", @"PA [Physician Assistant]", @"Podiatrist", @"RN", @"Phlebotomist", @"PT [Physical Therapist]",  nil];
    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        RSPickerView *picker1 = [[RSPickerView alloc]initWithOptions:_medicalArr];
        picker1.type = RSPickerTypeStandard;
        picker1.tag = 2;
        picker1.del = self;
        _listState = FALSE;
        [picker1 showInView:self.view];
    }
    else
    {
        //medicalSpecialitytxt.text= @"Physician";
        ProblemTableViewController* problemListController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProblemTableViewControllerId"];
        problemListController.problemList = _medicalArr;
        problemListController.delegate = self;
        popoverController = [[UIPopoverController alloc] initWithContentViewController:problemListController];
        //popoverController.popoverContentSize = CGSizeMake(200, 150);
        CGRect frame = [sender.superview convertRect:medicalSpecialitytxt.frame toView:scrolView];
        [popoverController presentPopoverFromRect:frame inView:scrolView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}

- (void) showDropdown {
    _medicalArr = [[NSMutableArray alloc]initWithObjects: @"Family Practitioner", @"Internist", @"Pediatricians", @"DO", @"Nurse NP [Practitioner]", @"PA [Physician Assistant]", @"Podiatrist", @"RN", @"Phlebotomist", @"PT [Physical Therapist]",  nil];
    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        RSPickerView *picker1 = [[RSPickerView alloc]initWithOptions:_medicalArr];
        picker1.type = RSPickerTypeStandard;
        picker1.del = self;
        [picker1 showInView:self.view];
        [picker1 showInView:self.view];
    }
    else
    {
        //medicalSpecialitytxt.text= @"Physician";
        ProblemTableViewController* problemListController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProblemTableViewControllerId"];
        problemListController.problemList = _medicalArr;
        problemListController.delegate = self;
        popoverController = [[UIPopoverController alloc] initWithContentViewController:problemListController];
        [popoverController presentPopoverFromRect:medicalSpecialitytxt.frame inView:scrolView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}

-(IBAction)medicalSpecialitySelect:(id)sender
{
    [self showDropdown];
}

#pragma -mark ProblemDelegate

-(void)didSelectedProblemItem:(NSString *)problemItem
{
    medicalSpecialitytxt.text = problemItem;
    if([popoverController isPopoverVisible])
    {
        [popoverController dismissPopoverAnimated:YES];
    }
}

#pragma mark - Image Select

- (IBAction)TakePhotoClick:(id)sender
{
    UIButton *btn1=sender;
    imgNameTag= btn1.tag;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"SELECT MODEL IMAGE" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a picture",@"Choose from gallery", nil];
   	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
   	actionSheet.alpha=1.0;
   	actionSheet.tag = 1;
   	UIButton *btn = (UIButton *)sender;
    [actionSheet showFromRect:btn.frame inView:self.view animated: YES];
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
 * Show menu options add picture when user press on
 */
-(void)showMenuOptionsAddPicture:(UIButton*)sender
{
    UIActionSheet* menuOptionsActionSheet = [[UIActionSheet alloc] initWithTitle:@"Take photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo album", nil];
    [menuOptionsActionSheet showInView:self.view];
}

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

- (IBAction)TakePicture:(UIButton*)sender
{
    imgNameTag = sender.tag;
    [self showMenuOptionsAddPicture:sender];
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
        NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        
        NSString *imageName = [imagePath lastPathComponent];
        NSLog(@"%@",imageName);
        switch (imgNameTag)
        {
            case 1:
                providerImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
                [_profileButton setImage:providerImage forState:UIControlStateNormal];
                break;
            case 2:
                medicalLicensetxt.text = imageName;
                medicalLicenseImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
                [_medicalLicenseButton setImage:medicalLicenseImage forState:UIControlStateNormal];
                break;
            case 3:
                DriverLicensetxt.text = imageName;
                DriverLicenseImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
                [_DriverLicenseButton setImage:DriverLicenseImage forState:UIControlStateNormal];
                break;
            case 4:
                carinsurencetxt.text = imageName;
                carinsurenceImage=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
                [_carinsurenceButton setImage:carinsurenceImage forState:UIControlStateNormal];
                break;
            case 5:
                //medicalmalpracticetxt.text=imageName;
                medicalmalpracticetxt.text = imageName;
                medicalmalpracticeImage=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
                [_medicalmalpracticeButton setImage:medicalmalpracticeImage forState:UIControlStateNormal];
                break;
                
                
            default:
                break;
        }
        //[self performSelectorOnMainThread:@selector(showImagName:) withObject:imageName waitUntilDone:NO];
        [picker2 dismissViewControllerAnimated:YES completion:nil];
    }
}
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)showImagName:(NSString*)name
{
    if (!name || [name isEqualToString:@""]) {
        name=@"image.png";
    }
    imgNameTag=5;
}



@end
