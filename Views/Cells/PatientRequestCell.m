//
//  PatientRequestCell.m
//  doctor
//
//  Created by Muhammad Imran on 12/12/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import "PatientRequestCell.h"
#import "HelperUtils.h"
#import "PatientDetailVC.h"


@implementation PatientRequestCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.ImgBg.layer.masksToBounds = YES;
    self.ImgBg.layer.cornerRadius = 5;
    self.problemDetail.layer.masksToBounds = YES;
    self.problemDetail.layer.cornerRadius = 5;
    //self.problemDetail.layer.borderWidth = 1.0;
//    self.problemDetail.backgroundColor = [UIColor clearColor];
//    self.problemDetail.layer.borderColor = [UIColor redColor].CGColor;
    self.PatientVisited.layer.masksToBounds = YES;
    self.PatientVisited.layer.cornerRadius = 5;
    self.PatientVisited.layer.borderWidth = 1.0;
    self.PatientVisited.layer.borderColor = [UIColor redColor].CGColor;
    self.ShowLocation.layer.masksToBounds = YES;
    self.ShowLocation.layer.cornerRadius = 5;
    self.ShowLocation.layer.borderWidth = 1.0;
    self.ShowLocation.layer.borderColor = [UIColor redColor].CGColor;
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setUpCellData:(PFObject*)patientRequest
{
    patient = [patientRequest objectForKey:@"Patient"];
    _patientRequest = patientRequest;
    NSLog(@"%@",[patient allKeys]);
    doctor = [patientRequest objectForKey:@"Doctor"];
    _onOffMapSwicthControl.on = ![[DSSettingUtils sharedInstance] statusDoctorOnMap:[NSString stringWithFormat:@"%@_%@",patient.objectId, doctor.objectId]];
    NSLog(@"%@",[patientRequest allKeys]);
    self.patientName.text = patientRequest [@"Name"];
    __block NSString* status = patientRequest[@"requestStatus"];
    self.patientPhoneNumber.text = patientRequest[@"CellPhoneNumber"];
    tapToCall = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCall:)];
    self.patientPhoneNumber.userInteractionEnabled = TRUE;
    [self.patientPhoneNumber addGestureRecognizer:tapToCall];
//    if([status isEqualToString:@"Paid"]){
//        self.patientPhoneNumber.text = patientRequest[@"CellPhoneNumber"];
//    } else {
//        self.patientPhoneNumber.text = [HelperUtils encryptedPhoneNumber:patientRequest[@"CellPhoneNumber"]];
//    }
    self.Age.text = patientRequest[@"Age"];
    [patientRequest fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        status = object[@"requestStatus"];
        if([status isEqualToString:@"Paid"] || [status isEqualToString:@"FullPaid"]){
            //self.patientPhoneNumber.text = patientRequest[@"CellPhoneNumber"];
            _PatientVisited.enabled = TRUE;
            if (tapToCall) {
                [self.patientPhoneNumber removeGestureRecognizer:tapToCall];
            }
        } else {
            //self.patientPhoneNumber.text = [HelperUtils encryptedPhoneNumber:patientRequest[@"CellPhoneNumber"]];
        }
    }];
    self.patientAddress.text = patientRequest[@"Address"];
    self.problemDetail.text = patientRequest[@"ProblemDetail"];
    self.problemLable.text = patientRequest [@"Problem"];
    self.patientRequestAddress.text = patientRequest[@"patientrequestaddress"];
    
    //add patient age
    self.Age.text = patientRequest[@"Age"];
    
    NSDate *date = patientRequest[@"RequestDate"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSLocale *hourFomrat = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.locale = hourFomrat;
    [formatter setDateFormat:@"EEEE, MMM d hh:mm"];
    
    self.requestDate.text = [formatter stringFromDate:date];
    
}

- (IBAction)onOff:(UISwitch*)sender
{
    [[DSSettingUtils sharedInstance] setStatusDoctoronMap:!sender.on forDoctorId:[NSString stringWithFormat:@"%@_%@",patient.objectId, doctor.objectId]];
    
}

- (IBAction)patientDetail:(id)sender
{
    PatientDetailVC* patientVC = [[PatientDetailVC alloc] init];
    patientVC.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
    patientVC.modalPresentationStyle= UIModalPresentationCustom;
    patientVC.PaitientObject = _patientRequest;
    [patientVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:patientVC animated:TRUE completion:nil];
}

-(IBAction)tapCall:(id)sender
{
    UIAlertView* confirmCallAlert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Do you want to call?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [confirmCallAlert show];
}

#pragma -mark Impl UIALertDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)//YES
    {
        NSString* phonenumber = self.patientPhoneNumber.text;
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
