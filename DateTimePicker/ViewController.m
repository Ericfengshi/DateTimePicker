//
//  ViewController.m
//  DateTimePicker
//
//  Created by fengs on 14-11-24.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize timeDetailTextField = _timeDetailTextField;
@synthesize datePicker1 = _datePicker1;

@synthesize timeChineseTextField = _timeChineseTextField;
@synthesize datePicker2 = _datePicker2;

@synthesize dateDetailTextField = _dateDetailTextField;
@synthesize datePicker3 = _datePicker3;

@synthesize selectDate = _selectDate;
@synthesize timeType = _timeType;

-(void)dealloc{

    self.timeDetailTextField = nil;
    self.datePicker1 = nil;
   
    self.timeChineseTextField = nil;
    self.datePicker2 = nil;
    
    self.dateDetailTextField = nil;
    self.datePicker3 = nil;
    
    self.selectDate = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.timeDetailTextField = nil;
    self.datePicker1 = nil;
    
    self.timeChineseTextField = nil;
    self.datePicker2 = nil;
    
    self.dateDetailTextField = nil;
    self.datePicker3 = nil;
    
    self.selectDate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.timeDetailTextField = [[[UITextField alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/4, 10, [UIScreen mainScreen].bounds.size.width/2, 30)] autorelease];
    self.timeDetailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.timeDetailTextField.placeholder = @"具体时间";
    self.timeDetailTextField.delegate = self;
    self.timeDetailTextField.tag = 1;
    [self.view addSubview:self.timeDetailTextField];
    
    DateTimePickerView *selectDatePicker1 = [[[DateTimePickerView alloc] initWithSize:CGSizeMake(320, 280) timeType:timeDetail title:@"具体时间"] autorelease];
    selectDatePicker1.delegate = self;
    self.datePicker1 = selectDatePicker1;
    
    self.timeChineseTextField = [[[UITextField alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/4, 50, [UIScreen mainScreen].bounds.size.width/2, 30)] autorelease];
    self.timeChineseTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.timeChineseTextField.placeholder = @"今天，明天，后天";
    self.timeChineseTextField.delegate = self;
    self.timeChineseTextField.tag = 2;
    [self.view addSubview:self.timeChineseTextField];
    
    DateTimePickerView *selectDatePicker2 = [[[DateTimePickerView alloc] initWithSize:CGSizeMake(320, 280) timeType:timeChinese title:@"今天，明天，后天"] autorelease];
    selectDatePicker2.delegate = self;
    self.datePicker2 = selectDatePicker2;

    self.dateDetailTextField = [[[UITextField alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/4, 90, [UIScreen mainScreen].bounds.size.width/2, 30)] autorelease];
    self.dateDetailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.dateDetailTextField.placeholder = @"日期选择";
    self.dateDetailTextField.delegate = self;
    self.dateDetailTextField.tag = 3;
    [self.view addSubview:self.dateDetailTextField];
    
    DateTimePickerView *selectDatePicker3 = [[[DateTimePickerView alloc] initWithSize:CGSizeMake(320, 280) timeType:dateDetail title:@"日期选择"] autorelease];
    selectDatePicker3.delegate = self;
    self.datePicker3 = selectDatePicker3;
    
    
    self.selectDate = [NSDate date];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// 代理方法
-(void)selectDate:(NSString *)result{
    if (result == nil) {
        return;
    }
    NSDateFormatter *formater = [[[NSDateFormatter alloc] init] autorelease];
    if (self.timeType == timeDetail) {
        
        [formater setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
        NSDate *resultDate = [formater dateFromString:result];
        self.selectDate = resultDate;
        [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
        self.timeDetailTextField.text =  [NSString stringWithFormat:@"%@",[formater stringFromDate:self.selectDate]];
        
    }else if(self.timeType == timeChinese){
    
        [formater setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
        NSDate *resultDate = [formater dateFromString:result];
        self.selectDate = resultDate;
        [formater setDateFormat:@"MM-dd HH:mm"];
        self.timeChineseTextField.text =  [NSString stringWithFormat:@"%@",[formater stringFromDate:self.selectDate]];
        
    }else if(self.timeType == dateDetail){
        
        [formater setDateFormat:@"yyyy年MM月dd日"];
        NSDate *resultDate = [formater dateFromString:result];
        self.selectDate = resultDate;
        [formater setDateFormat:@"yyyy-MM-dd"];
        self.dateDetailTextField.text =  [NSString stringWithFormat:@"%@",[formater stringFromDate:self.selectDate]];
    }

}

#pragma mark -
#pragma mark -textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    NSDateFormatter *formater = [[[NSDateFormatter alloc] init] autorelease];
    if (textField.tag == 1) {
        if (![textField.text isEqualToString:@""] && textField.text != nil) {
            [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSDate *resultDate = [formater dateFromString:textField.text];
            self.selectDate = resultDate;
        }else{
            self.selectDate = [NSDate date];
        }
        self.timeType = timeDetail;
        [self.datePicker1 viewLoad:self.selectDate];
        [self.datePicker1 showInView:self.view];
    }else if(textField.tag == 2){
        if (![textField.text isEqualToString:@""] && textField.text != nil) {
            [formater setDateFormat:@"MM-dd HH:mm"];
            NSDate *resultDate = [formater dateFromString:textField.text];
            self.selectDate = resultDate;
        }else{
            self.selectDate = [NSDate date];
        }
        self.timeType = timeChinese;
        [self.datePicker2 viewLoad:self.selectDate];
        [self.datePicker2 showInView:self.view];
    }else if(textField.tag == 3){
        if (![textField.text isEqualToString:@""] && textField.text != nil) {
            [formater setDateFormat:@"yyyy-MM-dd"];
            NSDate *resultDate = [formater dateFromString:textField.text];
            self.selectDate = resultDate;
        }else{
            self.selectDate = [NSDate date];
        }
        self.timeType = dateDetail;
        [self.datePicker3 viewLoad:self.selectDate];
        [self.datePicker3 showInView:self.view];

    }
    return NO;
}


@end
