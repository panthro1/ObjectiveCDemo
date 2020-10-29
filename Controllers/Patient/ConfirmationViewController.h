//
//  ConfirmationViewController.h
//  doctor
//
//  Created by Thomas Woodfin on 12/7/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <parse/parse.h>
#import "HCSStarRatingView.h"
#import "PulsingHaloLayer.h"

@interface ConfirmationViewController : BaseViewController{
    IBOutlet HCSStarRatingView* _ratingDoctor;
    IBOutlet UIButton* _acceptButton;
    PFUser *doctor;
    PFObject* object ;
    NSTimer* timer;
    IBOutlet UILabel* _autoCancelRequestLbl;
    IBOutlet UILabel* _medicalSpecialityLbl;
}
//Properties
@property (strong, nonatomic) IBOutlet UIImageView *doctorPhotoLoad;
@property (nonatomic) BOOL comeLogin;
@property (strong, nonatomic) IBOutlet UILabel *doctorName;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
//Methods
- (IBAction)doctorAccept:(id)sender;

@end
