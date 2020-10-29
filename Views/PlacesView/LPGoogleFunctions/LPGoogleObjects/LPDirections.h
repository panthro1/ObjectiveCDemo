//
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPRoute.h"


typedef enum {
    LPGoogleDirectionsAvoidNone,
    LPGoogleDirectionsAvoidTolls,
    LPGoogleDirectionsAvoidHighways
} LPGoogleDirectionsAvoid;

typedef enum {
    LPGoogleDirectionsUnitMetric,
    LPGoogleDirectionsUnitImperial
} LPGoogleDirectionsUnit;


@interface LPDirections : NSObject <NSCoding>

@property (nonatomic, strong) NSArray *routes;
@property (nonatomic, strong) NSString *statusCode;
@property (nonatomic, assign) LPGoogleDirectionsTravelMode requestTravelMode;

+ (id)directionsWithObjects:(NSDictionary *)dictionary;

- (NSDictionary *)dictionary;

- (id)copyWithZone:(NSZone *)zone;

+ (NSString *)getDirectionsAvoid:(LPGoogleDirectionsAvoid)avoid;
+ (NSString *)getDirectionsUnit:(LPGoogleDirectionsUnit)unit;

@end

