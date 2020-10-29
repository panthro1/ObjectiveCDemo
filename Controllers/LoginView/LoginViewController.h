//
//  LoginViewController.h
//  Doctor
//
//  Created by Arora Apps 002 on 17/11/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FacebookUtillis.h"
#import "AbstractViewController.h"
#import "MasterDetailViewController.h"
#import "NSString+FontAwesome.h"

@interface LoginViewController : AbstractViewController<FBUtilityDelegate, UIAlertViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate>
{
    FacebookUtillis *FButil;
    AppDelegate *app;
    IBOutlet UIButton* _rememberButton;
    CLLocationManager *locationManager;
    CLLocation *userLocation;
    IBOutlet UIButton *_registerButton;
    
}
@property(nonatomic,retain)IBOutlet UITextField *Emailtxt,*pswtxt;
@property(nonatomic,retain)IBOutlet UIButton *_backButton;
@property (assign, nonatomic) BOOL isUserDoctor;

-(IBAction)resetPasswordAction:(id)sender;
-(IBAction)rememberAction:(UIButton*)sender;

@end
