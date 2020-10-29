//
//  PaymentCell.m
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import "PaymentCell.h"

@implementation PaymentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) blindDataToShow:(id)object
{
    self.accessoryType = UITableViewCellAccessoryNone;
    if([object isKindOfClass:[NSString class]])
    {
        _PaymentIcon.image = [UIImage imageNamed:@"add_icon"];
        _PaymentName.text = object;
        CGRect frame = _PaymentName.frame;
        frame.origin.x = 53;
        _PaymentName.frame = frame;
    }
    else
    {
        CGRect frame = _PaymentName.frame;
        frame.origin.x = 58;
        _PaymentName.frame = frame;
        NSString* paymentType = object[@"PaymentType"];
        if ( [paymentType isEqualToString:@"PayPal"])
        {
            _PaymentIcon.image = [UIImage imageNamed:@"paypal"];
        }
        else
        {
            _PaymentIcon.image = [UIImage imageNamed:@"card"];
        }
        _PaymentName.text = object[@"PaymentName"];
        if([object[@"isSelected"] boolValue] == TRUE)
        {
            self.accessoryType = UITableViewCellAccessoryCheckmark;
            if(_PaymentDelegate)
            {
                [_PaymentDelegate paymentSelected:self];
            }
        }
    }
}

@end
