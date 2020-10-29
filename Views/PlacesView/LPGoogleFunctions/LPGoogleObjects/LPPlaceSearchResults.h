//
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPPlaceDetails.h"


@interface LPPlaceSearchResults : NSObject <NSCoding>

@property (nonatomic, strong) NSArray *results;
@property (nonatomic, strong) NSString *statusCode;
@property (nonatomic, strong) NSArray *htmlAttributions;
@property (nonatomic, strong) NSString *nextPageToken;

+ (id)placeSearchResultsWithObjects:(NSDictionary *)dictionary;

- (NSDictionary *)dictionary;

- (id)copyWithZone:(NSZone *)zone;

@end
