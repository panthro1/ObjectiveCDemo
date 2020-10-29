//
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LPTerm : NSObject <NSCoding>

@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign) int offset;

+ (id)termWithObjects:(NSDictionary *)dictionary;

- (NSDictionary *)dictionary;

- (id)copyWithZone:(NSZone *)zone;

@end
