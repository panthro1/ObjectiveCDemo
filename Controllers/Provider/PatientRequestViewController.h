//
//  PatientRequestViewController.h
//  doctor
//
//  Created by Muhammad Imran on 12/12/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AbstractViewController.h"
#import "UIImage+FontAwesome.h"


@interface PatientRequestViewController : AbstractViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate> {
    
    __weak IBOutlet UIButton *menuButton;
    IBOutlet UITableView* _tableView;
    IBOutlet UISwitch* _doctorMapLocatorSwitch;
}

@property (nonatomic, strong) NSArray *requests;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
//Methods
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)onoffDoctorMapLocator:(UISwitch*)sender;

@end
