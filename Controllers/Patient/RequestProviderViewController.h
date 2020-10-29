//
//  RequestProviderViewController.h
//  doctor
//
//  Created by Thomas Woodfin on 12/8/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "AbstractViewController.h"



@interface RequestProviderViewController : AbstractViewController <UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate> {
    NSMutableArray *problems;
    UIPopoverController *popover;
    CLLocationManager *locationManager;
    CLLocation *userLocation;
    NSArray *doctors;
}
@property (strong, nonatomic) IBOutlet MKMapView *Mapview;
- (IBAction)btn_send:(id)sender;
- (IBAction)menu:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *textmapkitaddress;
@property (strong, nonatomic) IBOutlet UITextField *textlastname;
- (IBAction)dropdownlist:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *specifyissuetextview;
@property (strong, nonatomic) IBOutlet UITextField *textfieldfirstname;
@property (strong, nonatomic) IBOutlet UITextView *PleaseSpecify;
@property (strong, nonatomic) IBOutlet UIView *peoblemPickerContainerView;
- (IBAction)backbutton:(id)sender;
@property (strong, nonatomic) IBOutlet UIPickerView *problemPickerView;
@property (nonatomic, strong) NSArray *requests;

- (IBAction)leftMenu:(id)sender;


@end
