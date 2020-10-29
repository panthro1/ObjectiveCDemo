//
//  BraintreeProvider.h
//  doctor
//
//  Created by Thomas.Woodfin on 8/19/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Braintree/Braintree.h>
#import <Braintree/BTPayPalPaymentMethod.h>
#import <Braintree/BTCardPaymentMethod.h>
#import "CardIOPaymentViewController.h"
#import <Braintree/BTDropInContentView.h>
#import <CardIO/CardIOCreditCardInfo.h>

@protocol BraintreeProviderDelegate

@optional
- (void) braintreeProviderFinished:(BTPaymentMethod*) paymentmethod;

@end

@interface BraintreeProvider : NSObject<BTDropInViewControllerDelegate, CardIOPaymentViewControllerDelegate>
{
    BTDropInViewController *dropInViewController;
    UINavigationController *navigationController;
    BTPaymentMethod* paymentMethod;
}
@property (nonatomic, strong) Braintree *braintree;
@property (nonatomic, strong) id<BraintreeProviderDelegate> braintreeDelegate;
@property (nonatomic, strong) UIViewController *Controller;
+(BraintreeProvider*)sharedInstance;
-(void)presentDropUI:(UINavigationController*)nav delegate:(id)delegate;

@end


