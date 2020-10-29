//
//  LeftViewController.h
//  doctor
//
//  Created by Thomas Woodfin on 12/3/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"

@interface LeftViewController : AbstractViewController
{
    IBOutlet UIButton* navigationGpsButton;
    IBOutlet UIImageView* seperatorLine;
    IBOutlet UIButton* visitHistoryButton;
    IBOutlet UIImageView* seperatorLineSignOut;
    IBOutlet UIImageView* iconNaviGPS;
    IBOutlet UIImageView* iconVisitHistory;
    IBOutlet UIImageView* iconSignout;
    IBOutlet UIButton* signoutButton;
    __weak IBOutlet UIView *containerLeftMenu;
    IBOutlet UITableView* leftMenuTableView;
    NSArray* _menuDataSource;
}
- (IBAction)btn_Home:(id)sender;
- (IBAction)btn_Profile:(id)sender;
- (IBAction)btn_Promotions:(id)sender;
- (IBAction)btn_Messages:(id)sender;
- (IBAction)btn_Settings:(id)sender;
- (IBAction)logOut:(id)sender;
- (IBAction)financialAction:(id)sender;
- (IBAction)navigationGPS:(id)sender;
- (IBAction)visithistoryAction:(id)sender;
- (IBAction)paymentAction:(id)sender;

@end
