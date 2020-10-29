//
//  MenuViewController.h
//  doctor
//
//  Created by Thomas Woodfin on 12/3/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"
#import <MapKit/MapKit.h>

@interface MenuViewController : AbstractViewController
{
    IBOutlet MKMapView* _mapViewHome;
    IBOutlet UIButton* _requestDoctor;
    IBOutlet UIView* _confirmView;
    IBOutlet UIImageView *paymentIcon;
    IBOutlet UILabel *paymentName;
    IBOutlet UIView *paymentView;
    IBOutlet UIButton *menuButton;
    IBOutlet UILabel *changeLbl;
    NSArray *doctors;
}

-(IBAction)requestDoctor:(id)sender;
@end
