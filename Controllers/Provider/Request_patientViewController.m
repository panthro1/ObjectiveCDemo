//
//  Request_patientViewController.m
//  doctor
//
//  Created by Thomas Woodfin on 12/5/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import "Request_patientViewController.h"
#import <parse/parse.h>
#import <Corelocation/CLGeocoder.h>
#import <Corelocation/CLPlacemark.h>
#import <AddressBook/AddressBook.h>
#import "ConfirmationViewController.h"
#import "HelperUtils.h"
#import "JPSThumbnailAnnotation.h"
#import "LeftViewController.h"
#import "ProblemTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "RSPickerView.h"


#define span 40000
@interface Request_patientViewController ()<ProblemListDelegate, RSPickerDelegate> {
    NSMutableArray* providerTypes;
    BOOL hasProviderType;
}

@property(nonatomic, strong) UIPopoverController* ProblemPopOver;
@property (weak, nonatomic) IBOutlet UILabel *ineedButton;


@end


@implementation Request_patientViewController
@synthesize ProblemPopOver;
@synthesize doctors;
@synthesize currentUserAddress;

-(void)tapDismissKeyboard
{
    [self.view endEditing:YES];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Please Enter Your Age"] || [textView.text isEqualToString:@"Additional Information"])
    {
        textView.text = @"";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([UIScreen mainScreen].bounds.size.height != 480) {
        CGRect frame = _viewContent.frame;
        if ([UIScreen mainScreen].bounds.size.height == 568) {
            frame.origin.y = 30;
        } else {
            frame.origin.y = 50;
        }
        frame.size.width = [UIScreen mainScreen].bounds.size.width;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        _viewContent.frame = frame;
    }
    [_viewContent sizeToFit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [financialButton setTitle:nil forState:UIControlStateNormal];
    [financialButton setImage:[UIImage imageWithIcon:@"fa-chevron-left" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30] forState:UIControlStateNormal];
    [menuButton setImage:MENU_ICO forState:UIControlStateNormal];
    [locationButton setBackgroundImage:nil forState:UIControlStateNormal];
    [locationButton setImage:MARKER_ICO forState:UIControlStateNormal];
    providerTypes = [[NSMutableArray alloc]initWithObjects:@"I need", @"Jump Start", @"Flat Tire", @"Tow", @"Lock-Out",  nil];
    UITapGestureRecognizer* tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismissKeyboard)];
    [self.view addGestureRecognizer:tapView];
    PFUser *patientsDetails = [PFUser currentUser];
    self.FullnameTxt.text = patientsDetails [@"Name"];
    self.clientPhonenumber.text = patientsDetails [@"CellPhoneNumber"];
    self.peoblemPickerContainerView.hidden=YES;
    self.PleaseSpecify.delegate=self;
    problems = [[NSMutableArray alloc] init];
    [problems addObject:@""];
    [problems addObject:@"Vehicle will not start"];
    [problems addObject:@"Over Heating"];
    [problems addObject:@"No Power"];
    [problems addObject:@"Tire is Flat"];
    [problems addObject:@"Noises seem Unsafe"];
    [problems addObject:@"Difficulty Shifting Gears"];
    [problems addObject:@"Wheel Feels Lose"];[problems addObject:@"Other"];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    [self.Mapview setShowsUserLocation:YES];
    _Mapview.layer.masksToBounds = YES;
    _Mapview.layer.cornerRadius = 5;
    if(doctors.count > 0)
    {
        selectedDoctor = [doctors lastObject];
        [self setAnnotionsWithList:doctors];
    }
    [_currentAdderessButton setTitle:currentUserAddress forState:UIControlStateNormal];
    [_scrollView contentSizeToFit];
    if (IPAD_VERSION) {
        _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 990);
    } else {
        _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 650);
    }
    
    UITapGestureRecognizer* problemTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropdownlist:)];
    _problemPickerSelected.userInteractionEnabled = YES;
    [_problemPickerSelected addGestureRecognizer:problemTap];
    
    UITapGestureRecognizer* providerTypeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onNeedDoctorClicked:)];
    _ineedButton.userInteractionEnabled = YES;
    [_ineedButton addGestureRecognizer:providerTypeTap];
    
    //Config UI
    [self setTextFieldBorder:_FullnameTxt];
    [self setViewBorder:addressView];
    [self setViewBorder:_problemPickerSelected];
    [self setViewBorder:_PleaseSpecify];
    [self setViewBorder:_AgeTextView];
    patientButton.layer.masksToBounds = TRUE;
    patientButton.layer.cornerRadius = 10;
    patientButton.layer.borderColor = [UIColor colorWithRed:19/255.0 green:28/255.0 blue:37/255.0 alpha:1].CGColor;
    patientButton.layer.borderWidth = 1.0;
    patientButton.backgroundColor = [UIColor clearColor];
    pannelPatientInfo.layer.masksToBounds = TRUE;
    pannelPatientInfo.layer.cornerRadius = 5;
    
    addressView.layer.masksToBounds = TRUE;
    addressView.layer.cornerRadius = 10;
    addressView.layer.borderColor = [UIColor colorWithRed:19/255.0 green:28/255.0 blue:37/255.0 alpha:1].CGColor;
    addressView.layer.borderWidth = 1.0;
    addressView.backgroundColor = [UIColor clearColor];
    _FullnameTxt.layer.masksToBounds = TRUE;
    _FullnameTxt.layer.cornerRadius = 10;
    _FullnameTxt.layer.borderColor = [UIColor colorWithRed:19/255.0 green:28/255.0 blue:37/255.0 alpha:1].CGColor;
    _FullnameTxt.layer.borderWidth = 1.0;
    _FullnameTxt.backgroundColor = [UIColor clearColor];
    
    _ineedButton.layer.masksToBounds = TRUE;
    _ineedButton.layer.cornerRadius = 10;
    _ineedButton.layer.borderColor = [UIColor colorWithRed:19/255.0 green:28/255.0 blue:37/255.0 alpha:1].CGColor;
    _ineedButton.layer.borderWidth = 1.0;
    _ineedButton.backgroundColor = [UIColor clearColor];
    
    _problemPickerSelected.layer.masksToBounds = TRUE;
    _problemPickerSelected.layer.cornerRadius = 10;
    _problemPickerSelected.layer.borderColor = [UIColor colorWithRed:19/255.0 green:28/255.0 blue:37/255.0 alpha:1].CGColor;
    _problemPickerSelected.layer.borderWidth = 1.0;
    _problemPickerSelected.backgroundColor = [UIColor clearColor];
    _AgeTextView.layer.masksToBounds = TRUE;
    _AgeTextView.layer.cornerRadius = 10;
    _AgeTextView.layer.borderColor = [UIColor colorWithRed:19/255.0 green:28/255.0 blue:37/255.0 alpha:1].CGColor;
    _AgeTextView.layer.borderWidth = 1.0;
    _AgeTextView.backgroundColor = [UIColor clearColor];
    _PleaseSpecify.layer.masksToBounds = TRUE;
    _PleaseSpecify.layer.cornerRadius = 10;
    _PleaseSpecify.layer.borderColor = [UIColor colorWithRed:19/255.0 green:28/255.0 blue:37/255.0 alpha:1].CGColor;
    _PleaseSpecify.layer.borderWidth = 1.0;
    _PleaseSpecify.backgroundColor = [UIColor clearColor];
    _sendButton.layer.masksToBounds = TRUE;
    _sendButton.layer.cornerRadius = 10;
    _sendButton.layer.borderColor = [UIColor colorWithRed:19/255.0 green:28/255.0 blue:37/255.0 alpha:1].CGColor;
    _sendButton.layer.borderWidth = 1.0;
    _speakWithADoctor.layer.masksToBounds = TRUE;
    _speakWithADoctor.layer.cornerRadius = 10;
    _speakWithADoctor.layer.borderColor = [UIColor colorWithRed:19/255.0 green:28/255.0 blue:37/255.0 alpha:1].CGColor;
    _speakWithADoctor.layer.borderWidth = 1.0;
}

