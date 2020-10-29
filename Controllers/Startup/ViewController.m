//
//  ViewController.m
//  Doctor
//
//  Created by Thomas Woodfin on 11/16/14. 
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "ServiceUnvailableViewController.h"
#import "HelperUtils.h"
#import "PatientRequestViewController.h"
#import "ConfirmationViewController.h"

@interface ViewController () <ServiceUnvailableDelegate>

@end

@implementation ViewController

#pragma -mark Location Delegates
- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (newLocation.verticalAccuracy>0 && newLocation.verticalAccuracy < 100) {
        userLocation = newLocation;
        [locationManager stopUpdatingLocation];
        
    }
    userLocation = newLocation;
    if (userLocation) {
        PFUser* userLoggedIn = [PFUser currentUser];
        if(userLoggedIn)
        {
            PFGeoPoint *geoLocation = [PFGeoPoint geoPointWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
            userLoggedIn [@"location"] = geoLocation;
            [userLoggedIn saveInBackground];
        }
        
    }
}

- (void)viewDidLoad
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    [super viewDidLoad];
    app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [self.navigationController.navigationBar setHidden:YES];
    if(![HelperUtils isReadyForBookDoctor])
    {
//        [DSRequestDoctor sharedIntsance].operatorTime = FALSE;
//        ServiceUnvailableViewController* serviceUnavailableVC = [self.storyboard instantiateViewControllerWithIdentifier:(IPAD_VERSION ? @"ServiceUnvailableViewControlleriPad" : @"ServiceUnvailableViewControllerId")];
//        serviceUnavailableVC.delegateService = self;
//        [self presentViewController:serviceUnavailableVC animated:YES completion:nil];
        //Check logged in state
        //[DSRequestDoctor sharedIntsance].operatorTime = TRUE;
        PFUser* userLoggedIn = [PFUser currentUser];
        if(userLoggedIn)
        {
            [self showWaiting];
            NSString* kindOfUser = userLoggedIn[@"Status"];
            if([kindOfUser isEqualToString:@"Provider"])
            {
                app.isPatient = FALSE;
                [self loadRequests];
            }
            else if([kindOfUser isEqualToString:@"Patient"])
            {
                app.isPatient = TRUE;
                [self loadViewForPatient];
            }
            else
            {
                [self dismissWaiting];
            }
        }
    }
    else
    {
        //Check logged in state
        [DSRequestDoctor sharedIntsance].operatorTime = TRUE;
        PFUser* userLoggedIn = [PFUser currentUser];
        if(userLoggedIn)
        {
            [self showWaiting];
            PFInstallation* fInstall = [PFInstallation currentInstallation];
            fInstall[@"user"] = [PFUser currentUser];
            [fInstall saveInBackground];
            
            NSString* kindOfUser = userLoggedIn[@"Status"];
            if([kindOfUser isEqualToString:@"Provider"])
            {
                app.isPatient = FALSE;
                [self loadRequests];
            }
            else if([kindOfUser isEqualToString:@"Patient"])
            {
                app.isPatient = TRUE;
                [self loadViewForPatient];
            }
            else
            {
                [self dismissWaiting];
            }
        }
    }
}

-(void)ServiceUnvailableRetry
{
    //Check logged in state
    //[DSRequestDoctor sharedIntsance].operatorTime = TRUE;
    PFUser* userLoggedIn = [PFUser currentUser];
    if(userLoggedIn)
    {
        [self showWaiting];
        NSString* kindOfUser = userLoggedIn[@"Status"];
        if([kindOfUser isEqualToString:@"Provider"])
        {
            app.isPatient = FALSE;
            [self loadRequests];
        }
        else if([kindOfUser isEqualToString:@"Patient"])
        {
            app.isPatient = TRUE;
            [self loadViewForPatient];
        }
        else
        {
            [self dismissWaiting];
        }
    }
}

- (void)loadViewForPatient{
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
            confirmationViewController.comeLogin = TRUE;
            [self.navigationController pushViewController:confirmationViewController animated:YES];
        }
        else
        {
            [self loadVisitedRequestsForPatient];
        }
    }];
}

- (void)loadVisitedRequestsForPatient{
    
    PFQuery *postQuery = [PFQuery queryWithClassName:@"PatientRequest"];
    [postQuery whereKey:@"Patient" equalTo:[PFUser currentUser]];
    [postQuery whereKey:@"requestStatus" equalTo:@"FullPaid"];
    [postQuery whereKey:@"PatientVisited" equalTo:[NSNumber numberWithBool:YES]];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Action 

-(IBAction)PatientBtnClick:(id)sender
{
    UIButton *btn=sender;
    if (btn.tag==0)
    {
      app.isPatient=true;
    }
    else
    {
        app.isPatient=false;
    }
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController* vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"LoginViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
   
}

@end
