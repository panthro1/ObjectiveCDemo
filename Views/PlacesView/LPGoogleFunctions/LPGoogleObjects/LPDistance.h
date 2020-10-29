//
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LPDistance : NSObject <NSCoding>

@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) int value;

+ (id)distanceWithObjects:(NSDictionary *)dictionary;

- (NSDictionary *)dictionary;

- (id)copyWithZone:(NSZone *)zone;

@end
