//
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPDistance.h"
#import "LPDuration.h"


@interface LPDistanceMatrixElement : NSObject <NSCoding>

@property (nonatomic, strong) LPDistance *distance;
@property (nonatomic, strong) LPDuration *duration;
@property (nonatomic, strong) NSString *statusCode;

+ (id)distanceMatrixElementWithObjects:(NSDictionary *)dictionary;

- (NSDictionary *)dictionary;

- (id)copyWithZone:(NSZone *)zone;

@end
