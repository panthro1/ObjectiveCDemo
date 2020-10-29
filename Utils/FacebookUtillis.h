//
//  FacebookUtillis.h
//  Glabber
//
//  Created by Raghuveer Singh on 25/01/14.
//  Copyright (c) 2014 foxinfosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
@protocol FBUtilityDelegate <NSObject>

	

@required

-(void)facebookCallBack:(BOOL)isGranted;
@end

@interface FacebookUtillis : NSObject
@property(nonatomic,strong)id<FBUtilityDelegate> delegate;
- (void)openSessionWithPublishPermissionsAllowLoginUI:(BOOL)allowLoginUI;

+(FacebookUtillis*)sharedInstance;
-(void)logOutFacebook;
-(void)loginFacebook;

@end