-(void) setTextFieldBorder:(UIControl*)control
{
    control.backgroundColor = [UIColor whiteColor];
    control.layer.cornerRadius = 5;
    control.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
    control.layer.masksToBounds = YES;
}

-(void) setViewBorder:(UIView*)view
{
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
}

#pragma -mark Location Delegates
- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (newLocation.verticalAccuracy>0 && newLocation.verticalAccuracy < 500) {
        userLocation = newLocation;
        [locationManager stopUpdatingLocation];
    }
    userLocation = newLocation;
    [locationManager stopUpdatingLocation];
}

-(void)showUserLocationInput:(id)item
{
    MKMapItem *mapItem = item;
    
    
    self.title = mapItem.name;
    
    // add the single annotation to our map
    PlaceAnnotation *annotation = [[PlaceAnnotation alloc] init];
    annotation.coordinate = mapItem.placemark.location.coordinate;
    annotation.title = mapItem.name;
    annotation.url = mapItem.url;
    [self.Mapview addAnnotation:annotation];
    
    // we have only one annotation, select it's callout
    [self.Mapview selectAnnotation:[self.Mapview.annotations objectAtIndex:0] animated:YES];
    
    // center the region around this map item's coordinate
    self.Mapview.centerCoordinate = mapItem.placemark.coordinate;
    userLocation = mapItem.placemark.location;
    [self fetchDoctors];
    
}

