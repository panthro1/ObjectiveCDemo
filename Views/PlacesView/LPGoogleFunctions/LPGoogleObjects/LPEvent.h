//
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LPEvent : NSObject <NSCopying>

@property (nonatomic, strong) NSString *eventID;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *URL;

+ (id)eventWithObjects:(NSDictionary *)dictionary;

- (NSDictionary *)dictionary;

- (id)copyWithZone:(NSZone *)zone;

@end
