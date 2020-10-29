//
//  ConfirmationViewController.m
//  doctor
//
//  Created by Thomas Woodfin on 12/7/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import "ConfirmationViewController.h"
#import "MasterDetailViewController.h"
#import "ConfirmationMessageViewController.h"
#import "MBProgressHUD.h"



#define kPayPalEnvironment PayPalEnvironmentProduction

@interface ConfirmationViewController ()
{
    NSTimer* _waitingAcceptTimer;
    NSTimer* _cancelRequestTimer;
    double bookingFee;
    double totalPrice;
    PFGeoPoint* currentGeopoint;
    PulsingHaloLayer *pulseAnimation;
}
@property (weak, nonatomic) IBOutlet UIImageView *drLicenseImageView;

@end

@implementation ConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ratingDoctor.userInteractionEnabled = NO;
    _acceptButton.enabled = FALSE;
    _autoCancelRequestLbl.hidden = TRUE;
    self.doctorName.text = @"";
    self.messageLabel.text = @"";
    self.messageLabel.text = @"SEARCHING FOR YOUR DOCTOR...";
    if([DSRequestDoctor sharedIntsance].operatorTime == TRUE)//Day
    {
        bookingFee = 5;//50;
        totalPrice = 0;//275;
    }
    else//night
    {
        bookingFee = 8;//75;
        totalPrice = 0;//375;
    }
    _priceLabel.text = @"";//[NSString stringWithFormat:@"When you accept a $%.f confirmation deposit will be charged", bookingFee];
//    _priceLabel.text = [NSString stringWithFormat:@"Price for this visit is $%.f- When you accept a $%.f confirmation deposit will be charged",totalPrice, bookingFee];
     [self getDoctorRequest];
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getDoctorRequest) userInfo:nil repeats:YES];
    //Doctor response timer
    _waitingAcceptTimer = [NSTimer scheduledTimerWithTimeInterval:3*60 target:self selector:@selector(checkDoctorResponseOnPatientRequest) userInfo:nil repeats:YES];
    [financialButton setTitle:nil forState:UIControlStateNormal];
    [financialButton setImage:[UIImage imageWithIcon:@"fa-chevron-left" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30] forState:UIControlStateNormal];
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        currentGeopoint = geoPoint;
    }];
    
    pulseAnimation = [PulsingHaloLayer layer];
    pulseAnimation.haloLayerNumber = 5;
    pulseAnimation.position = self.view.center;
    [self.view.layer addSublayer:pulseAnimation];
    [pulseAnimation start];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [timer invalidate];
    [_waitingAcceptTimer invalidate];
}

/*
 * Find a doctor to respond within 3 minutes
 */

-(void)checkDoctorResponseOnPatientRequest {
    [_waitingAcceptTimer invalidate];
    UIAlertView* warningDoctor = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"No Tow Trucks available at this time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [warningDoctor show];
}

/**
 * Send Cancel notitifcation to doctor
 */
-(void)sendNotificationToDoctors:(PFObject*)doctor1{
    PFPush* push = [[PFPush alloc] init];
    //Query User
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"objectId" equalTo:doctor1.objectId];
    //Query Install
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"user" matchesQuery:userQuery];
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:@"Hello Doctor, the patient has cancelled this request for service.", @"alert", @"default", @"sound", nil];
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

-(void)sendNotificationToDoctors
{
    if (currentGeopoint) {
        PFPush* push = [[PFPush alloc] init];
        //Query User
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:@"Status" equalTo:@"Provider"];//Only Doctors
        [userQuery whereKey:@"isHideMap" equalTo:[NSNumber numberWithBool:FALSE]];//Only Doctors
        [userQuery whereKey:@"location" nearGeoPoint:currentGeopoint withinMiles:60.0];//60 miles
        //Query Install
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"user" matchesQuery:userQuery];
        NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:@"Hello Tow Trucks, the patient has cancelled this request for service.", @"alert", @"default", @"sound", nil];
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
}

/*
 * Find a doctor to respond within 3 minutes
 */

-(void)automaticallyCancelRequest
{
    if(doctor)
    {
        NSArray* containIn = @[@"Accepted"];
        PFQuery *postQuery = [PFQuery queryWithClassName:@"PatientRequest"];
        [postQuery whereKey:@"Patient" equalTo:[PFUser currentUser]];
        [postQuery whereKey:@"requestStatus" containedIn:containIn];
        [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if(objects.count > 0)
                {
                    __block int i = 0;
                    for (PFObject* objectDelete in objects)
                    {
                        [objectDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                            i++;
                            if(i == objects.count)
                            {
                                [self sendNotificationToDoctors:doctor];
                                //[_cancelRequestTimer invalidate];
                                //_cancelRequestTimer = nil;
                                MasterDetailViewController* masterDetail = [self.storyboard instantiateViewControllerWithIdentifier: @"MasterDetailViewControllerId"];
                                [self.navigationController pushViewController:masterDetail animated:YES];
                            }
                        }];
                    }
                }
            }
        }];
    }
}