-(IBAction)mapSearcAction:(id)sender
{
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if ( [[UIDevice currentDevice].systemVersion floatValue] < 8.0 ) {
        [locationManager startUpdatingLocation];
    }
    else
    {
        if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
            [locationManager requestAlwaysAuthorization];
        } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
            [locationManager  requestWhenInUseAuthorization];
        } else {
            NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    UIAlertView *alertView  = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There is some problem with location service" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alertView show];
    
}

- (void)fetchDoctors {
    PFQuery *query = [PFUser query];
    [query whereKey:@"Status" equalTo:@"Provider"];
    PFGeoPoint *userGeoPoint = [PFGeoPoint geoPointWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
    [query whereKey:@"location" nearGeoPoint:userGeoPoint];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            doctors = objects;
            if(doctors.count > 0)
            {
                [self setAnnotionsWithList:doctors];
            }
            else
            {
                UIAlertView* alertNoDoctor = [[UIAlertView alloc] initWithTitle:@"We're sorry, but the address you selected is out of our coverage area." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertNoDoctor show];
            }
            
            NSLog(@"%@", objects);
        } else {
            
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    NSString* latLng = [NSString stringWithFormat:@"%f,%f", userLocation.coordinate.latitude, userLocation.coordinate.longitude];
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.mycompany.myqueue", 0);
    dispatch_async(backgroundQueue, ^{
        NSString* address = [self getAddressFromLatLong:latLng];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray* compoments = [address componentsSeparatedByString:@","];
            if(compoments.count > 1)
            {
                [_currentAdderessButton setTitle:[NSString stringWithFormat:@"%@, %@",compoments[0], compoments[1]] forState:UIControlStateNormal];
            }
            else if(compoments.count == 1)
            {
                [_currentAdderessButton setTitle:[NSString stringWithFormat:@"%@",compoments[0]] forState:UIControlStateNormal];
            }
            
        });
    });
    
}

-(NSString*)getAddressFromLatLong : (NSString *)latLng {
    
    NSString *esc_addr =  [latLng stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=true&latlng=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    NSMutableDictionary *data = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding]options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *dataArray = (NSMutableArray *)[data valueForKey:@"results" ];
    if (dataArray.count == 0) {
        return @"Nothing to show";
    }else{
        for (id firstTime in dataArray) {
            NSString *jsonStr1 = [firstTime valueForKey:@"formatted_address"];
            return jsonStr1;
        }
    }
    
    return nil;
}

#pragma -mark Picker Delegates

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [problems count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [problems objectAtIndex:row];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_send:(id)sender {
    
    if (selectedProblem == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please Select Your Problem" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil
        ];
        [alert show];
    }
    else if(selectedProblem)// can request doctor
    {
        if ([_PleaseSpecify.text isEqualToString:@"Additional Information"] || [_PleaseSpecify.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please enter Additional Information." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if([_AgeTextView.text isEqualToString:@"Please Enter Your Age"] || [_AgeTextView.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please enter Your age." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil
                                  ];
            [alert show];
        }
        else if([_ineedButton.text.lowercaseString isEqualToString:@"I need".lowercaseString] || [_ineedButton.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please select Doctor Type." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil
                                  ];
            [alert show];
        }
        else {
            if ( doctors.count <= 0 ) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"We are sorry but all of our Tow Trucks are currently unavailable.  Please check back in a few minutes." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else {
                [self bookNow:_ineedButton.text];
            }
        }
    }
}

- (IBAction)btn_speakWithADoctor:(id)sender {
    
    if (selectedProblem == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please Select Your Problem" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil
                              ];
        [alert show];
    }
    else if(selectedProblem)// can request doctor
    {
        if ([_PleaseSpecify.text isEqualToString:@"Additional Information"] || [_PleaseSpecify.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please enter Additional Information." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if([_AgeTextView.text isEqualToString:@"Please Enter Your Age"] || [_AgeTextView.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please enter Your age." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil
                                  ];
            [alert show];
        }
        else {
            if ( doctors.count <= 0 ) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"We are sorry but all of our Tow Trucks are currently unavailable.  Please check back in a few minutes." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else {
                [self speakWithADoctor:_ineedButton.text];
            }
        }
    }
}

