//
//  AbstractViewController.m
//  Loopocity
//
//  Created by Hossam Ghareeb on 1/23/14.
//  Copyright (c) 2014 Hossam Ghareeb. All rights reserved.
//

#import "AbstractViewController.h"

@interface AbstractViewController ()

@end

@implementation AbstractViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
	// Do any additional setup after loading the view.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)toogleMasterView:(id)sender
{
    [self.masterDetailViewController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        [self.view endEditing:YES];
    }];
}
-(void)showLoadingMsg:(NSString *)loadingMsg inView:(UIView *)view
{
    
    MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = loadingMsg;
}
-(void)hideHUDInView:(UIView *)view
{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}
-(void)showWarningMsg:(NSString *)warnningMsg inView:(UIView *)view;
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
//	hud.labelText = warnningMsg;
    hud.detailsLabelText = warnningMsg;
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:4];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
