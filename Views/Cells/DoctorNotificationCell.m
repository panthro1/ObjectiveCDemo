//
//  DoctorNotificationCell.m
//  doctor
//
//  Created by Thomas.Woodfin on 5/29/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import "DoctorNotificationCell.h"
#import "MBProgressHUD.h"
//#import "NavigationUIViewController.h"
#import "HelperUtils.h"

@implementation DoctorNotificationCell

- (void)awakeFromNib {
    // Initialization code
    //_AcceptButton.layer.masksToBounds = TRUE;
    //_AcceptButton.layer.cornerRadius = 5;
    //_AcceptButton.layer.borderWidth = 1.0;
    //_AcceptButton.layer.borderColor = [UIColor redColor].CGColor;
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void)setcontentDisplay:(PFObject*)content
{
    _objectContent = content;
    _Name.text = content[@"Name"];
    //_AddressName.text = content[@"Address"];
    _LblRequestAddress.text = content[@"patientrequestaddress"];
    _LblProblem.text = content[@"Problem"];
    _lblAddition.text = content[@"ProblemDetail"];
    NSString* phoneNumber = content[@"CellPhoneNumber"];
    [_PhoneNumberButton setTitle:@"" forState:UIControlStateNormal];
    if(phoneNumber && ![phoneNumber isEqualToString:@""])
    {
        [_PhoneNumberButton setTitle:[HelperUtils encryptedPhoneNumber:phoneNumber] forState:UIControlStateNormal];
        //[_PhoneNumberButton removeTarget:self action:@selector(calltoPatient:) forControlEvents:UIControlEventTouchUpInside];
        //[_PhoneNumberButton addTarget:self action:@selector(calltoPatient:) forControlEvents:UIControlEventTouchUpInside];
    }
    [_AcceptButton removeTarget:self action:@selector(acceptedAction:) forControlEvents:UIControlEventTouchUpInside];
    [_AcceptButton addTarget:self action:@selector(acceptedAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)calltoPatient:(id)sender
{
    UIAlertView* confirmCallAlert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Do you want to call?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [confirmCallAlert show];
}

-(IBAction)cancelAction:(id)sender{
    [_Controller showWaiting];
    [_objectContent deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [_Controller dismissWaiting];
        [_Controller reloadData];
    }];
}

-(IBAction)acceptedAction:(id)sender
{
    _objectContent[@"requestStatus"] = @"Accepted";
    PFObject* patient = _objectContent[@"Patient"];
    _AcceptButton.enabled = NO;
    [_Controller showWaiting];
    [_objectContent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        PFQuery *postQuery = [PFQuery queryWithClassName:@"PatientRequest"];
        [postQuery whereKey:@"groupRequest" equalTo:_objectContent[@"groupRequest"]];
        [postQuery whereKey:@"requestStatus" equalTo:@"Pending"];
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
                                [_Controller dismissWaiting];
                                PFUser* user = [PFUser currentUser];
                                [[DSSettingUtils sharedInstance] setStatusDoctoronMap:TRUE forDoctorId:[NSString stringWithFormat:@"%@_%@",user.objectId, user.objectId]];
                                _AcceptButton.hidden = YES;
                                //Todo: make a push notification to Patient
                                [self sendNotificationToPatient:patient.objectId];
                                [self.Controller.navigationController popViewControllerAnimated:TRUE];
//                                NavigationUIViewController* gpsNavigation = [[NavigationUIViewController alloc] init];
//                                [gpsNavigation enableAutoDirectToCalculateRouter];
//                                [self.Controller.navigationController pushViewController:gpsNavigation animated:YES];
                            }
                        }];
                    }
                }
                else
                {
                    [_Controller dismissWaiting];
                    _AcceptButton.hidden = YES;
                    PFUser* user = [PFUser currentUser];
                    [[DSSettingUtils sharedInstance] setStatusDoctoronMap:TRUE forDoctorId:[NSString stringWithFormat:@"%@_%@",user.objectId, user.objectId]];
                    //Todo: make a push notification to Patient
                    [self sendNotificationToPatient:patient.objectId];
                    [self.Controller.navigationController popViewControllerAnimated:TRUE];
//                    NavigationUIViewController* gpsNavigation = [[NavigationUIViewController alloc] init];
//                    [gpsNavigation enableAutoDirectToCalculateRouter];
//                    [self.Controller.navigationController pushViewController:gpsNavigation animated:YES];
                }
                
            }
            else
            {
                [_Controller dismissWaiting];
                _AcceptButton.hidden = YES;
            }
        }];
    }];
    
}

-(void)sendNotificationToPatient:(NSString*)objectId
{
    PFPush* push = [[PFPush alloc] init];
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"Status" equalTo:@"Patient"];
    [userQuery whereKey:@"objectId" equalTo:objectId];
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"user" matchesQuery:userQuery];
    [push setQuery:pushQuery];
    PFUser* user = [PFUser currentUser];
    NSString* doctorName = @"";
    if (![user[@"Name"] isEqualToString:@""]) {
        doctorName = user[@"Name"];
    }
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Dr %@ will call you shortly", doctorName], @"alert", @"default", @"sound", nil];
    //@"Your doctor is on the way."
    [push setData:data];
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *  error) {
        if(!error)
        {
            NSLog(@"Sent notification to Patient");
        }
        else
        {
            NSLog(@"Sent notification to Patient failure");
        }
    }];
}

#pragma -mark Impl UIALertDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)//YES
    {
        NSString* phonenumber = _objectContent[@"CellPhoneNumber"];
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
    }
}

@end