- (void) speakWithADoctor:(NSString*) medicalSpeciality {
    
    @try
    {
        PFQuery *postQuery = [PFQuery queryWithClassName:@"PatientRequest"];
        [postQuery whereKey:@"Patient" equalTo:[PFUser currentUser]];
        [postQuery whereKey:@"requestStatus" equalTo:@"Accepted"];
        [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(objects.count > 0)//Pending, show confirm accept
            {
                for (PFObject* object in objects)
                {
                    [object deleteInBackground];
                }
            }
            
        }];
        //Send request to all doctor in the same area (30 miles radian)
        PFUser *patientsDetails = [PFUser currentUser];
        [self showWaiting];
        __block int i = 0;
        long groupId =  arc4random();
        for (PFUser* doctor in doctors)
        {
            PFObject *patientRequest = [PFObject objectWithClassName:@"PatientRequest"];
            [patientRequest setObject:doctor forKey:@"Doctor"];
            [patientRequest setObject:patientsDetails forKey:@"Patient"];
            [patientRequest setObject:[NSDate date] forKey:@"RequestDate"];
            patientRequest[@"groupRequest"] = [NSString stringWithFormat:@"%ld", groupId];
            patientRequest[@"Name"] = self.FullnameTxt.text;
            patientRequest[@"requestStatus"] = @"Pending";
            patientRequest[@"Age"] = _AgeTextView.text;
            patientRequest[@"Problem"] = selectedProblem;
            patientRequest[@"DoctorType"] = medicalSpeciality;
            patientRequest[@"ProblemDetail"] = self.PleaseSpecify.text;
            patientRequest[@"patientrequestaddress"] = self.currentUserAddress;
            patientRequest[@"CellPhoneNumber"] = (patientsDetails [@"CellPhoneNumber"] ? patientsDetails [@"CellPhoneNumber"] : @"");
            patientRequest[@"speakWithADoctor"] = @"TRUE";
            patientRequest[@"doctorNow"] = isDoctor ? @"YES" : @"NO";
            //NSUserDefaults* udf = [NSUserDefaults standardUserDefaults];
            //[udf setObject:medialSpeciality forKey:@"medicalSpeciality"];
            //[udf synchronize];
            if (userLocation) {
                PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
                patientRequest[@"Location"] = point;
            }
            [patientRequest saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"Patient Data Saved");
                i++;
                if(i == doctors.count)
                {
                    [TSMessage showNotificationWithTitle:@"Swurvin" subtitle:@"Congratulations! Your Doctor Will Come See You Soon." type:TSMessageNotificationTypeWarning];
                    //Todo: make a push notification to all doctors in 30 miles
                    [self sendNotificationToDoctorsByDoctorType:medicalSpeciality speaker:TRUE];
                    [self dismissWaiting];
                    UIStoryboard *sb  = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ConfirmationViewController *confirmationViewController  = (ConfirmationViewController*) [sb instantiateViewControllerWithIdentifier:(IPAD_VERSION ? @"ConfirmationViewController" : @"ConfirmationViewControlleriPhone")];
                    [self.navigationController pushViewController:confirmationViewController animated:YES];
                }
            }];
        }
    }
    @catch (NSException *exception)
    {
        UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"We are sorry, we can't request Tow Trucks at this time. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [errorAlert show];
    }
    @finally {
        
    }
}

/*
 * Discussion
 *
 * Booking a doctor based on type of doctor. There are type such as Pediatrician, Family Practitioner
 */

