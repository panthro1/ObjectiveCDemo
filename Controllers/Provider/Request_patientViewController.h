//
//  Request_patientViewController.h
//  doctor
//
//  Created by Thomas Woodfin on 12/5/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CallOutAnnotationVifew.h"
#import "CalloutMapAnnotation.h"
#import "JingDianMapCell.h"
#import <parse/parse.h>
#import "AbstractViewController.h"
#import "MasterDetailViewController.h"
#import "PlaceAnnotation.h"
#import "TPKeyboardAvoidingScrollView.h"




@interface Request_patientViewController : AbstractViewController <UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate,UITextViewDelegate> {
    
@private
    
    NSMutableArray *problems;
    UIPopoverController *popover;
    CLLocationManager *locationManager;
    CLLocation *userLocation;
    NSString *selectedProblem;
    NSArray *doctors;
    NSMutableArray *_annotationList;
    PFUser *selectedDoctor;
    BOOL isDoctor;
    IBOutlet UIButton* _dropdownButton;
    IBOutlet UIButton* _sendButton;
    IBOutlet UIButton* _speakWithADoctor;
    IBOutlet UIButton* _currentAdderessButton;
    IBOutlet TPKeyboardAvoidingScrollView *_scrollView;
    IBOutlet UIView* pannelPatientInfo;
    IBOutlet UIView* addressView;
    IBOutlet UIButton* patientButton;
    IBOutlet UIView *_viewContent;
    IBOutlet UIButton* menuButton;
    IBOutlet UIButton* locationButton;
    
}
/*
 * define properties
 */
@property (strong, nonatomic) IBOutlet MKMapView *Mapview;
@property (strong, nonatomic) NSArray *doctors;
@property (strong, nonatomic) NSString *currentUserAddress;
@property (strong, nonatomic) IBOutlet UITextField *clientPhonenumber;
@property (strong, nonatomic) IBOutlet UITextField *FullnameTxt;
@property (strong, nonatomic) IBOutlet UIImageView *specifyissuetextview;
@property (strong, nonatomic) IBOutlet UITextView *PleaseSpecify;
@property (strong, nonatomic) IBOutlet UITextView *AgeTextView;
@property (strong, nonatomic) IBOutlet UIView *peoblemPickerContainerView;
@property (strong, nonatomic) IBOutlet UILabel *problemPickerSelected;
/*
 * Actions
 */
- (IBAction)backbutton:(id)sender;
- (IBAction)leftMenu:(id)sender;
- (IBAction)dropdownlist:(id)sender;
- (IBAction)menu:(id)sender;
-(IBAction)mapSearcAction:(id)sender;
-(void)showUserLocationInput:(id)item;


@end

