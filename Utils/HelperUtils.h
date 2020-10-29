//
//  HelperUtils.h
//  doctor
//
//  Created by Thomas.Woodfin on 4/8/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelperUtils : NSObject

+ (UIImage *)imageNamed:(UIImage *)img withColor:(UIColor *)color;
+(BOOL)isReadyForBookDoctor;
+(void)setRememberLogin:(NSString*)usernameAndpass;
+(void)removeRememberLogin;
+(BOOL)isRemembered;
+(NSString*)rememberedInfo;
+(NSString*)encryptedPhoneNumber:(NSString*)phonenumber;

@end
