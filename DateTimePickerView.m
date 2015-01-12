//
//  DateTimePickerView.m
//  DateTimePicker https://github.com/Ericfengshi/DateTimePicker
//
//  Created by fengs on 14-11-24.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import "DateTimePickerView.h"

@implementation DateTimePickerView
@synthesize window;
@synthesize shadowView = _shadowView;
@synthesize pickView = _pickView;
@synthesize toolBar = _toolBar;
@synthesize pickViewList = _pickViewList;
@synthesize delegate = _delegate;

@synthesize yearArray = _yearArray;
@synthesize monthArray = _monthArray;
@synthesize daysArray = _daysArray;
@synthesize hoursArray = _hoursArray;
@synthesize minutesArray = _minutesArray;
@synthesize selectedYearRow = _selectedYearRow;
@synthesize selectedMonthRow = _selectedMonthRow;
@synthesize selectedDayRow = _selectedDayRow;
@synthesize selectedHourRow = _selectedHourRow;
@synthesize selectedMinRow = _selectedMinRow;
@synthesize timeType = _timeType;

-(void)dealloc
{
    self.shadowView = nil;
    self.pickView = nil;
    self.toolBar = nil;
    self.pickViewList = nil;
    
    self.yearArray=nil;
    self.monthArray=nil;
    self.daysArray=nil;
    self.hoursArray=nil;
    self.minutesArray=nil;
	[super dealloc];
}

-(id)initWithTitle:(NSString*)title timeType:(TimeType)timeType delegate:(id)delegate{
    self = [super init];
    if (self)
	{
        id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
        if ([appDelegate respondsToSelector:@selector(window)]){
            window = [appDelegate performSelector:@selector(window)];
        }else{
            window = [[UIApplication sharedApplication] keyWindow];
        }

        self.shadowView = [[[UIView alloc] init] autorelease];
        
        self.delegate = delegate;
        self.timeType = timeType;
        self.pickView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,216+44)] autorelease];
		self.pickView.backgroundColor = [UIColor underPageBackgroundColor];
        
		self.toolBar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)] autorelease];
		self.toolBar.barStyle = UIBarStyleDefault;
		
		UIBarButtonItem *titleButton = [[[UIBarButtonItem alloc] initWithTitle:title style: UIBarButtonItemStylePlain target: nil action: nil] autorelease];
		UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc] initWithTitle:@"完成" style: UIBarButtonItemStyleDone target: self action: @selector(actionDone)] autorelease];
		UIBarButtonItem *leftButton = [[[UIBarButtonItem alloc] initWithTitle:@"取消" style: UIBarButtonItemStyleBordered target: self action: @selector(actionCancel)] autorelease];
		UIBarButtonItem *fixedButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil] autorelease];
		NSArray *array = [[[NSArray alloc] initWithObjects: leftButton,fixedButton, titleButton,fixedButton,rightButton, nil] autorelease];
		[self.toolBar setItems: array];
		[self.pickView addSubview:self.toolBar];
        
        UIPickerView *pickList = [[[UIPickerView alloc] initWithFrame:CGRectMake(0, self.toolBar.frame.size.height,[UIScreen mainScreen].applicationFrame.size.width,216)] autorelease];
        pickList.showsSelectionIndicator = YES;
        pickList.delegate = self;
        pickList.dataSource = self;
        self.pickViewList = pickList;
        [self.pickView addSubview:pickList];
        
        [self addSubview:self.pickView];
        
        [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.pickView.frame.size.height, [UIScreen mainScreen].bounds.size.width, self.pickView.frame.size.height)];
    }
    return self;
}

