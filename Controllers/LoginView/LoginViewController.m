//
//  LoginViewController.m
//  Doctor
//
//  Created by Arora Apps 002 on 17/11/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import "LoginViewController.h"
#import "RequestProviderViewController.h"
#import "Request_patientViewController.h"
#import "PatientRequestViewController.h"
#import "ConfirmationViewController.h"
#import "ReceiptViewController.h"
#import "MBProgressHUD.h"
#import "HelperUtils.h"
#import "TSMessage.h"
#import "UIFont+FontAwesome.h"
#import "UIImage+FontAwesome.h"



@interface LoginViewController ()

@end

@implementation LoginViewController

#pragma -mark Location Delegates
- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (newLocation.verticalAccuracy>0 && newLocation.verticalAccuracy < 100) {
        userLocation = newLocation;
        [locationManager stopUpdatingLocation];
        
    }
    userLocation = newLocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    
     app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    FButil=[FacebookUtillis sharedInstance];
    FButil.delegate=self;
    self.pswtxt.delegate = self;
    self.Emailtxt.delegate = self;
    NSString* stateRemember = ([HelperUtils isRemembered] ? [NSString fontAwesomeIconStringForEnum:FACheckSquareO] : [NSString fontAwesomeIconStringForEnum:FASquareO]);
    _rememberButton.titleLabel.font = [UIFont fontAwesomeFontOfSize:(IPAD_VERSION ? 30 : 20)];
    [_rememberButton setTitle:stateRemember forState:UIControlStateNormal];
    if([HelperUtils isRemembered])
    {
        NSString* rememberInfo = [HelperUtils rememberedInfo];
        if(rememberInfo)
        {
            NSArray* compoments = [rememberInfo componentsSeparatedByString:@":Password:"];
            if(compoments.count == 2)
            {
                self.Emailtxt.text = compoments[0];
                self.pswtxt.text = compoments[1];
            }
        }
    }
    UITapGestureRecognizer* tapEvent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapEvent];
    if (!app.isPatient) {
        [_registerButton setTitle:@"Apply" forState:UIControlStateNormal];
    } else {
        [_registerButton setTitle:@"Sign up" forState:UIControlStateNormal];
    }
    [__backButton setTitle:nil forState:UIControlStateNormal];
    [__backButton setImage:[UIImage imageWithIcon:@"fa-chevron-left" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30] forState:UIControlStateNormal];
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)rememberAction:(UIButton*)sender
{
    if([_rememberButton.titleLabel.text isEqualToString:[NSString fontAwesomeIconStringForEnum:FACheckSquareO]])
    {
        [_rememberButton setTitle:[NSString fontAwesomeIconStringForEnum:FASquareO] forState:UIControlStateNormal];
    }
    else
    {
        [_rememberButton setTitle:[NSString fontAwesomeIconStringForEnum:FACheckSquareO] forState:UIControlStateNormal];
    }
}

