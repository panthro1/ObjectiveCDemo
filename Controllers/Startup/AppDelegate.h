//
//  AppDelegate.h
//  Doctor
//
//  Created by Thomas Woodfin on 11/16/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class SKTMapsObject;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,assign)BOOL isPatient;
@property(nonatomic,strong) NSMutableArray *cachedMapRegions;
@property (nonatomic, strong) SKTMapsObject *skMapsObject;

@end