- (void) bookNow:(NSString*) medicalSpeciality {
    
    @try
    {
        PFQuery *postQuery = [PFQuery queryWithClassName:@"PatientRequest"];
        [postQuery whereKey:@"Patient" equalTo:[PFUser currentUser]];
        [postQuery whereKey:@"requestStatus" equalTo:@"Accepted"];
        [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(objects.count > 0)//Pending, show confirm accept
            {
                for (PFObject* object in objects)
                {
                    [object deleteInBackground];
                }
            }
            
        }];
        //Send request to all doctor in the same area (30 miles radian)
        PFUser *patientsDetails = [PFUser currentUser];
        [self showWaiting];
        __block int i = 0;
        long groupId =  arc4random();
        for (PFUser* doctor in doctors)
        {
            PFObject *patientRequest = [PFObject objectWithClassName:@"PatientRequest"];
            [patientRequest setObject:doctor forKey:@"Doctor"];
            [patientRequest setObject:patientsDetails forKey:@"Patient"];
            [patientRequest setObject:[NSDate date] forKey:@"RequestDate"];
            patientRequest[@"groupRequest"] = [NSString stringWithFormat:@"%ld", groupId];
            patientRequest[@"Name"] = self.FullnameTxt.text;
            patientRequest[@"requestStatus"] = @"Pending";
            patientRequest[@"Age"] = _AgeTextView.text;
            patientRequest[@"Problem"] = selectedProblem;
            patientRequest[@"DoctorType"] = medicalSpeciality;
            patientRequest[@"ProblemDetail"] = self.PleaseSpecify.text;
            patientRequest[@"patientrequestaddress"] = self.currentUserAddress;
            patientRequest[@"CellPhoneNumber"] = (patientsDetails [@"CellPhoneNumber"] ? patientsDetails [@"CellPhoneNumber"] : @"");
            patientRequest[@"doctorNow"] = isDoctor ? @"YES" : @"NO";
            //NSUserDefaults* udf = [NSUserDefaults standardUserDefaults];
            //[udf setObject:medialSpeciality forKey:@"medicalSpeciality"];
            //[udf synchronize];
            if (userLocation) {
                PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
                patientRequest[@"Location"] = point;
            }
            [patientRequest saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"Patient Data Saved");
                i++;
                if(i == doctors.count)
                {
                    [TSMessage showNotificationWithTitle:@"Swurvin" subtitle:@"Congratulations! Your Doctor Will Come See You Soon." type:TSMessageNotificationTypeWarning];
                    //Todo: make a push notification to all doctors in 30 miles
                    [self sendNotificationToDoctorsByDoctorType:medicalSpeciality speaker:FALSE];
                    
                    [self dismissWaiting];
                    UIStoryboard *sb  = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ConfirmationViewController *confirmationViewController  = (ConfirmationViewController*) [sb instantiateViewControllerWithIdentifier:(IPAD_VERSION ? @"ConfirmationViewController" : @"ConfirmationViewControlleriPhone")];
                    [self.navigationController pushViewController:confirmationViewController animated:YES];
                }
            }];
        }
    }
    @catch (NSException *exception)
    {
        UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"We are sorry, we can't request Tow Trucks at this time. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [errorAlert show];
    }
    @finally {
        
    }
}

-(void)sendNotificationToDoctorsByDoctorType:(NSString*) doctorType speaker:(BOOL) speaker
{
    
    PFPush* push = [[PFPush alloc] init];
    //Query User
    PFGeoPoint* geoPoint = [PFGeoPoint geoPointWithLocation:userLocation];
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"Status" equalTo:@"Provider"];//Only Doctors
    [userQuery whereKey:@"isHideMap" equalTo:[NSNumber numberWithBool:FALSE]];//Only Doctors
    [userQuery whereKey:@"location" nearGeoPoint:geoPoint withinMiles:60.0];//60 miles
    //Query Install
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"user" matchesQuery:userQuery];
    NSDictionary* data;
    if(!speaker) {
        data = [NSDictionary dictionaryWithObjectsAndKeys:@"Patient has requested service.  Please accept.", @"alert", @"default", @"sound", nil];
    } else {
        data = [NSDictionary dictionaryWithObjectsAndKeys:@" Patient needs to speak with a Doctor.", @"alert", @"default", @"sound", nil];
    }
    [push setData:data];
    [push setQuery:pushQuery];
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *  error) {
        if(!error)
        {
            NSLog(@"Sent notification");
        }
        else
        {
            NSLog(@"Sent notification fail");
        }
    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    return YES;
}

- (IBAction)menu:(id)sender {
}

