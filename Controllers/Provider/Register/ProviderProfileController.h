//
//  ProviderProfileController.h
//  doctor
//
//  Created by Muhammad Imran on 12/10/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//





#import <UIKit/UIKit.h>
#import "RSPickerView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ImageCaptureView.h"
#import "MBProgressHUD.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface ProviderProfileController : BaseViewController<RSPickerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,CLLocationManagerDelegate, MKMapViewDelegate>
{
    UIImagePickerController *picker;
    IBOutlet  TPKeyboardAvoidingScrollView *scrolView;
    NSInteger imgNameTag;
    UIPickerView *picView;
    UIImage *medicalLicenseImage,*DriverLicenseImage,
    *carmakeImage,*carinsurenceImage,*medicalmalpracticeImage;
    UIImage *providerImage;
    CLLocationManager *locationManager;
    CLLocation *userLocation;
    IBOutlet UIButton* _backButton;
    //Personal profile
    IBOutlet UITextField *_firstNameTextField;
    IBOutlet UITextField* _lastNameTextField;
    IBOutlet UITextField* _emailAddressTextField;
    IBOutlet UITextField *phonenumber;
    IBOutlet UITextField *otherphonenumbertxt;
    IBOutlet UITextField *usernametxt;
    IBOutlet UITextField *passowordtxt;
    IBOutlet UITextField *confirmpassowordtxt;
    IBOutlet UITextField *statetxt;
    IBOutlet UITextField *zipcodetxt;
    IBOutlet UIButton* _profileButton;
    IBOutlet UITextField *_dateofbirthTextField;
    IBOutlet UITextField *_streetAddressTextField;
    IBOutlet UITextField *_ssnTextField;
    IBOutlet UITextField *_postcodeTextField;
    IBOutlet UITextField *_regionTextField;
    IBOutlet UITextField *_localcityTextField;
    //Professional profile
    IBOutlet UITextField *medicalLicensetxt;
    IBOutlet UIButton* _medicalLicenseButton;
    IBOutlet UITextField *Addresstxt;
    IBOutlet UITextField *medicalSpecialitytxt;
    IBOutlet UITextField *DriverLicensetxt;
    IBOutlet UIButton* _DriverLicenseButton;
    IBOutlet UITextField *medicalmalpracticetxt;
    IBOutlet UIButton* _medicalmalpracticeButton;
    IBOutlet UITextField *carinsurencetxt;
    IBOutlet UIButton* _carinsurenceButton;
    //Bank
    IBOutlet UITextField *banknametxt;
    IBOutlet UITextField *routingNumbertxt;
    IBOutlet UITextField *accountnumbertxt;
    IBOutlet UITextField *accountholdertxt;
    NSArray* listState;
    BOOL _listState;
}
//Properties
@property (nonatomic,retain) UIPopoverController *popoverController;
@property (strong, nonatomic) IBOutlet UIButton *Save;
//Methods
- (IBAction)TakePicture:(UIButton*)sender;
- (IBAction)back:(id)sender;
- (IBAction)stateList:(id)sender;

@end

