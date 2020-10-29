//
//  BrainTreeService.m
//  doctor
//
//  Created by Thomas.Woodfin on 7/22/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import "BrainTreeService.h"
#import "AFHTTPRequestOperationManager.h"
#import "API.h"

@implementation BrainTreeService

static BrainTreeService* instance;

+(BrainTreeService*) defaultBraintree
{
    if(!instance)
    {
        instance = [BrainTreeService new];
    }
    return instance;
}

- (void) creatCustomerInfo:(CustomerInfo*) customer onDone:(void(^)(BOOL , NSString*))onDone onError:(void(^)(BOOL))onError;
{
    NSDictionary *parameters = @{@"method": @"create_customer", @"firstName" : (customer.FirstName ? customer.FirstName : @"Facebook"), @"lastName" : (customer.LastName ? customer.LastName : @"Facebook")
                                 , @"email": (customer.Email ? customer.Email : @""), @"phone" : (customer.PhoneNumber ? customer.PhoneNumber : @"444-444-4444")};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:(NSJSONWritingOptions)0
                                                         error:nil];
    NSString* URL = [NSString stringWithFormat:@"%@%@", ROOT_URL, CREATE_CUSTOMER];
    NSLog(@"JSON request %@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    NSString* jSON = [NSString stringWithFormat:@"[%@]",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: [jSON dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"JSON responseObject: %@ ",dict);
        NSDictionary* response = [dict objectForKey:@"Response"];
        NSString* statuscode = [response objectForKey:@"Code"];
        if([statuscode intValue] != 200)
        {
            NSString* msg = [response objectForKey:@"Message"];
            onDone(FALSE, msg);
        }
        else
        {
            NSArray* result = [response objectForKey:@"result"];
            if(result.count > 0)
            {
                dict  = result[0];
                NSString* customerId = [dict objectForKey:@"customer_id"];
                if(customerId && ![customerId isEqualToString:@""])
                {
                    onDone(TRUE, customerId);
                }
                else
                {
                    onDone(FALSE, @"Please try again.");
                }
                
            }
            else
            {
                onDone(FALSE, @"Please try again.");
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(onError)
        {
            onError(FALSE);
        }
        
    }];
    [op start];
}

