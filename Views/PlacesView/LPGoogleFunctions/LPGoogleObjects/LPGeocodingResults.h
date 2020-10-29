//
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPPlaceDetails.h"


@interface LPGeocodingResults : NSObject <NSCoding>

@property (nonatomic, strong) NSArray *results;
@property (nonatomic, strong) NSString *statusCode;

+ (id)geocodingResultsWithObjects:(NSDictionary *)dictionary;

- (NSDictionary *)dictionary;

- (id)copyWithZone:(NSZone *)zone;

@end
