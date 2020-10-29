//
//  AddressEntryCell.m
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import "AddressEntryCell.h"
#import "UIImageView+AFNetworking.h"
#import "LPImage.h"

@implementation AddressEntryCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setImageForCellfromURL:(NSString *)URL withColor:(UIColor *)color
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    __weak AddressEntryCell *weakCell = self;
    [self._leftIconImg setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        weakCell._leftIconImg.image = [[image imageTintedWithColor:color] changeImageSize:CGSizeMake(24.0f, 24.0f)];
        
    } failure:nil];
}

@end
