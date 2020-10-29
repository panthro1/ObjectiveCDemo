//
//  AbstractViewController.h
//  Loopocity
//
//  Created by Hossam Ghareeb on 1/23/14.
//  Copyright (c) 2014 Hossam Ghareeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MasterDetailViewController.h"
@interface AbstractViewController : BaseViewController



@property (nonatomic, weak) MasterDetailViewController *masterDetailViewController;
-(IBAction)goBack:(id)sender;
-(IBAction)toogleMasterView:(id)sender;

-(void)showWarningMsg:(NSString *)warnningMsg inView:(UIView *)view;
-(void)showLoadingMsg:(NSString *)loadingMsg inView:(UIView *)view;
-(void)hideHUDInView:(UIView *)view;
@end
