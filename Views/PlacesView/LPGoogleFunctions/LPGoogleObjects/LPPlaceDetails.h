//
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPGeometry.h"
#import "LPAddressComponent.h"
#import "LPPlacePhoto.h"
#import "LPEvent.h"


typedef enum {
    LPGooglePriceLevelFree,
    LPGooglePriceLevelInexpensive,
    LPGooglePriceLevelModerate,
    LPGooglePriceLevelExpensive,
    LPGooglePriceLevelVeryExpensive
} LPGooglePriceLevel;


@interface LPPlaceDetails : NSObject <NSCoding>

@property (nonatomic, strong) NSArray *addressComponents;
@property (nonatomic, strong) NSString *adrAddress;
@property (nonatomic, strong) NSString *formattedAddress;
@property (nonatomic, strong) LPGeometry *geometry;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *reference;
@property (nonatomic, strong) NSArray *types;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSArray *vicinity;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, assign) LPGooglePriceLevel priceLevel;
@property (nonatomic, assign) float rating;
@property (nonatomic, strong) NSArray *events;

+ (id)placeDetailsWithObjects:(NSDictionary *)dictionary;

- (NSDictionary *)dictionary;

- (id)copyWithZone:(NSZone *)zone;

@end
