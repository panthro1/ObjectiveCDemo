//
//  ViewController.h
//  Doctor
//
//  Created by Thomas Woodfin on 11/16/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ViewController : BaseViewController <CLLocationManagerDelegate>
{
    AppDelegate *app;
    CLLocationManager *locationManager;
    CLLocation *userLocation;
}
@end

