//
//  DSRequestDoctor.h
//  doctor
//
//  Created by Thomas.Woodfin on 5/28/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSRequestDoctor : NSObject

@property(nonatomic) BOOL operatorTime;

+(DSRequestDoctor*)sharedIntsance;

@end
