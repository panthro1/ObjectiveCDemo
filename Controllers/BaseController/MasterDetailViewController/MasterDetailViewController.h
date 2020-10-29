//
//  MasterDetailViewController.h
//  Loopocity
//
//  Created by Hossam Ghareeb on 2/1/14.
//  Copyright (c) 2014 Hossam Ghareeb. All rights reserved.
//

#import "MMDrawerController.h"
#import "AppDelegate.h"

@class AbstractViewController;

@interface MasterDetailViewController : MMDrawerController

{

    AppDelegate *delegate;
}

@property(nonatomic) BOOL ignoreAddMainMenu;

-(void)setCenterViewControllerWithMasterDetail:(AbstractViewController *)centerViewController;

@end
