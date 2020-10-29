//
//  ServiceUnvailableViewController.h
//  doctor
//
//  Created by Thomas.Woodfin on 5/7/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ServiceUnvailableDelegate

@optional

-(void)ServiceUnvailableRetry;

@end

@interface ServiceUnvailableViewController : UIViewController

@property(nonatomic, assign) id<ServiceUnvailableDelegate> delegateService;
-(IBAction)retryServiceAction:(id)sender;

@end
