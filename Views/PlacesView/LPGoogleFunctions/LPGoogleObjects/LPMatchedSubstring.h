//
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LPMatchedSubstring : NSObject <NSCoding>

@property (nonatomic, assign) int length;
@property (nonatomic, assign) int offset;

+ (id)matchedSubstringWithObjects:(NSDictionary *)dictionary;

- (NSDictionary *)dictionary;

- (id)copyWithZone:(NSZone *)zone;

@end
