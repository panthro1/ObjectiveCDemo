//
//  DoctorNotificationListUI.h
//  doctor
//
//  Created by Thomas.Woodfin on 5/28/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorNotificationListUI : UITableViewController

@property(nonatomic, strong) NSArray* doctorNotification;
-(void)reloadData;
-(IBAction)skipAction:(id)sender;
-(void)showWaiting;
-(void)dismissWaiting;
@end
