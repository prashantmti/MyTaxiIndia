//
//  BaseView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/16/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceClass.h"
#import "CustomBarButton.h"
#import "SWRevealViewController.h"


#import "AppDelegate.h"
#import "ModalGlobal.h"

@interface BaseView : UIViewController<NSURLSessionDelegate,UIPickerViewDataSource,UIPickerViewDelegate,SWRevealViewControllerDelegate,UIGestureRecognizerDelegate>
{
    UIPickerView *pickerView;
    NSArray *pickerDataArray;
    NSInteger indexPickerView;
    UIToolbar *pickerViewtoolBar;
    
    
    UIToolbar *toolBar;
    
    UITextField *currentTextField;
    
}
//
@property (strong, nonatomic) ModalGlobal *mg;

//-(void)showPickerView;

//-(void)addDatePickerWithToolBar;

-(void)alertView;

-(NSMutableArray*)returnReplaceArray:(NSArray*)nullArray;

//  for validation
-(BOOL)validateString:(NSString *)string;
-(BOOL)validateEmail:(NSString *)email;
-(BOOL)validateMobile:(NSString *)mobile;
-(BOOL)validateAddress:(NSString *)string;
-(BOOL)validateJP:(NSString *)string;

//  alertView methods
-(void)alertWithText:(NSString*)title message:(NSString*)message;
-(void)alertWithAction:(NSString*)title message:(NSString*)message;

-(UIColor*)colorWithCode:(NSString*)hex;

-(NSString*)numberToString:(NSNumber*)number;
-(NSString*)integerToString:(NSNumber*)integer;
-(NSString*)stringFormat:(id)value;

-(void)addPickerViewWithToolBar:(UITextField*)textField;

-(NSArray*)splitString:(NSString*)string pattern:(NSString*)pattern;
-(CGFloat)getSizeH;



-(NSString*)textWithOrdinalStyle:(NSString*)string;

-(NSString *)encodeWithSHA512:(NSString *)source;

-(NSString*)createAuth:(NSString*)string1 string2:(NSString*)string2 string3:(NSString*)string3;

-(NSString*)uniqueTstamp;

-(NSString*)validateNullValue:(id)value isString:(BOOL)isString;

-(NSString*)setRs:(NSString*)value;

-(NSString*)valueRoundOff:(NSString*)string;
-(NSString*)valueRoundOff8:(NSString*)string;

-(void)setLabelUnderLine:(UILabel*)label;
-(void)setTextBoxLine:(UITextField*)textField;
-(void)setViewLine:(UIView*)view;
-(void)setBoxShadow:(UIView*)view;

-(void)setButtonShadow:(UIButton*)button;

-(void)setButtonBorder:(UIButton*)button;
-(void)setViewBorder:(UIView*)view;


// --------------------Start Date format method-----------------------//
-(NSDate*)currentDate;
-(NSString*)currentDateStr;
-(NSDate*)msToDate:(NSString*)ms;
-(NSDate*)dateInIST;
-(NSDate*)dateStringToDate:(NSString*)dateString;
-(NSDate*)dateStringToDateTime:(NSString*)dateString;
-(NSString*)dateWithOrdinalStyle:(NSString*)dateStr;
-(NSString*)dateWithOrdinal_EEddMMMyy:(NSString*)dateStr;
-(NSString*)dateWithDayStyle:(NSString*)dateStr;
-(NSString*)dateWith_ddMMyyyyhhmm:(NSDate*)dateStr;
-(NSString*)dateWith_ddMMyyyy:(NSDate*)dateStr;
-(NSString*)dateWith_ddMMMyyEEE:(NSDate*)dateStr;
-(NSString*)dateWith_ddLLLLyyEEEE:(NSDate*)dateStr;
-(NSString*)msToTimeUTC:(NSString*)msStr;
-(NSString*)msToUTCms:(NSString*)msStr;
-(NSString*)currentToUTCms;
-(int)dateTimeDiff:(NSString*)pickerTimeStr;
//change milisecond to date
-(NSString*)msWithOrdinalStyle_ddMMyy:(NSString*)ms;
-(NSDate*)dateWithNextYearDate:(NSDate*)nsdate;
// --------------------End Date format method-----------------------//


-(NSString*)trimValue:(NSString*)string;

//
-(NSString*)getCity:(NSString*)string;
//
-(void)setFlurry:(NSString*)logEvent params:(NSDictionary*)params;
@end
