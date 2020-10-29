//
//  PatientRequestCell.h
//  doctor
//
//  Created by Muhammad Imran on 12/12/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <parse/parse.h>

@interface PatientRequestCell : UITableViewCell <UIAlertViewDelegate>{
    
    IBOutlet UISwitch* _onOffMapSwicthControl;
@private
    PFUser *doctor;
    PFUser* patient;
    PFObject* _patientRequest;
    UITapGestureRecognizer* tapToCall;
    
}

@property (strong, nonatomic) IBOutlet UILabel *patientName;
@property (strong, nonatomic) IBOutlet UILabel *patientAddress;
@property (strong, nonatomic) IBOutlet UILabel *patientRequestAddress;
@property (strong, nonatomic) IBOutlet UILabel *patientPhoneNumber;
@property (strong, nonatomic) IBOutlet UILabel *requestDate;
@property (strong, nonatomic) IBOutlet UILabel *problemLable;
@property (strong, nonatomic) IBOutlet UITextView *problemDetail;
@property (strong, nonatomic) IBOutlet UIImageView *ImgBg;
@property (strong, nonatomic) IBOutlet UIButton *PatientVisited;
@property (strong, nonatomic) IBOutlet UIButton *ShowLocation;
- (void)setUpCellData:(PFObject*)patientRequest;
@property (weak, nonatomic) IBOutlet UILabel *Age;

- (IBAction)onOff:(UISwitch*)sender;

@end
