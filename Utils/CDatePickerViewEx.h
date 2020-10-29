//
//  CDatePickerViewEx.h
//  MonthYearDatePicker
//
//  Created by Igor on 18.03.13.
//  Copyright (c) 2013 Igor. All rights reserved.
//
#import <UIKit/UIKit.h>
@class CDatePickerViewEx;

@protocol CDatePickerViewExDelegate

@optional
-(void)CDatePickerViewEx:(CDatePickerViewEx *)picker didDismissWithSelection:(id)selection inTextField:(UITextField *)textField Response:(NSString*)response;
@end

@interface CDatePickerViewEx : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong, readonly) NSDate *date;
@property (nonatomic, weak) id <CDatePickerViewExDelegate> del;

-(void)selectToday;

@end
