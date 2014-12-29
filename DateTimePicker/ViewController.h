//
//  ViewController.h
//  DateTimePicker
//
//  Created by fengs on 14-11-24.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTimePickerView.h"

@interface ViewController : UIViewController<UITextFieldDelegate,DateTimePickerViewDelegate>

@property (nonatomic,retain) UITextField *timeDetailTextField;
@property (nonatomic,retain) DateTimePickerView *datePicker1;

@property (nonatomic,retain) UITextField *timeChineseTextField;
@property (nonatomic,retain) DateTimePickerView *datePicker2;

@property (nonatomic,retain) UITextField *dateDetailTextField;
@property (nonatomic,retain) DateTimePickerView *datePicker3;

@property (nonatomic,retain) NSDate *selectDate;

@property (nonatomic,assign) TimeType timeType;


-(void)selectDate:(NSString *)result;
@end
