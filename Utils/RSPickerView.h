//
//  RSPickerView.h
//  BestBeaches
//
//  Created by Raghuveer Singh on 05/04/14.
//  Copyright (c) 2014 SquareBits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CDatePickerViewEx.h"

@class RSPickerView;

@protocol RSPickerDelegate

@optional
-(void)RSPicker:(RSPickerView *)picker didDismissWithSelection:(id)selection inTextField:(UITextField *)textField Response:(NSString*)response;
@end


typedef enum {
	RSPickerTypeStandard,
	RSPickerTypeDate,
	RSPickerTypeTime,
	RSPickerTypeYear,
	RSPickerTypeDateAndTime,
} RSPickerType;

@interface RSPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource,CDatePickerViewExDelegate>
@property (nonatomic, strong) NSString *responseSelected;

@property(nonatomic,strong)NSArray *options;
@property (nonatomic, weak) id <RSPickerDelegate> del;
@property (nonatomic) RSPickerType type;
@property (nonatomic) UIDatePickerMode dateMode;
- (id)initWithOptions:(NSArray *)option;
- (id)initWithDateMode:(UIDatePickerMode)mode;

-(void)showInView:(UIView *)view ;

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIDatePicker *timePicker;
@property (nonatomic, strong) CDatePickerViewEx *yearPicker;

@property (nonatomic, strong) UIToolbar *toolBar;
@end
