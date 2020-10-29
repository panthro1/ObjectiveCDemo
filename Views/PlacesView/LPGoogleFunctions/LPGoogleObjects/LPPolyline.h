//
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPLocation.h"


@interface LPPolyline : NSObject <NSCoding>

@property (nonatomic, strong) NSString *pointsString;
@property (nonatomic, strong) NSArray *pointsArray;

+ (id)polylineWithObjects:(NSDictionary *)dictionary;

+ (NSArray *)decodePolylineOfGoogleMaps:(NSString *)encodedPolyline;

- (NSDictionary *)dictionary;

- (id)copyWithZone:(NSZone *)zone;

@end
