//
//  ReceiptViewController.m
//  doctor
//
//  Created by Thomas Woodfin on 12/7/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import "ReceiptViewController.h"
#import "MasterDetailViewController.h"
#import "MBProgressHUD.h"

@interface ReceiptViewController () <UITextViewDelegate>
{
    PFUser* _doctor;
    PFObject* _patientRequest;
}
@end

@implementation ReceiptViewController

-(void)tapDismissKeyboard
{
    [self.view endEditing:YES];
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
    
    _commentsTextView.layer.borderColor = [UIColor orangeColor].CGColor;
    _commentsTextView.layer.borderWidth = 2;
    _commentsTextView.delegate = self;
    UITapGestureRecognizer* tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismissKeyboard)];
    [self.view addGestureRecognizer:tapView];
    PFQuery *postQuery = [PFQuery queryWithClassName:@"PatientRequest"];
    [postQuery whereKey:@"PatientVisited" equalTo:[NSNumber numberWithBool:YES]];
    [postQuery whereKey:@"Patient" equalTo:[PFUser currentUser]];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if(objects.count > 0)
            {
                _patientRequest = [objects lastObject];
                NSNumber* totalAmount = _patientRequest[@"AmountPaid"];
                _priceLabel.text = [NSString stringWithFormat:@"$%.2f", [totalAmount doubleValue]];
                _doctor = [_patientRequest objectForKey:@"Doctor"];
                PFQuery *query = [PFUser query];
                
                [query getObjectInBackgroundWithId:[_doctor objectId] block:^(PFObject *object, NSError *error) {
                    _doctor = (PFUser*)object;
                    PFFile *userImageFile = _doctor[@"providePic"];
                    _doctorNameLabel.text = [NSString stringWithFormat:@"DR. %@",_doctor[@"Name"]];
                    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                        if (!error) {
                            _doctorImageView.image = [UIImage imageWithData:imageData];
                        }
                    }];
                }];
            }
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma -mark Actions


- (IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)receiptSubmit:(id)sender
{
    [self showWaiting];
    PFUser *currentUser = [PFUser currentUser];
    PFObject *receiptRequest = [PFObject objectWithClassName:@"ReceiptRequest"];
    receiptRequest[@"Price"] = [NSNumber numberWithDouble:[[_priceLabel.text stringByReplacingOccurrencesOfString:@"$" withString:@""] doubleValue]];
    receiptRequest[@"PatientId"] = currentUser;
    receiptRequest[@"Comments"] = _commentsTextView.text;
    receiptRequest[@"PaidForDoctorId"] = _doctor;
    receiptRequest[@"RatingDoctor"] = [NSNumber numberWithFloat:self.starRatingView.value];
    [receiptRequest saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self dismissWaiting];
        if(succeeded && !error)
        {
            if(_patientRequest)
            {
                _patientRequest[@"requestStatus"] = @"Completed";
                [_patientRequest saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    UIAlertView* receiptAlert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Rating saved successfully!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [receiptAlert show];
                    MasterDetailViewController* masterDetail = [self.storyboard instantiateViewControllerWithIdentifier: @"MasterDetailViewControllerId"];
                    [self.navigationController pushViewController:masterDetail animated:YES];
                }];
            }
            
        }
        else
        {
            UIAlertView* alertError = [[UIAlertView alloc] initWithTitle:nil message:@"Rating not saved.  Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertError show];
        }
    }];
    
    
}

- (IBAction)didChangeValue:(id)sender
{
    
    NSLog(@"Rating : %f", self.starRatingView.value);
    
}

-(IBAction)skipReviewAction:(id)sender
{
    if(_patientRequest)
    {
        [self showWaiting];
        _patientRequest[@"PatientVisited"] = [NSNumber numberWithBool:FALSE];
        [_patientRequest saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self dismissWaiting];
            MasterDetailViewController* masterDetail = [self.storyboard instantiateViewControllerWithIdentifier: @"MasterDetailViewControllerId"];
            [self.navigationController pushViewController:masterDetail animated:YES];
        }];
    }

}

@end
