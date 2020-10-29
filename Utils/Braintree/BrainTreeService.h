//
//  BrainTreeService.h
//  doctor
//
//  Created by Thomas.Woodfin on 7/22/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrainTreeService : NSObject

+(BrainTreeService*) defaultBraintree;

- (void) creatCustomerInfo:(CustomerInfo*) customer onDone:(void(^)(BOOL , NSString*))onDone onError:(void(^)(BOOL))onError;
- (void) creatSubMerchant:(BraintreeModel*) braintreeModel onDone:(void(^)(BOOL , NSString*))onDone onError:(void(^)(BOOL))onError;
- (void) makeSplitPayment:(NSString*) merId amount:(double) amount paymentmethod:(NSString*)paymentMethod tocustomerId:(NSString*)customerId onDone:(void(^)(BOOL , NSString*, NSString*))onDone onError:(void(^)(BOOL))onError;
- (void) addPaymentMethod:(NSString*)paymentMethod tocustomerId:(NSString*)customerId onDone:(void(^)(BOOL , NSString*, NSString*))onDone onError:(void(^)(BOOL))onError;
@end
