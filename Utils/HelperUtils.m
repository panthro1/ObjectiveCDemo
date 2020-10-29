//
//  HelperUtils.m
//  doctor
//
//  Created by Thomas.Woodfin on 4/8/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import "HelperUtils.h"

@implementation HelperUtils

+ (UIImage *)imageNamed:(UIImage *)img withColor:(UIColor *)color
{
    //Create new context
    UIGraphicsBeginImageContextWithOptions(img.size, NO, [UIScreen mainScreen].scale);
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    // set the fill color
    [color setFill];
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    // Get Image from current context
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //return the color-burned image
    return coloredImg;
}

+(BOOL)isReadyForBookDoctor
{
    NSString* startDateStr = @"8:00AM";
    NSString* endDateStr = @"9:00PM";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"hh:mma"];
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:locale];
    
    NSString *nowDateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDate *firstTime   = [dateFormatter dateFromString:startDateStr];
    NSDate *secondTime  = [dateFormatter dateFromString:endDateStr];
    NSDate *nowTime     = [dateFormatter dateFromString:nowDateString];
    
    NSComparisonResult result1 = [nowTime compare:firstTime];
    NSComparisonResult result2 = [nowTime compare:secondTime];
    
    if ((result1 == NSOrderedDescending) &&
        (result2 == NSOrderedAscending)){
        return TRUE;
    }else{
        return FALSE;
    }
}

+(void)setRememberLogin:(NSString*)usernameAndpass
{
    NSUserDefaults* udf = [NSUserDefaults standardUserDefaults];
    [udf setObject:usernameAndpass forKey:@"setRememberLogin"];
    [udf synchronize];
}

+(void)removeRememberLogin
{
    NSUserDefaults* udf = [NSUserDefaults standardUserDefaults];
    [udf removeObjectForKey:@"setRememberLogin"];
    [udf synchronize];
}

+(BOOL)isRemembered
{
    NSUserDefaults* udf = [NSUserDefaults standardUserDefaults];
    NSString* usernameAndpass = [udf objectForKey:@"setRememberLogin"];
    [udf synchronize];
    return (usernameAndpass != nil);
}

+(NSString*)rememberedInfo
{
    NSUserDefaults* udf = [NSUserDefaults standardUserDefaults];
    NSString* usernameAndpass = [udf objectForKey:@"setRememberLogin"];
    [udf synchronize];
    return usernameAndpass;
}

/*
 * Hide phone number, only get last 4 number and show xxx-xxx-1234
 */
+(NSString*)encryptedPhoneNumber:(NSString*)phonenumber
{
    if (phonenumber == nil || phonenumber.length < 4) {
        return @"xxx-xxx-xxxx";
    }
    NSString* last4Number = [phonenumber substringFromIndex:phonenumber.length - 4];
    return [NSString stringWithFormat:@"xxx-xxx-%@",last4Number];
}

@end
