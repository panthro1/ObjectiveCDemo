//
//  ConfirmationMessageViewController.h
//  doctor
//
//  Created by Thomas Woodfin on 12/7/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ConfirmationMessageViewController : UIViewController<MFMessageComposeViewControllerDelegate>
- (IBAction)btn_Close:(id)sender;
- (IBAction)btn_Call:(id)sender;
- (IBAction)btn_Text:(id)sender;

@property (strong, nonatomic) PFUser *doctor;

@end
