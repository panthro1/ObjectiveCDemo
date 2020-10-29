//
//  UIColor + Hex.h
//  Pijons
//
//  Created by Thomas Woodfin on 11/9/15.
//  Copyright © 2015 Vinasource. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;

+ (UIColor *)colorWithHex:(UInt32)hex;
+ (UIColor *)colorWithHexString:(id)input;

- (UInt32)hexValue;

@end
