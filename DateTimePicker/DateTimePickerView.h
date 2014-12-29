//
//  DateTimePickerView.h
//  DateTimePicker https://github.com/Ericfengshi/DateTimePicker
//
//  Created by fengs on 14-11-24.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    timeDetail = 0,//具体时间(年 月 日 时 分)
    timeChinese = 1,//今天，明天，后天(日 时 分)
    dateDetail = 2,//日期选择(年 月 日)
} TimeType;


@protocol DateTimePickerViewDelegate <NSObject>
@optional
-(void)selectDate:(NSString *)result;
@end

@interface DateTimePickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,retain) UIView *pickView;
@property (nonatomic,retain) UIToolbar *toolBar;
@property (nonatomic,retain) UIPickerView *pickViewList;
@property (nonatomic,assign) id delegate;

@property (nonatomic,retain) NSMutableArray *yearArray;
@property (nonatomic,retain) NSMutableArray *monthArray;
@property (nonatomic,retain) NSMutableArray *daysArray;
@property (nonatomic,retain) NSMutableArray *hoursArray;
@property (nonatomic,retain) NSMutableArray *minutesArray;
@property (nonatomic,assign) int currentMonth;
@property (nonatomic,assign) int selectedYearRow;
@property (nonatomic,assign) int selectedMonthRow;
@property (nonatomic,assign) int selectedDayRow;
@property (nonatomic,assign) int selectedHourRow;
@property (nonatomic,assign) int selectedMinRow;

@property (nonatomic,assign) TimeType timeType;

-(id)initWithSize:(CGSize)size timeType:(TimeType)timeType title:(NSString*)title;
-(void)viewLoad:(NSDate *)date;
- (void)showInView:(UIView *)view;
@end
