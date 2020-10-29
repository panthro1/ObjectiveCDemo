//
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPPlaceDetails.h"


@interface LPPlaceDetailsResults : NSObject <NSCoding>

@property (nonatomic, strong) NSArray *htmlAttributions;
@property (nonatomic, strong) LPPlaceDetails *result;
@property (nonatomic, strong) NSString *statusCode;

+ (id)placeDetailsResultsWithObjects:(NSDictionary *)dictionary;

- (NSDictionary *)dictionary;

- (id)copyWithZone:(NSZone *)zone;

@end
