//
//  ImageCaptureView.m
//  doctor
//
//  Created by Muhammad Imran on 12/12/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import "ImageCaptureView.h"

@implementation ImageCaptureView

- (void)awakeFromNib {
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor orangeColor].CGColor;
    self.layer.cornerRadius = 5;
    [super awakeFromNib];
}


@end
