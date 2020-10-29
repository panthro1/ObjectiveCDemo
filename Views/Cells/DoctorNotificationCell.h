//
//  DoctorNotificationCell.h
//  doctor
//
//  Created by Thomas.Woodfin on 5/29/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctorNotificationListUI.h"
@interface DoctorNotificationCell : UITableViewCell <UIAlertViewDelegate>
{
    PFObject* _objectContent;
}

@property (weak, nonatomic) IBOutlet UILabel *lblAddition;

@property(nonatomic, strong) IBOutlet UILabel* Name;
@property(nonatomic, strong) IBOutlet UILabel* AddressName;
@property(nonatomic, strong) IBOutlet UILabel* LblProblem;
@property(nonatomic, strong) IBOutlet UILabel* LblRequestAddress;
@property(nonatomic, strong) IBOutlet UIButton* PhoneNumberButton;
@property(nonatomic, strong) IBOutlet UIButton* AcceptButton;
@property(nonatomic, assign) DoctorNotificationListUI* Controller;
-(void)setcontentDisplay:(PFObject*)content;
@end