#pragma mark - UItextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.Emailtxt)
    {
        [self.pswtxt becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Button Action 

-(void)notificationToUser {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%d",app.isPatient]] == FALSE)
    {
        if (app.isPatient)//Patient
        {
            [TSMessage showNotificationWithTitle:@"Swurvin" subtitle:@"Please do not forget to update your billing address in profile in order to book roadside assistance." type:TSMessageNotificationTypeWarning];
        }
        else //Doctor
        {
            [TSMessage showNotificationWithTitle:@"Swurvin" subtitle:@"Hello Doctor, please enter all details in profile in order to successfully be paid." type:TSMessageNotificationTypeWarning];
        }
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:[NSString stringWithFormat:@"%d",app.isPatient]];
    }
}

-(IBAction)LoginBtnClick:(id)sender
{
    if([self.Emailtxt.text isEqualToString:@""])
    {
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Swurvin" message:@"Please enter the email id" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        
        [messageAlert show];
        
        
        
        
        
    }
    else if ([self.pswtxt.text isEqualToString:@""])
    {
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Swurvin" message:@"Please enter the password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        
        [messageAlert show];
        
    }
    else {
        [self showWaiting];
            [PFUser logInWithUsernameInBackground:self.Emailtxt.text password:self.pswtxt.text block:^(PFUser *user, NSError *error) {
                if (user) {
                    //Open the wall
                    NSLog(@"%@",user);
                    if (userLocation) {
                        PFGeoPoint *geoLocation = [PFGeoPoint geoPointWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
                        user [@"location"] = geoLocation;
                        [user saveInBackground];
                    }
                    if([_rememberButton.titleLabel.text isEqualToString:[NSString fontAwesomeIconStringForEnum:FACheckSquareO]])
                    {
                        [HelperUtils setRememberLogin:[NSString stringWithFormat:@"%@:Password:%@",self.Emailtxt.text, self.pswtxt.text]];
                    }
                    else
                    {
                        [HelperUtils removeRememberLogin];
                    }
                    if (app.isPatient)
                    {
                        if ([[user valueForKey:@"Status"] isEqualToString:@"Provider"])
                        {
                            [self dismissWaiting];
                            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Wrong username/password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                            [errorAlertView show];
                            
                            return;
                        }
                        else
                        {
                            [self notificationToUser];
                            [self loadViewForPatient];
                            
                        }
                    }
                    else
                    {
                        if ([[user valueForKey:@"Status"] isEqualToString:@"Provider"])
                        {
                            [self notificationToUser];
                            [self loadRequests];
                           
                        }
                        else
                        {
                            [self dismissWaiting];
                            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Wrong username/password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                            [errorAlertView show];
                            return;
                        }

                        
                    }
                } else {
                    //Something bad has ocurred
                    [self dismissWaiting];
                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please make sure username and password are correct." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                    [errorAlertView show];
                }
              
            }];
        }
}

-(void)fillUserToInstall
{
    PFInstallation* fInstall = [PFInstallation currentInstallation];
    fInstall[@"user"] = [PFUser currentUser];
    [fInstall saveInBackground];
//    PFQuery* installQuery = [PFInstallation query];
//    NSString* objectId = [[NSUserDefaults standardUserDefaults] objectForKey:@"objectId"];
//    if(objectId)
//    {
//        [installQuery whereKey:@"objectId" equalTo:objectId];
//        [installQuery getFirstObjectInBackgroundWithBlock:^(PFObject *objects, NSError *error) {
//            if(objects > 0)
//            {
//                PFInstallation* fInstall = (PFInstallation*)objects;
//                if(fInstall &&  ![fInstall.deviceToken isEqualToString:@""])
//                {
//                    fInstall[@"user"] = [PFUser currentUser];
//                    [fInstall saveInBackground];
//                }
//            }
//        }];
//    }
}

- (void)loadViewForPatient{
    //Relate USER in PFInstall
    [self fillUserToInstall];
    NSArray* containRequestStatus = @[@"Pending", @"Accepted"];
    PFQuery *postQuery = [PFQuery queryWithClassName:@"PatientRequest"];
    [postQuery whereKey:@"Patient" equalTo:[PFUser currentUser]];
    [postQuery whereKey:@"requestStatus" containedIn:containRequestStatus];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(objects.count > 0)//Pending, show confirm accept
        {
            [self dismissWaiting];
            UIStoryboard *sb  = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ConfirmationViewController *confirmationViewController  = (ConfirmationViewController*) [sb instantiateViewControllerWithIdentifier:(IPAD_VERSION ? @"ConfirmationViewController" : @"ConfirmationViewControlleriPhone")];
            [self.navigationController pushViewController:confirmationViewController animated:YES];
        }
        else
        {
            [self loadVisitedRequestsForPatient];
        }
    }];
}

