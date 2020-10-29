//
//  BraintreeModel.h
//  doctor
//
//  Created by Thomas.Woodfin on 7/22/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BraintreeModel : NSObject

@property(nonatomic, strong) NSString* FirstName;
@property(nonatomic, strong) NSString* LastName;
@property(nonatomic, strong) NSString* Email;
@property(nonatomic, strong) NSString* PhoneNumber;
@property(nonatomic, strong) NSString* LegalName;
@property(nonatomic, strong) NSString* AccountNumber;
@property(nonatomic, strong) NSString* RoutingNumber;
@property(nonatomic, strong) NSString* StreetAddress;
@property(nonatomic, strong) NSString* DateOfBirth;
@property(nonatomic, strong) NSString* SSN;
@property(nonatomic, strong) NSString* Locality;
@property(nonatomic, strong) NSString* Religion;
@property(nonatomic, strong) NSString* PostCode;

@end
