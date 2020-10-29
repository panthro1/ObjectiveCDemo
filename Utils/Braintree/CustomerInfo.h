//
//  CustomerInfo.h
//  doctor
//
//  Created by Thomas.Woodfin on 7/28/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerInfo : NSObject

@property(nonatomic, strong) NSString* FirstName;
@property(nonatomic, strong) NSString* LastName;
@property(nonatomic, strong) NSString* Email;
@property(nonatomic, strong) NSString* PhoneNumber;

@end