-(void)loadVisitedRequestsForPatient
{
    PFQuery *postQuery = [PFQuery queryWithClassName:@"PatientRequest"];
    [postQuery whereKey:@"Patient" equalTo:[PFUser currentUser]];
    [postQuery whereKey:@"PatientVisited" equalTo:[NSNumber numberWithBool:YES]];
    [postQuery whereKey:@"requestStatus" equalTo:@"FullPaid"];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self dismissWaiting];
        if (!error) {
            
            if ([objects count] > 0){
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                UIViewController* vc = [mainStoryboard instantiateViewControllerWithIdentifier: (IPAD_VERSION ? @"ReceiptViewController" : @"ReceiptViewControlleriPhone")];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                MasterDetailViewController* masterDetail = [self.storyboard instantiateViewControllerWithIdentifier: @"MasterDetailViewControllerId"];
                [self.navigationController pushViewController:masterDetail animated:YES];
            }
        }
    }];
}

- (void)loadRequests {
    //Relate USER in PFInstall
    [self fillUserToInstall];
    PFQuery *postQuery = [PFQuery queryWithClassName:@"PatientRequest"];
    [postQuery whereKey:@"Doctor" equalTo:[PFUser currentUser]];
    [postQuery whereKey:@"requestStatus" equalTo:@"Accepted"];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self dismissWaiting];
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



-(IBAction)RegistrationBtnClick:(id)sender
{
    if (app.isPatient)
    {
        // UI Change - Devang
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UIViewController* vc = [mainStoryboard instantiateViewControllerWithIdentifier: (IPAD_VERSION ? @"PatientViewControlleriPad" : @"PatientViewControlleriPhone")];
        //[self presentViewController:vc animated:YES completion:Nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UIViewController* vc = [mainStoryboard instantiateViewControllerWithIdentifier:(IPAD_VERSION ? @"ProviderProfileViewControlleriPad" : @"ProviderProfileViewControlleriPhone")];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(IBAction)FBBtnClick:(id)sender
{
    [self showWaiting];
     [FButil loginFacebook];
    
    if (app.isPatient)//Patient
    {
        [TSMessage showNotificationWithTitle:@"Swurvin" subtitle:@"Please do not forget to update your billing address in your profile in order to book roadside assistance." type:TSMessageNotificationTypeWarning];
    }
    else //Doctor
    {
        [TSMessage showNotificationWithTitle:@"Swurvin" subtitle:@"Hello Provider, please enter all details in profile in order to successfully be paid." type:TSMessageNotificationTypeWarning];
    }
}

-(void)facebookCallBack:(BOOL)isGranted
{
    //Show Auth
    [self dismissWaiting];
    if(isGranted)
    {
        [self fillUserToInstall];
        PFUser* user = [PFUser currentUser];
        if (userLocation) {
            PFGeoPoint *geoLocation = [PFGeoPoint geoPointWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
            user [@"location"] = geoLocation;
            
        }
        if(app.isPatient){
            user[@"Status"] = @"Patient";
            [user saveInBackground];
            [self loadViewForPatient];
        }
        else{
            user[@"Status"] = @"Provider";
            [user saveInBackground];
            [self loadRequests];
        }
    }
}

- (IBAction)resetPasswordAction:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Password reset" message:@"Please enter your email" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av show];
}
- (IBAction)resetPasswordiPad:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Password reset" message:@"Please enter your email" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        UITextField* textField = [alertView textFieldAtIndex:0];
        if(![textField.text isEqualToString:@""])
        {
            [self showWaiting];
            [PFUser requestPasswordResetForEmailInBackground:textField.text block:^(BOOL succeeded, NSError *error) {
                [self dismissWaiting];
                if(!error)
                {
                    UIAlertView* warningAlert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Email for forgot password reset is sent." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [warningAlert show];
                }
                else
                {
                    NSDictionary* userInfo = error.userInfo;
                    NSString* errorMsg = [userInfo objectForKey:@"error"];
                    if(errorMsg && ![errorMsg isEqualToString:@""])
                    {
                        UIAlertView* warningAlert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [warningAlert show];
                    }
                }
            }];
        }
    }
}


@end
