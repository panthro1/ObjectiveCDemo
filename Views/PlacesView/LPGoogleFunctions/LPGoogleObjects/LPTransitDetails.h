//
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPStop.h"
#import "LPTime.h"
#import "LPLine.h"


@interface LPTransitDetails : NSObject <NSCoding>

@property (nonatomic, strong) LPStop *arrivalStop;
@property (nonatomic, strong) LPTime *arrivalTime;
@property (nonatomic, strong) LPStop *departureStop;
@property (nonatomic, strong) LPTime *departureTime;
@property (nonatomic, strong) NSString *headsign;
@property (nonatomic, strong) LPLine *line;
@property (nonatomic, assign) int numStops;

+ (id)transitDetailsWithObjects:(NSDictionary *)dictionary;

- (NSDictionary *)dictionary;

- (id)copyWithZone:(NSZone *)zone;

@end
