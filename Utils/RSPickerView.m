//
//  RSPickerView.m
//  BestBeaches
//
//  Created by Raghuveer Singh on 05/04/14.
//  Copyright (c) 2014 SquareBits. All rights reserved.
//

#import "RSPickerView.h"


#define PICKER_FRAME CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-162, [[UIScreen mainScreen] bounds].size.width, 216)
#define TOOLBAR_FRAME CGRectMake(0,[[UIScreen mainScreen] bounds].size.height-162-44,[[UIScreen mainScreen] bounds].size.width,44)


@implementation RSPickerView
@synthesize options,toolBar,dateMode;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
	    
	       }
    return self;
}
- (id)initWithOptions:(NSArray *)option
{
	
	CGSize result = [[UIScreen mainScreen] bounds].size;
	NSLog(@"%f,%f",result.width,result.height);
	
//	_picker=[[UIPickerView alloc] initWithFrame:PICKER_FRAME];
//	[_picker setBackgroundColor:[UIColor whiteColor]];
//	self = [self initWithFrame:];
	self.options=option;

	
	
	self = [super initWithFrame:CGRectMake(0, 0, result.width, result.height)];
	if (self) {
		// Initialization code

//		[self addSubview:toolBar];
//		[self addSubview:_picker];
		
		[self setBackgroundColor:[UIColor clearColor]];
		

		
	}


	return self;
}
- (id)initWithDateMode:(UIDatePickerMode)mode
{
	
	CGSize result = [[UIScreen mainScreen] bounds].size;
	NSLog(@"%f,%f",result.width,result.height);
	
	//	_picker=[[UIPickerView alloc] initWithFrame:PICKER_FRAME];
	//	[_picker setBackgroundColor:[UIColor whiteColor]];
	//	self = [self initWithFrame:];
	self.options=nil;
	self.dateMode=mode;


	self = [super initWithFrame:CGRectMake(0, 0, result.width, result.height)];
	if (self) {
		// Initialization code
		
		//		[self addSubview:toolBar];
		//		[self addSubview:_picker];

		[self setBackgroundColor:[UIColor clearColor]];
		
		
		
	}
	

	return self;
}

-(UIToolbar *)toolBar
{
	
	if (!toolBar)
	{
		toolBar= [[UIToolbar alloc] initWithFrame:TOOLBAR_FRAME];
		//		[toolBar setBackgroundColor:[UIColor blackColor]];
		//		[toolBar setAlpha:.7];
		[toolBar setBarStyle:UIBarStyleBlack];
		[toolBar setTranslucent:YES];
		
		UIBarButtonItem *flexibleSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
		UIBarButtonItem *barButtonDone=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hide:)];
		[barButtonDone setTag:100];
		UIBarButtonItem *barButtonCancel=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hide:)];
		
		
		barButtonDone.tintColor=[UIColor whiteColor];
		barButtonCancel.tintColor=[UIColor whiteColor];
		
		[toolBar setItems:[NSArray arrayWithObjects:barButtonCancel,flexibleSpace,barButtonDone, nil]];

	}
	
	return toolBar;

}
//-(void)setDateeMode:(UIDatePickerMode)dateModee{
//	
//	if (!dateModee)
//	{
//		self.dateMode=UIDatePickerModeDate;
//	}
//	else
//	self.dateMode = dateModee;
//	self.type = RSPickerTypeDate;
//	
//	
//	
//}

-(void)setType:(RSPickerType)type{
	_type = type;
	
	if(_type == RSPickerTypeDate){
		[self.picker removeFromSuperview];
		[self.timePicker removeFromSuperview];
		[self.yearPicker removeFromSuperview];

		[self addSubview:self.datePicker];
		[self addSubview:self.toolBar];
	} else if(_type == RSPickerTypeStandard){
		[self.datePicker removeFromSuperview];
		[self.timePicker removeFromSuperview];
		[self.yearPicker removeFromSuperview];

		[self addSubview:self.picker];
		[self addSubview:self.toolBar];

	}
	else if(_type == RSPickerTypeTime){
		[self.picker removeFromSuperview];
		[self.datePicker removeFromSuperview];
		[self.yearPicker removeFromSuperview];
		[self addSubview:self.timePicker];
		[self addSubview:self.toolBar];
	}
	else if(_type == RSPickerTypeYear){
		[self.picker removeFromSuperview];
		[self.datePicker removeFromSuperview];
		[self.timePicker removeFromSuperview];

		[self addSubview:self.yearPicker];
		[self addSubview:self.toolBar];
	}
	
}
-(UIDatePicker *)datePicker{
	if(!_datePicker)
	{
		_datePicker = [[UIDatePicker alloc] initWithFrame:PICKER_FRAME];
		[_datePicker setDatePickerMode:self.dateMode];
		_datePicker.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:.9];

	}
	return _datePicker;
}
-(CDatePickerViewEx *)yearPicker{
	if(!_yearPicker){
		_yearPicker = [[CDatePickerViewEx alloc] initWithFrame:PICKER_FRAME];
		_yearPicker.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:.9];
		_yearPicker.del=self;
		
		
	}
	return _yearPicker;
}
-(void)CDatePickerViewEx:(CDatePickerViewEx *)picker didDismissWithSelection:(id)selection inTextField:(UITextField *)textField Response:(NSString *)response
{

	[_del RSPicker:self didDismissWithSelection:nil inTextField:nil Response:response];
	NSLog(@"respinse %@",response);

}
-(UIDatePicker *)timePicker{
	if(!_timePicker){
		_timePicker = [[UIDatePicker alloc] initWithFrame:PICKER_FRAME];
		_timePicker.datePickerMode = UIDatePickerModeTime;
		_timePicker.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:.9];
		
	}
	return _timePicker;
}


