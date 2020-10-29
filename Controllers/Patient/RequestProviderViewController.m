//
//  RequestProviderViewController.m
//  doctor
//
//  Created by Thomas Woodfin on 12/8/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import "RequestProviderViewController.h"
#import <parse/parse.h>
#import <Corelocation/CLGeocoder.h>
#import <Corelocation/CLPlacemark.h>
#import <AddressBook/AddressBook.h>

@interface RequestProviderViewController ()

@end

@implementation RequestProviderViewController

-(void)tapDismissKeyboard
{
    [self.view endEditing:YES];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer* tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismissKeyboard)];
    [self.view addGestureRecognizer:tapView];
    self.problemPickerView.delegate = self;
    self.problemPickerView.dataSource = self;
    [self.peoblemPickerContainerView removeFromSuperview];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
}



#pragma -mark Location Delegates
- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (newLocation.verticalAccuracy>0 && newLocation.verticalAccuracy < 100) {
        userLocation = newLocation;
        [locationManager stopUpdatingLocation];
        [self getUserCurrentLocation];
    }
    
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
    UIAlertView *alertView  = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There is some problem with location service" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    
}

- (void)getUserCurrentLocation {
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    if (reverseGeocoder) {
        [reverseGeocoder reverseGeocodeLocation:userLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                NSString *addressString  = placemark.locality;
                NSLog(@"%@", addressString);
            }
            
        }];
    }
    
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


- (IBAction)btn_send:(id)sender {
}


- (IBAction)menu:(id)sender
{
    [self toogleMasterView:nil];
}

- (IBAction)dropdownlist:(id)sender {
    UIViewController *pickerContainerViewController  = [[UIViewController alloc] init];
    self.peoblemPickerContainerView.frame = CGRectMake(0, 0, 320, 320);
    pickerContainerViewController.contentSizeForViewInPopover = CGSizeMake(320, 320);
    [pickerContainerViewController.view addSubview:self.peoblemPickerContainerView];
    
    popover=[[UIPopoverController alloc]initWithContentViewController:pickerContainerViewController];
    UIButton *btn= (UIButton *) sender;
    [popover presentPopoverFromRect:btn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
    }
- (IBAction)backbutton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)leftMenu:(id)sender {
    [self toogleMasterView: sender];
   
}
@end