-(void)viewLoad:(NSDate *)date{
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    // Get Current  Hour
    [formatter setDateFormat:@"HH"];
    NSString *currentHourString = [NSString stringWithFormat:@"%02d时",[[formatter stringFromDate:date] integerValue]];
    
    // Get Current  Minutes
    [formatter setDateFormat:@"mm"];
    NSString *currentMinutesString = [NSString stringWithFormat:@"%02d分",[[formatter stringFromDate:date] integerValue]];
    
    
    // PickerView -  Hours data
    self.hoursArray = [[[NSMutableArray alloc]init] autorelease];
    for (int i = 0; i < 24 ; i++)
    {
        [self.hoursArray addObject:[NSString stringWithFormat:@"%02d时",i]];
    }
    
    // PickerView -  Mins data
    self.minutesArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < 60; i++)
    {
        [self.minutesArray addObject:[NSString stringWithFormat:@"%02d分",i]];
    }
    
    
    
    if (self.timeType==timeDetail) {//timeDetail
        // Get Current Year
        [formatter setDateFormat:@"yyyy"];
        NSString *currentYearString = [NSString stringWithFormat:@"%@年",[formatter stringFromDate:date]];
        
        // Get Current  Month
        [formatter setDateFormat:@"MM"];
        NSString *currentMonthString = [NSString stringWithFormat:@"%d月",[[formatter stringFromDate:date] integerValue]];
        
        // Get Current  Date
        [formatter setDateFormat:@"dd"];
        NSString *currentDateString = [NSString stringWithFormat:@"%d日",[[formatter stringFromDate:date] integerValue]];
        
        // PickerView -  Years data
        self.yearArray = [[[NSMutableArray alloc] init] autorelease];
        for (int i = 1970; i <= 2050 ; i++)
        {
            [self.yearArray addObject:[NSString stringWithFormat:@"%d年",i]];
        }
        
        // PickerView -  Months data
        self.monthArray = [[[NSMutableArray alloc] init] autorelease];
        for (int i = 1; i <= 12 ; i++)
        {
            [self.monthArray addObject:[NSString stringWithFormat:@"%d月",i]];
        }
        
        // PickerView -  Days data
        self.daysArray = [[[NSMutableArray alloc] init] autorelease];
        for (int i = 1; i <= 31; i++)
        {
            [self.daysArray addObject:[NSString stringWithFormat:@"%d日",i]];
        }
        
        // PickerView - Default Selection as per current Date
        [self.pickViewList selectRow:[self.yearArray indexOfObject:currentYearString] inComponent:0 animated:YES];
        [self.pickViewList selectRow:[self.monthArray indexOfObject:currentMonthString] inComponent:1 animated:YES];
        [self.pickViewList selectRow:[self.daysArray indexOfObject:currentDateString] inComponent:2 animated:YES];
        [self.pickViewList selectRow:[self.hoursArray indexOfObject:currentHourString] inComponent:3 animated:YES];
        [self.pickViewList selectRow:[self.minutesArray indexOfObject:currentMinutesString] inComponent:4 animated:YES];
    }else if(self.timeType==timeChinese){//timeChinese
        
        // PickerView -  Days data
        self.daysArray = [[[NSMutableArray alloc] initWithArray:@[@"今天",@"明天",@"后天"]] autorelease];
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *today=[formatter dateFromString:[formatter stringFromDate:[NSDate date]]];
        date=[formatter dateFromString:[formatter stringFromDate:date]];
        
        NSTimeInterval secondsPerDay = 24 * 60 * 60;
        NSDate *tomorrow = [NSDate dateWithTimeInterval:secondsPerDay sinceDate:today];
        NSDate *theDayAfterTomorrow = [NSDate dateWithTimeInterval:secondsPerDay*2 sinceDate:today];
        NSString *currentDateString = @"";
        if ([date compare:today] == NSOrderedSame) {
            currentDateString=@"今天";
        }else if ([date compare:tomorrow] == NSOrderedSame) {
            currentDateString=@"明天";
        }else if ([date compare:theDayAfterTomorrow] == NSOrderedSame) {
            currentDateString=@"后天";
        }
        
        // PickerView - Default Selection as per current Date
        [self.pickViewList selectRow:[self.daysArray indexOfObject:currentDateString] inComponent:0 animated:YES];
        [self.pickViewList selectRow:[self.hoursArray indexOfObject:currentHourString] inComponent:1 animated:YES];
        [self.pickViewList selectRow:[self.minutesArray indexOfObject:currentMinutesString] inComponent:2 animated:YES];
        
    }else{//dateDetail
        // Get Current Year
        [formatter setDateFormat:@"yyyy"];
        NSString *currentYearString = [NSString stringWithFormat:@"%@年",[formatter stringFromDate:date]];
        
        // Get Current  Month
        [formatter setDateFormat:@"MM"];
        NSString *currentMonthString = [NSString stringWithFormat:@"%d月",[[formatter stringFromDate:date] integerValue]];
        
        // Get Current  Date
        [formatter setDateFormat:@"dd"];
        NSString *currentDateString = [NSString stringWithFormat:@"%d日",[[formatter stringFromDate:date] integerValue]];
        
        // PickerView -  Years data
        self.yearArray = [[[NSMutableArray alloc] init] autorelease];
        for (int i = 1970; i <= 2050 ; i++)
        {
            [self.yearArray addObject:[NSString stringWithFormat:@"%d年",i]];
        }
        
        // PickerView -  Months data
        self.monthArray = [[[NSMutableArray alloc] init] autorelease];
        for (int i = 1; i <= 12 ; i++)
        {
            [self.monthArray addObject:[NSString stringWithFormat:@"%d月",i]];
        }
        
        // PickerView -  Days data
        self.daysArray = [[[NSMutableArray alloc] init] autorelease];
        for (int i = 1; i <= 31; i++)
        {
            [self.daysArray addObject:[NSString stringWithFormat:@"%d日",i]];
        }
        
        // PickerView - Default Selection as per current Date
        [self.pickViewList selectRow:[self.yearArray indexOfObject:currentYearString] inComponent:0 animated:YES];
        [self.pickViewList selectRow:[self.monthArray indexOfObject:currentMonthString] inComponent:1 animated:YES];
        [self.pickViewList selectRow:[self.daysArray indexOfObject:currentDateString] inComponent:2 animated:YES];
    }
    
}

