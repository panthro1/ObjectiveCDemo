//
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPLocation.h"


@interface LPWaypoint : NSObject <NSCoding>

@property (nonatomic, strong) LPLocation *location;
@property (nonatomic, assign) int stepIndex;
@property (nonatomic, assign) double stepInterpolation;

+ (id)waypointWithObjects:(NSDictionary *)dictionary;

- (NSDictionary *)dictionary;

- (id)copyWithZone:(NSZone *)zone;

@end