-(UIPickerView *)picker{
	if(!_picker){
		_picker = [[UIPickerView alloc] initWithFrame:PICKER_FRAME];
		_picker.showsSelectionIndicator = YES;
		_picker.backgroundColor=[UIColor whiteColor];
		_picker.dataSource = self;
		_picker.delegate = self;
	}
	return _picker;
}
-(void)hide:(UIBarButtonItem*)btn
{
	
	
	if (btn.tag==100) //barbutton Done Clicked
	{
		
		if(self.type == RSPickerTypeStandard)
		[_del RSPicker:self didDismissWithSelection:nil inTextField:nil Response:[options objectAtIndex:[_picker selectedRowInComponent:0]]];
		else if(self.type == RSPickerTypeDate)
		{
			
			if (self.dateMode!=UIDatePickerModeDateAndTime)
			{
				

				
				[self setDefaultValue:[[NSString stringWithFormat:@"%@", self.datePicker.date] substringToIndex:10]];
			}
			else
			{
				NSDateFormatter *df = [[NSDateFormatter alloc] init];
//				[df setDateFormat:@"yyyy/MM/dd hh:mm:ss a"];
				[df setDateFormat:@"EEE MMM d, yyyy hh:mm a"];
				[self setDefaultValue:[NSString stringWithFormat:@"%@", [df stringFromDate:self.datePicker.date]]];
			}
			
		  
		  [_del RSPicker:self didDismissWithSelection:nil inTextField:nil Response:self.responseSelected];
		}
		else if(self.type == RSPickerTypeTime)
		{
			
			NSDateFormatter *datePickerFormat = [[NSDateFormatter alloc] init];
			[datePickerFormat setDateFormat:@"hh:mm a"];
			NSString *datePickerStringToSave = [datePickerFormat stringFromDate:_timePicker.date];
//			NSLog(@"%@", datePickerStringToSave);
			[self setDefaultValue:datePickerStringToSave];
			[_del RSPicker:self didDismissWithSelection:nil inTextField:nil Response:self.responseSelected];
		}
		else if(self.type == RSPickerTypeYear)
		{
		
			
//			NSCalendar* calendar = [NSCalendar currentCalendar];
//			NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.yearPicker.date]; // Get necessary date components
//			
//			[components month]; //gives you month
//			[components year]; // gives you year
			
			NSDateFormatter *datePickerFormat = [[NSDateFormatter alloc] init];
			[datePickerFormat setDateFormat:@"yyyy/MM/dd"];
			NSString *datePickerStringToSave = [datePickerFormat stringFromDate:_yearPicker.date];

			
			[self setDefaultValue:datePickerStringToSave];
			[_del RSPicker:self didDismissWithSelection:nil inTextField:nil Response:self.responseSelected];
		}
		
	}
	[self removeFromSuperview];
}
-(void)setDefaultValue:(NSString *)value{
	
	self.responseSelected=value;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return options.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [options objectAtIndex:row];
}

#pragma mark - Actions

-(void)showInView:(UIView *)view {
	
	if(self.type == RSPickerTypeStandard && !self.options){
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Options Specified"
											  message:@"You must set values to the pickerOptions property before proceeding"
											 delegate:nil
									  cancelButtonTitle:@"OK"
									  otherButtonTitles:nil];
		[alert show];
	} else {
		[UIView animateWithDuration:0.25 animations:^{
//			[super showInView:[[UIApplication sharedApplication] keyWindow]];
			[[[UIApplication sharedApplication] keyWindow] addSubview:self];
//			[self setBounds:PICKER_SHEET_BOUNDS];
		} completion:^(BOOL finished) {
			[self removeKeyboardFromView:view];
		}];
	}
}
-(void)removeKeyboardFromView:(UIView*)view
{
	[view endEditing:YES];
}
@end