#pragma mark - 
#pragma mark - UIPickerViewDelegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.timeType==timeDetail) {//timeDetail
        if (component == 0)
        {
            self.selectedYearRow = row;
        }
        else if (component == 1)
        {
            self.selectedMonthRow = row;
            [self.pickViewList reloadComponent:2];
        }
        else if (component == 2)
        {
            self.selectedDayRow = row;
        }
        else if (component == 3)
        {
            self.selectedHourRow = row;
        }
        else if (component == 4)
        {
            self.selectedMinRow = row;
        }
    }else if(self.timeType == timeChinese){//timeChinese
        if (component == 0)
        {
            self.selectedDayRow = row;
        }
        else if (component == 1)
        {
            self.selectedHourRow = row;
        }
        else
        {
            self.selectedMinRow = row;
        }
    }else{//dateDetail
        if (component == 0)
        {
            self.selectedYearRow = row;
        }
        else if (component == 1)
        {
            self.selectedMonthRow = row;
            [self.pickViewList reloadComponent:2];
        }
        else if (component == 2)
        {
            self.selectedDayRow = row;
        }
    }
    
    [self.pickViewList reloadComponent:component];
}

#pragma mark - 
#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)reusingView {
    
    // Custom View created for each component
    
    UILabel *pickerLabel = (UILabel *)reusingView;
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        [pickerLabel setTextAlignment:UITextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        pickerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
        pickerLabel.textColor = [UIColor blackColor];
    }
    
    if (self.timeType==timeDetail) {//timeDetail
        
        if (component == 0)
        {
            pickerLabel.text =  [self.yearArray objectAtIndex:row]; // Year
        }
        else if (component == 1)
        {
            pickerLabel.text = [self.monthArray objectAtIndex:row];  // Month
        }
        else if (component == 2)
        {
            pickerLabel.text =  [self.daysArray objectAtIndex:row]; // Date
            
        }
        else if (component == 3)
        {
            pickerLabel.text =  [self.hoursArray objectAtIndex:row]; // Hours
        }
        else if (component == 4)
        {
            pickerLabel.text =  [self.minutesArray objectAtIndex:row]; // Mins
        }
        
    }else if(self.timeType == timeChinese){//timeChinese
        if (component == 0)
        {
            pickerLabel.text =  [self.daysArray objectAtIndex:row]; // Date
        }
        else if (component == 1)
        {
            pickerLabel.text =  [self.hoursArray objectAtIndex:row]; // Hours
        }
        else
        {
            pickerLabel.text =  [self.minutesArray objectAtIndex:row]; // Mins
        }
    }else{//dateDetail
        if (component == 0)
        {
            pickerLabel.text =  [self.yearArray objectAtIndex:row]; // Year
        }
        else if (component == 1)
        {
            pickerLabel.text = [self.monthArray objectAtIndex:row];  // Month
        }
        else if (component == 2)
        {
            pickerLabel.text =  [self.daysArray objectAtIndex:row]; // Date
            
        }
    }
    
    return pickerLabel;
    
}


//返回组件数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    if (self.timeType == timeDetail) {//timeDetail
        return 5;
    }else if(self.timeType == timeChinese){
        return 3;
    }else{//dateDetail
        return 3;
    }
}

