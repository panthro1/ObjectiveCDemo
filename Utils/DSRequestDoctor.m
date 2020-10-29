//
//  DSRequestDoctor.m
//  doctor
//
//  Created by Thomas.Woodfin on 5/28/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import "DSRequestDoctor.h"

@implementation DSRequestDoctor

static DSRequestDoctor* mInstance;

+(DSRequestDoctor*)sharedIntsance
{
    if(mInstance == nil)
    {
        mInstance = [[DSRequestDoctor alloc] init];
    }
    return mInstance;
}

@end
