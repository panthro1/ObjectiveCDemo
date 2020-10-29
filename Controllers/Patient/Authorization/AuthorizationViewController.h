//
//  AuthorizationViewController.h
//  doctor
//
//  Created by Thomas Woodfin on 11/29/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorizationViewController : UIViewController
{
    IBOutlet UITextView* _termOfUseTextView;
}
@property(nonatomic) BOOL isAuthorizationPatient;

@property (strong, nonatomic) IBOutlet UIScrollView *myScroller;
- (IBAction)authorizeButton:(id)sender;
- (IBAction)backButtonAction:(id)sender;

@end
