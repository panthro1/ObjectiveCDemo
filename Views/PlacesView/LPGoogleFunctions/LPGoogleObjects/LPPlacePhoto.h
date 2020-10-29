//
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LPPlacePhoto : NSObject <NSCoding>

@property (nonatomic, strong) NSArray *htmlAttributions;
@property (nonatomic, assign) int height;
@property (nonatomic, assign) int width;
@property (nonatomic, strong) NSString *photoReference;

+ (id)placePhotoWithObjects:(NSDictionary *)dictionary;

- (NSDictionary *)dictionary;

- (id)copyWithZone:(NSZone *)zone;

@end