-(void)getDoctorRequest
{
    if([self.messageLabel.text isEqualToString:@"SEARCHING FOR YOUR PROVIDER..."])
    {
        @try
        {
            //NSUserDefaults* udf = [NSUserDefaults standardUserDefaults];
            //NSString* medicalSpeciality = [udf objectForKey:@"medicalSpeciality"];
            
            PFQuery *postQuery = [PFQuery queryWithClassName:@"PatientRequest"];
            [postQuery whereKey:@"Patient" equalTo:[PFUser currentUser]];
            [postQuery whereKey:@"requestStatus" equalTo:@"Accepted"];
//            if (medicalSpeciality) {
//                [postQuery whereKey:@"medicalSpeciality" equalTo:medicalSpeciality];
//            }
            [postQuery includeKey:@"Doctor"];
            [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(objects.count > 0)//Pending, show confirm accept
                {
                    object = [objects lastObject];
                    doctor = object[@"Doctor"];
                    [self requestPatientStatus];
                }
                
            }];
        }
        @catch (NSException *exception)
        {
            NSLog(@"NSException %@", [exception description]);
        }
        @finally
        {
            
        }
        
    }
    
}

- (IBAction)backbutton:(id)sender {
    
    if(_comeLogin)
    {
        [PFUser logOut];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)declineAction:(id)sender
{
    [_waitingAcceptTimer invalidate];
    NSArray* containIn = @[@"Pending", @"Accepted"];
    [self showWaiting];
    PFQuery *postQuery = [PFQuery queryWithClassName:@"PatientRequest"];
    [postQuery whereKey:@"Patient" equalTo:[PFUser currentUser]];
    [postQuery whereKey:@"requestStatus" containedIn:containIn];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if(objects.count > 0)
            {
                __block int i = 0;
                for (PFObject* objectDelete in objects)
                {
                    [objectDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                        i++;
                        if(i == objects.count)
                        {
                            [self dismissWaiting];
                            if(doctor) {
                                [self sendNotificationToDoctors:doctor];
                            } else {
                                [self sendNotificationToDoctors];
                            }
                            MasterDetailViewController* masterDetail = [self.storyboard instantiateViewControllerWithIdentifier: @"MasterDetailViewControllerId"];
                            [self.navigationController pushViewController:masterDetail animated:YES];
                        }
                    }];
                }
                
                
            } else {
                [self dismissWaiting];
                MasterDetailViewController* masterDetail = [self.storyboard instantiateViewControllerWithIdentifier: @"MasterDetailViewControllerId"];
                [self.navigationController pushViewController:masterDetail animated:YES];
                
            }
            
        } else {
            [self dismissWaiting];
            MasterDetailViewController* masterDetail = [self.storyboard instantiateViewControllerWithIdentifier: @"MasterDetailViewControllerId"];
            [self.navigationController pushViewController:masterDetail animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)requestPatientStatus
{
    [pulseAnimation removeFromSuperlayer];
    self.doctorName.text = doctor[@"Name"];
    self.doctorName.font = [UIFont boldSystemFontOfSize:10];
    _medicalSpecialityLbl.hidden = FALSE;
    _medicalSpecialityLbl.text = doctor[@"medicalSpeciality"];
    NSString* responseTime = doctor[@"ResponseTime"];
    self.messageLabel.text = [NSString stringWithFormat:@"Dr. %@ Will See You %@",doctor[@"Name"], (responseTime ? responseTime : @"")];
    _acceptButton.enabled = TRUE;
    _autoCancelRequestLbl.hidden = FALSE;
    NSString* speakWithADoctor = object[@"speakWithADoctor"];
    bookingFee = [[doctor[@"FeeScale"] stringByReplacingOccurrencesOfString:@"$" withString:@""] doubleValue];
    if ( speakWithADoctor && [speakWithADoctor isEqualToString:@"TRUE"]) {
        bookingFee = 50;
    }
    //_priceLabel.text = [NSString stringWithFormat:@"The visit price is $%.f- When you accept a $%.f confirmation deposit will be charged",totalPrice, bookingFee];
    _priceLabel.text = [NSString stringWithFormat:@"The visit price is $%.f- Once you have accepted the visit payment will be secured and charged once visit has been completed.", bookingFee];
    // Do any additional setup after loading the view.
    PFQuery *postQuery = [PFQuery queryWithClassName:@"ReceiptRequest"];
    [postQuery whereKey:@"PaidForDoctorId" equalTo:doctor];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if(objects.count > 0)
            {
                PFObject* ratingDoctor1 = [objects lastObject];
                if(ratingDoctor1)
                {
                    _ratingDoctor.value = [ratingDoctor1[@"RatingDoctor"] intValue];
                }
            }
            
        }
    }];
    //Dr License #
    PFFile *drLicenseFile = doctor[@"Medicalicense"];
    [drLicenseFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.drLicenseImageView.layer.cornerRadius = self.drLicenseImageView.frame.size.width/2 ;
            self.drLicenseImageView.layer.masksToBounds = TRUE;
            self.drLicenseImageView.image = [UIImage imageWithData:imageData];
        }
    }];
    
    PFFile *userImageFile = doctor[@"providePic"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.doctorPhotoLoad.layer.cornerRadius = self.doctorPhotoLoad.frame.size.width/2 ;
            self.doctorPhotoLoad.layer.masksToBounds = TRUE;
            self.doctorPhotoLoad.image = [UIImage imageWithData:imageData];
        }
    }];
    //Start timer cancel request
    //_cancelRequestTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(automaticallyCancelRequest) userInfo:nil repeats:YES];
    
}

