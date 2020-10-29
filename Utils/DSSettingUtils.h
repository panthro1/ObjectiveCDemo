//
//  DSSettingUtils.h
//  doctor
//
//  Created by Thomas Woodfin on 3/31/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSSettingUtils : NSObject

+(DSSettingUtils*)sharedInstance;
-(void)setStatusDoctoronMap:(BOOL)value forDoctorId:(NSString*)doctorId;
-(BOOL)statusDoctorOnMap:(NSString*)doctorId;

@end