- (IBAction)dropdownlist:(id)sender {
    hasProviderType = FALSE;
    if (!(IPAD_VERSION)) {
        RSPickerView *picker1 = [[RSPickerView alloc]initWithOptions:problems];
        picker1.type = RSPickerTypeStandard;
        picker1.del = self;
        [picker1 showInView:self.view];
    }
    else {
        ProblemTableViewController* problemListController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProblemTableViewControllerId"];
        problemListController.problemList = problems;
        problemListController.delegate = self;
        ProblemPopOver = [[UIPopoverController alloc] initWithContentViewController:problemListController];
        //ProblemPopOver.popoverContentSize = CGSizeMake(_ineedButton.frame.size.width, ProblemPopOver.popoverContentSize.height);
        [ProblemPopOver presentPopoverFromRect:_problemPickerSelected.frame  inView:_problemPickerSelected.superview  permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        
    }
    
}

#pragma -mark ProblemTableView delegate

-(void)didSelectedProblemItem:(NSString *)problemItem
{
    if(hasProviderType == FALSE) {
        if([ProblemPopOver isPopoverVisible])
        {
            [ProblemPopOver dismissPopoverAnimated:YES];
        }
        selectedProblem = problemItem;
        self.problemPickerSelected.text = problemItem;
    } else {
        if([ProblemPopOver isPopoverVisible])
        {
            [ProblemPopOver dismissPopoverAnimated:YES];
        }
        self.ineedButton.text = problemItem;
    }
    
}

-(void)RSPicker:(RSPickerView *)picker didDismissWithSelection:(id)selection inTextField:(UITextField *)textField Response:(NSString *)response
{
    if(hasProviderType) {
        _ineedButton.text = response;
    } else {
        selectedProblem = response;
        self.problemPickerSelected.text = response;
    }
}


- (IBAction)backbutton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma - mark Map

-(void)setAnnotionsWithList:(NSArray *)list
{
    NSMutableArray *anotations = [[NSMutableArray alloc] init];
    for (PFUser *doctor in list) {
        
        // User's location
        PFGeoPoint *userGeoPoint = doctor[@"location"];
        CLLocationDegrees latitude=userGeoPoint.latitude ;
        CLLocationDegrees longitude=userGeoPoint.longitude;
        CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
        
        MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location,span ,span );
        MKCoordinateRegion adjustedRegion = [self.Mapview regionThatFits:region];
        [self.Mapview setRegion:adjustedRegion animated:YES];
        JPSThumbnail *anotation = [[JPSThumbnail alloc] init];
        anotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        anotation.doctor = doctor;
        anotation.pinColor = MKPinAnnotationColorGreen;
        anotation.disclosureBlock = ^{

            selectedDoctor = anotation.doctor;
        };
        [anotations addObject:[JPSThumbnailAnnotation annotationWithThumbnail:anotation]];
    }
    [self.Mapview addAnnotations:anotations];
}



#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
}


- (IBAction)leftMenu:(id)sender {
    
    [self toogleMasterView:sender];
}

-(IBAction)patientInfoAction:(id)sender
{
    if(pannelPatientInfo.hidden)
    {
        pannelPatientInfo.hidden = NO;
        pannelPatientInfo.frame = CGRectMake(pannelPatientInfo.frame.origin.x, pannelPatientInfo.frame.origin.y, pannelPatientInfo.frame.size.width, 0);
        [UIView animateWithDuration:.2f delay:0.0f options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            pannelPatientInfo.frame = CGRectMake(pannelPatientInfo.frame.origin.x, pannelPatientInfo.frame.origin.y, pannelPatientInfo.frame.size.width, 102);
        } completion:^(BOOL finished)
         {
         }];
    }
    else
    {
        pannelPatientInfo.alpha = 1;
        [UIView animateWithDuration:.2f delay:0.0f options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            pannelPatientInfo.frame = CGRectMake(pannelPatientInfo.frame.origin.x, pannelPatientInfo.frame.origin.y, pannelPatientInfo.frame.size.width, 0);
        } completion:^(BOOL finished)
         {
             pannelPatientInfo.hidden = YES;
         }];
    }
    
}

- (IBAction)onNeedDoctorClicked:(id)sender {
    hasProviderType = TRUE;
    if (!(IPAD_VERSION)) {
        RSPickerView *picker1 = [[RSPickerView alloc]initWithOptions:providerTypes];
        picker1.tag = 2;
        picker1.type = RSPickerTypeStandard;
        picker1.del = self;
        [picker1 showInView:self.view];
    }
    else {
        ProblemTableViewController* problemListController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProblemTableViewControllerId"];
        problemListController.problemList = providerTypes;
        problemListController.delegate = self;
        ProblemPopOver = [[UIPopoverController alloc] initWithContentViewController:problemListController];
        [ProblemPopOver presentPopoverFromRect:_ineedButton.frame inView:_ineedButton.superview permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        
    }
}

@end
