//
//  DSSettingUtils.m
//  doctor
//
//  Created by Thomas Woodfin on 3/31/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import "DSSettingUtils.h"

@implementation DSSettingUtils

static DSSettingUtils* mInstance;

+(DSSettingUtils*)sharedInstance
{
    if(!mInstance)
    {
        mInstance = [DSSettingUtils new];
    }
    return mInstance;
}

-(void)setStatusDoctoronMap:(BOOL)value forDoctorId:(NSString*)doctorId
{
    NSUserDefaults* uDf = [NSUserDefaults standardUserDefaults];
    [uDf setBool:value forKey:doctorId];
    [uDf synchronize];
}

-(BOOL)statusDoctorOnMap:(NSString*)doctorId
{
    NSUserDefaults* uDf = [NSUserDefaults standardUserDefaults];
    BOOL statusDoctor = [uDf boolForKey:doctorId];
    [uDf synchronize];
    return statusDoctor;
}

@end