- (IBAction)doctorAccept:(id)sender {
    
    [self processPayment];
}

-(void)processPayment
{
    PFRelation* paymentRelation = [[PFUser currentUser] relationForKey:@"Payment"];
    NSArray* result = paymentRelation.query.findObjects;
    if(result == nil || result.count == 0)
    {
        UIAlertView *warningDialog = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please choose a payment method." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [warningDialog show];

    }
    else
    {
        PFObject* payment = result[0];
        for (PFObject* item in result)
        {
            if([item[@"isSelected"] boolValue] == TRUE)
            {
                payment = item;
                break;
            }
        }
        [self showWaiting:@"Processing Payment"];
        [[BrainTreeService defaultBraintree] makeSplitPayment:doctor[@"SubMerchantId"] amount:bookingFee paymentmethod:payment[@"PaymentToken"] tocustomerId:payment[@"CustomerId"] onDone:^(BOOL success, NSString * msg, NSString* transactionId) {
            [self dismissWaiting];
            if(success == TRUE)
            {
                object[@"requestStatus"] = @"Paid";
                //Store Amount
                object[@"AmountPaid"] = [NSNumber numberWithDouble:bookingFee];
                object[@"TotalAmount"] = [NSNumber numberWithDouble:totalPrice];
                object[@"CustomerId"] = payment[@"CustomerId"];
                object[@"TransactionId"] = transactionId;
                object[@"PaymentToken"] = payment[@"PaymentToken"];
                [object saveInBackground];
                ConfirmationMessageViewController* confirmMessage = [self.storyboard instantiateViewControllerWithIdentifier: (IPAD_VERSION ? @"ConfirmationMessageViewController" : @"ConfirmationMessageViewControlleriPhone")];
                confirmMessage.doctor = doctor;
                [self.navigationController pushViewController:confirmMessage animated:YES];
            }
            else
            {
                [self dismissWaiting];
                if (![msg isEqualToString:@""]) {
                    UIAlertView *warningDialog = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [warningDialog show];
                } else {
                    UIAlertView *warningDialog = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"We're sorry, you cannot accept at this time. Please try later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [warningDialog show];
                }
                
            }
        } onError:^(BOOL error) {
            [self dismissWaiting];
            UIAlertView *warningDialog = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"We're sorry, you cannot accept at this time. Please try later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [warningDialog show];
        }];
    }
    
    
    
}

- (IBAction)onSpeakDoctorClicked:(id)sender {

    if (_medicalSpecialityLbl.hidden == FALSE) {
        
        NSString* phonenumber = doctor[@"CellPhoneNumber"];
        phonenumber = [phonenumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
        phonenumber = [phonenumber stringByReplacingOccurrencesOfString:@")" withString:@""];
        phonenumber = [phonenumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        phonenumber = [phonenumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phonenumber]];
        if([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"We are sorry but iPads do not support dial or SMS." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
        }
        
    } else {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"There is no doctor to speak." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
    }
    
    
}

@end
