//
//  PaymentCell.h
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PaymentCellDelegate

-(void)paymentSelected:(UITableViewCell*)cell;

@end

@interface PaymentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *PaymentIcon;
@property (weak, nonatomic) id<PaymentCellDelegate> PaymentDelegate;
@property (weak, nonatomic) IBOutlet UILabel *PaymentName;
//Methods
-(void) blindDataToShow:(id)object;

@end
