//
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPPrediction.h"

@interface LPPlacesAutocomplete : NSObject <NSCoding>

@property (nonatomic, strong) NSArray *predictions;
@property (nonatomic, strong) NSString *statusCode;

+ (id)placesAutocompleteWithObjects:(NSDictionary*)dictionary;

- (NSDictionary*)dictionary;

- (id)copyWithZone:(NSZone *)zone;

@end
