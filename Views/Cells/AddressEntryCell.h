//
//  AddressEntryCell.h
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressEntryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *_leftIconImg;
@property (strong, nonatomic) IBOutlet UILabel *_nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *_addressLbl;
//Methods
- (void)setImageForCellfromURL:(NSString *)URL withColor:(UIColor *)color;

@end