- (void) creatSubMerchant:(BraintreeModel*) braintreeModel onDone:(void(^)(BOOL, NSString*))onDone onError:(void(^)(BOOL))onError
{
    NSDictionary *parameters = @{@"method": @"create_sub_merchant", @"firstName" : braintreeModel.FirstName, @"lastName" : braintreeModel.LastName
                                 , @"email": braintreeModel.Email, @"phone" : braintreeModel.PhoneNumber, @"legalName" : braintreeModel.LegalName,
                                 @"accountNumber" : braintreeModel.AccountNumber, @"routingNumber" : braintreeModel.RoutingNumber, @"dateOfBirth" : braintreeModel.DateOfBirth, @"ssn" : braintreeModel.SSN, @"streetAddress" : braintreeModel.StreetAddress, @"locality" : braintreeModel.Locality, @"region" : braintreeModel.Religion, @"postalCode" : braintreeModel.PostCode};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:(NSJSONWritingOptions)0
                                                         error:nil];
    NSString* URL = [NSString stringWithFormat:@"%@%@", ROOT_URL, SUBMERCHANT_SPLITPAYMENT];
    NSLog(@"JSON request %@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    NSString* jSON = [NSString stringWithFormat:@"[%@]",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: [jSON dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"JSON responseObject: %@ ",dict);
        NSDictionary* response = [dict objectForKey:@"Response"];
        NSString* statuscode = [response objectForKey:@"Code"];
        if([statuscode intValue] != 200)
        {
            NSString* msg = [response objectForKey:@"Message"];
            msg = [msg stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
            onDone(FALSE, msg);
        }
        else
        {
            NSArray* result = [response objectForKey:@"result"];
            if(result.count > 0)
            {
                dict  = result[0];
                NSString* subMarchantId = [dict objectForKey:@"sub_merchant_id"];
                if(subMarchantId && ![subMarchantId isEqualToString:@""])
                {
                    onDone(TRUE, subMarchantId);
                }
                else
                {
                    onDone(FALSE, @"Please try again.");
                }
            }
            else
            {
                onDone(FALSE, @"Please try again.");
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(onError)
        {
            onError(FALSE);
        }
        
    }];
    [op start];
    
}

- (void) makeSplitPayment:(NSString*) merId amount:(double) amount paymentmethod:(NSString*)paymentMethod tocustomerId:(NSString*)customerId onDone:(void(^)(BOOL , NSString*, NSString*))onDone onError:(void(^)(BOOL))onError
{
    if (merId == nil || customerId == nil || paymentMethod == nil)
    {
        onDone(FALSE, @"We are sorry, we cannot proccess payment at this time. Please check payment method.", @"");
        
    }
    else
    {
        NSDictionary *parameters = @{@"method": @"make_split_payment", @"amount" : @(amount), @"sub_merchant_id" : merId ,@"customer_id": customerId, @"payment_token" : paymentMethod};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                           options:(NSJSONWritingOptions)0
                                                             error:nil];
        NSString* URL = [NSString stringWithFormat:@"%@%@", ROOT_URL, SUBMERCHANT_SPLITPAYMENT];
        NSLog(@"JSON request %@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
        NSString* jSON = [NSString stringWithFormat:@"[%@]",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]
                                                               cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
        
        [request setHTTPMethod:@"POST"];
        [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody: [jSON dataUsingEncoding:NSUTF8StringEncoding]];
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        op.responseSerializer = [AFHTTPResponseSerializer serializer];
        op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSLog(@"JSON responseObject: %@ ",dict);
            NSDictionary* response = [dict objectForKey:@"Response"];
            NSString* statuscode = [response objectForKey:@"Code"];
            NSString* msg = [response objectForKey:@"Message"];
            msg = [msg stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
            if([statuscode intValue] != 200)
            {
                if(!msg) {
                    msg = @"Please try again.";
                }
                onDone(FALSE, msg, @"");
            }
            else
            {
                NSArray* result = [response objectForKey:@"result"];
                NSString* transactionId = @"";
                if(result.count > 0)
                {
                    dict  = result[0];
                    transactionId = [dict objectForKey:@"transaction_id"];
                }
                onDone(TRUE, msg, transactionId);
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(onError)
            {
                onError(FALSE);
            }
            
        }];
        [op start];
    }
}

- (void) addPaymentMethod:(NSString*)paymentMethod tocustomerId:(NSString*)customerId onDone:(void(^)(BOOL , NSString* paymenttoken, NSString* maskCardNumber))onDone onError:(void(^)(BOOL))onError
{
    
    NSDictionary *parameters = @{@"method": @"add_payment_method",@"customerId": customerId, @"paymentNonce" : paymentMethod};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:(NSJSONWritingOptions)0
                                                         error:nil];
    NSString* URL = [NSString stringWithFormat:@"%@%@", ROOT_URL, CREATE_CUSTOMER];
    NSLog(@"JSON request %@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    NSString* jSON = [NSString stringWithFormat:@"[%@]",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: [jSON dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"JSON responseObject: %@ ",dict);
        NSDictionary* response = [dict objectForKey:@"Response"];
        NSString* statuscode = [response objectForKey:@"Code"];
        NSString* msg = [response objectForKey:@"Message"];
        msg = [msg stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        if([statuscode intValue] != 200)
        {
            
            onDone(FALSE, msg, @"");
        }
        else
        {
            NSArray* result = [response objectForKey:@"result"];
            if(result.count > 0)
            {
                dict  = result[0];
                NSString* token = [dict objectForKey:@"token"];
                NSString* maskedNumber = [dict objectForKey:@"maskedNumber"];
                if(token && ![token isEqualToString:@""])
                {
                    onDone(TRUE, token, maskedNumber);
                }
                else
                {
                    onDone(FALSE, @"Please try again.", @"");
                }
            }
            else
            {
                onDone(FALSE, @"Please try again.", @"");
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(onError)
        {
            onError(FALSE);
        }
        
    }];
    [op start];
    
}

@end
