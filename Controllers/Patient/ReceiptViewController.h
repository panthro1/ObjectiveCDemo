//
//  ReceiptViewController.h
//  doctor
//
//  Created by Thomas Woodfin on 12/7/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface ReceiptViewController : BaseViewController
{
    IBOutlet UITextView* _commentsTextView;
    IBOutlet UILabel* _priceLabel;
    IBOutlet UIImageView* _doctorImageView;
    IBOutlet UILabel* _doctorNameLabel;
}

/*
 * Doctor rate control
 */
@property (strong, nonatomic) IBOutlet HCSStarRatingView *starRatingView;


- (IBAction)receiptSubmit:(id)sender;
- (IBAction)didChangeValue:(id)sender;
- (IBAction)skipReviewAction:(id)sender;

@end