// returns the # of rows in each component..
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (self.timeType == timeDetail) {//timeDetail
        if (component == 0)
        {
            return [self.yearArray count];
            
        }
        else if (component == 1)
        {
            return [self.monthArray count];
        }
        else if (component == 2)
        { // day
            if (self.selectedMonthRow == 0 || self.selectedMonthRow == 2 || self.selectedMonthRow == 4 || self.selectedMonthRow == 6 || self.selectedMonthRow == 7 || self.selectedMonthRow == 9 || self.selectedMonthRow == 11)
            {
                return 31;
            }
            else if (self.selectedMonthRow == 1)
            {
                int yearint = [[self.yearArray objectAtIndex:self.selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
            }
            else
            {
                return 30;
            }
        }
        else if (component == 3)
        { // hour
            return 24;
        }
        else
        { // min
            return 60;
        }
        
    }else if(self.timeType == timeChinese){//timehinese
        if (component == 0)
        { // day
            return 3;
        }
        else if (component == 1)
        { // hour
            return 24;
        }
        else
        { // min
            return 60;
        }
    }else{//dateDetail
        if (component == 0)
        {
            return [self.yearArray count];
        }
        else if (component == 1)
        {
            return [self.monthArray count];
        }
        else
        { // day
            if (self.selectedMonthRow == 0 || self.selectedMonthRow == 2 || self.selectedMonthRow == 4 || self.selectedMonthRow == 6 || self.selectedMonthRow == 7 || self.selectedMonthRow == 9 || self.selectedMonthRow == 11)
            {
                return 31;
            }
            else if (self.selectedMonthRow == 1)
            {
                int yearint = [[self.yearArray objectAtIndex:self.selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
            }
            else
            {
                return 30;
            }
        }
    }
}


#pragma mark -
#pragma mark - Others

// 选择完成
-(void)actionDone
{
    if (self.timeType == timeDetail) {//timeDetail
        [self.delegate selectDate:[NSString stringWithFormat:@"%@%@%@ %@%@",[self.yearArray objectAtIndex:[self.pickViewList selectedRowInComponent:0]],[self.monthArray objectAtIndex:[self.pickViewList selectedRowInComponent:1]],[self.daysArray objectAtIndex:[self.pickViewList selectedRowInComponent:2]],[self.hoursArray objectAtIndex:[self.pickViewList selectedRowInComponent:3]],[self.minutesArray objectAtIndex:[self.pickViewList selectedRowInComponent:4]]]];
    }else if(self.timeType == timeChinese){//timeChinese
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSDate *todayDate=[formatter dateFromString:[formatter stringFromDate:[NSDate date]]];
        NSTimeInterval secondsPerDay = 24 * 60 * 60;
        if ([[self.daysArray objectAtIndex:[self.pickViewList selectedRowInComponent:0]] isEqual:@"明天"]) {
            todayDate=[NSDate dateWithTimeInterval:secondsPerDay sinceDate:todayDate];
        }else if ([[self.daysArray objectAtIndex:[self.pickViewList selectedRowInComponent:0]] isEqual:@"后天"]) {
            todayDate=[NSDate dateWithTimeInterval:secondsPerDay*2 sinceDate:todayDate];
        }
        
        [self.delegate selectDate:[NSString stringWithFormat:@"%@ %@%@",[formatter stringFromDate:todayDate],[self.hoursArray objectAtIndex:[self.pickViewList selectedRowInComponent:1]],[self.minutesArray objectAtIndex:[self.pickViewList selectedRowInComponent:2]]]];

    }else{
        [self.delegate selectDate:[NSString stringWithFormat:@"%@%@%@",[self.yearArray objectAtIndex:[self.pickViewList selectedRowInComponent:0]],[self.monthArray objectAtIndex:[self.pickViewList selectedRowInComponent:1]],[self.daysArray objectAtIndex:[self.pickViewList selectedRowInComponent:2]]]];
    }
    [self hidePickerView];
}

// 取消选择
-(void)actionCancel
{
    [self.delegate selectDate:nil];
    [self hidePickerView];
}

// UIPicker显示
- (void)showInView
{
    [self.shadowView setFrame:window.frame];
    [window addSubview:self.shadowView];
    
    [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.pickView.frame.size.height, [UIScreen mainScreen].bounds.size.width, self.pickView.frame.size.height)];
    [self.shadowView addSubview:self];
    
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^(void){
        self.shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
    } completion:^(BOOL isFinished){
        
    }];
}

// UIPicker隐藏
-(void)hidePickerView
{
    [self.shadowView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^(void){
        self.shadowView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL isFinished){
        [self.shadowView removeFromSuperview];
    }];
}
@end
