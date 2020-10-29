//
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPLocation.h"


@interface LPBounds : NSObject <NSCoding>

@property (nonatomic, strong) LPLocation *northeast;
@property (nonatomic, strong) LPLocation *southwest;

+ (id)boundsWithObjects:(NSDictionary *)dictionary;

- (NSDictionary *)dictionary;

- (id)copyWithZone:(NSZone *)zone;

@end
