//
//  BaseViewController.h
//  doctor
//
//  Created by Thomas.Woodfin on 7/17/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
{
    IBOutlet UIImageView* centerLogoView;
    IBOutlet UIButton* financialButton;
}
-(void)showWaiting;
-(void)showWaiting:(NSString*)title;
-(void)dismissWaiting;

@end
