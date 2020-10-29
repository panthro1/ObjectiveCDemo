//
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    LPGeocodingFilterRoute,
    LPGeocodingFilterLocality,
    LPGeocodingFilterAdministrative_area,
    LPGeocodingFilterPostal_code,
    LPGeocodingFilterCountry
} LPGeocodingFilterMode;


@interface LPGeocodingFilter : NSObject <NSCoding>

@property (nonatomic, assign) LPGeocodingFilterMode filter;
@property (nonatomic, strong) NSString *value;

+ (id)filterWithGeocodingFilter:(LPGeocodingFilterMode)filter value:(NSString *)value;

- (NSDictionary *)dictionary;

+ (NSString *)getGeocodingFilter:(LPGeocodingFilterMode)filter;

- (id)copyWithZone:(NSZone *)zone;

@end
