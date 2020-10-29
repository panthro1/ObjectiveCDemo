//
//  ProviderProfileViewController.h
//  Doctor
//
//  Created by Arora Apps 002 on 17/11/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSPickerView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ProviderProfileViewController : UIViewController<RSPickerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,CLLocationManagerDelegate>
{
    UIImagePickerController *picker;
    IBOutlet  UIScrollView *scrolView;
    NSInteger imgNameTag;
    
    IBOutlet UITextField *phonenumber;
    UIPickerView *picView;
    
    UIImage *medicalLicenseImage,*DriverLicenseImage,
    *carmakeImage,*carinsurenceImage,*medicalmalpracticeImage;
    UIImage *providerImage;
    
    CLLocationManager *locationManager;
    CLLocation *userLocation;
    IBOutlet UIImageView *providerImageView;
}
@property (nonatomic,retain) UIPopoverController *popoverController;
@property (strong, nonatomic) IBOutlet MKMapView *provideMapkit;

- (IBAction)doctorPhotoUpload:(id)sender;

@property(nonatomic,retain)IBOutlet UITextField *Nametxt,*medicalLicensetxt,*Addresstxt,*address2txt,*medicalSpecialitytxt,*DriverLicensetxt,*carmakeTxt,*carinsurencetxt,*medicalmalpracticetxt, *doctorTextField;
- (IBAction)MedicalLicenseUpload:(id)sender;
- (IBAction)DrivingLicenseUpload:(id)sender;
- (IBAction)CarMakeupUploadbutton:(id)sender;
- (IBAction)CarInsuranceUploadButton:(id)sender;
- (IBAction)MedicalPracticeUploadButton:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *TakePhotoMedicalLicense;
@property (strong, nonatomic) IBOutlet UILabel *UploadDriversLicense;
@property (strong, nonatomic) IBOutlet UILabel *UploadMedicalLicense;
@property (nonatomic, strong) IBOutlet UIImageView *doctorImageView;
@property (strong, nonatomic) IBOutlet UIButton *TakePhotoDriversLicense;

@property (strong, nonatomic) IBOutlet UILabel *TakePhotoCarMake;

@property (strong, nonatomic) IBOutlet UIButton *BankAccount;
@property (strong, nonatomic) IBOutlet UITextField *Username;
@property (strong, nonatomic) IBOutlet MKMapView *providerMapKit;
@property (strong, nonatomic) IBOutlet UITextField *ChosePassword;
@property (strong, nonatomic) IBOutlet UITextField *ConfirmPassword;
@property (strong, nonatomic) IBOutlet UILabel *TakePhotoInsurance;
@property (strong, nonatomic) IBOutlet UILabel *UploadCarMake;

@property (strong, nonatomic) IBOutlet UIButton *Save;

@property (strong, nonatomic) IBOutlet UILabel *UploadInsurance;

@property (strong, nonatomic) IBOutlet UILabel *TakePhotoMalpractice;

@property (strong, nonatomic) IBOutlet UITextField *providerPhoneNumber;
@property (strong, nonatomic) IBOutlet UILabel *UploadMalpractice;


@end
