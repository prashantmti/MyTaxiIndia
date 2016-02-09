//
//  BaseView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/16/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "BaseView.h"
#import "CouponListingView.h"

//
#import "SWRevealViewController.h"

@interface BaseView ()

@property(nonatomic, weak) AppDelegate *delegate;


@end

@implementation BaseView


- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.mg=[ModalGlobal sharedManager];
    // Do any additional setup after loading the view.
    [self setNavigationBarStyle];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg~600x600.png"]];
    pickerDataArray=[NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",nil];
    [self textWithOrdinalStyle:@"31"];
    
   // NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:1448017312000];
    
    //
//    SWRevealViewController *revealController = [self revealViewController];
//    UITapGestureRecognizer *tap = [revealController tapGestureRecognizer];
//    tap.delegate = self;
//    [self.view addGestureRecognizer:tap];
    
}

//GA
-(void)GATrackOnView:(NSString*)className kGAIScreenName:(NSString*)kGAIScreenName
{
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:className];
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [[GAI sharedInstance] dispatch];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; // your own style
}

- (BOOL)prefersStatusBarHidden {
    return NO; // your own visibility code
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES; 
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


-(void)alertView{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Title"
                                  message:@"Message"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here, eg dismiss the alertwindow
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}






//  start   --validation
-(BOOL)validateString:(NSString *)string
{
    NSString *trimString = [string stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    if (trimString.length==0){
        return FALSE;
    }
    else{
        return TRUE;
//        NSString *stringRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//        NSPredicate *stringTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
//        return [stringTest evaluateWithObject:trimString];
    }
}

-(BOOL)validateEmail:(NSString *)email
{
    NSString *trimString = [email stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];
    if (trimString.length==0){
        return FALSE;
    }
    else{
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:trimString];
    }
}

-(BOOL)validateMobile:(NSString *)mobile
{
    NSString *trimString = [mobile stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];
    if (trimString.length==0){
        return FALSE;
    }
    else{
        if(trimString.length==10||trimString.length==11){
            return TRUE;
        }
        else{
            return FALSE;
//            NSString *Regex = @"^d{10}$";
//            NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
//            return [mobileTest evaluateWithObject:trimString];
        }
    }
}


-(BOOL)validateAddress:(NSString *)string
{
    NSString *trimString = [string stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];
    if (trimString.length>=200){
        return FALSE;
    }
    else{
        return TRUE;
    }
}


-(void)alertWithAction:(NSString*)title message:(NSString*)message {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)alertWithText:(NSString*)title message:(NSString*)message {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:title
                                      message:message
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 //Do some thing here, eg dismiss the alertwindow
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    });

}



-(NSMutableArray*)returnReplaceArray:(NSArray*)nullArray
{
    NSMutableArray * mutArr = [[NSMutableArray alloc]init];
    for (id obj in nullArray) {
        if ([obj isKindOfClass:NSString.class]) {
            if ([obj isEqualToString:@"<null>"]) {
                [mutArr addObject:@""];
            }else {
                [mutArr addObject:obj];
            }
        }
    }
    return mutArr;
}

-(UIColor*)colorWithCode:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}




-(NSString*)numberToString:(NSNumber*)number{
    
    return [NSString stringWithFormat:@"%@",number];
}

-(NSString*)integerToString:(NSNumber*)number{

    return [NSString stringWithFormat:@"%@",number];
}

-(NSString*)stringFormat:(id)value
{
    NSString *string=[NSString stringWithFormat:@"%@",value];
    return string;
}



#pragma - pickerView delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [pickerDataArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (row==0) {
        return [NSString stringWithFormat:@"%@ Day",[pickerDataArray objectAtIndex:row]];
    }else{
        return [NSString stringWithFormat:@"%@ Days",[pickerDataArray objectAtIndex:row]];
    }
}


-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    indexPickerView =row;
}


#pragma - add toolbar


-(void)addPickerViewWithToolBar:(UITextField*)textField{
    
    CGFloat orgW=self.view.frame.size.width;
    CGFloat orgPVH=180;
    
    pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height+44,orgW,orgPVH)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor=[UIColor whiteColor];
    //Add ToolBar
    pickerViewtoolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    
    CustomBarButton *doneBtn = [[CustomBarButton alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(pickerViewDone:)];
    doneBtn.textField = textField;
    doneBtn.pickerView=pickerView;
    doneBtn.tintColor=[self colorWithCode:@"0195c3"];
    CustomBarButton *spacer = [[CustomBarButton alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    CustomBarButton *cancelBtn = [[CustomBarButton alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    cancelBtn.textField = textField;
    doneBtn.pickerView=pickerView;
    cancelBtn.tintColor=[UIColor whiteColor];
    
    [pickerViewtoolBar setItems:[[NSArray alloc] initWithObjects:cancelBtn,spacer,doneBtn,nil]];
    [pickerViewtoolBar setBarStyle:UIBarStyleDefault];
    [pickerViewtoolBar setTranslucent:NO];
    [pickerViewtoolBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    
//    currentTextField.inputAccessoryView  = toolBar;
//    currentTextField.inputView = pickerView;
    textField.inputAccessoryView  = pickerViewtoolBar;
    textField.inputView = pickerView;
    
    [pickerView reloadAllComponents];
}

- (void)pickerViewDone:(CustomBarButton *)barbtn
{
    if ([[pickerDataArray objectAtIndex:indexPickerView] isEqualToString:@"1"]) {
        barbtn.textField.text = [NSString stringWithFormat:@"%@ Day",[pickerDataArray objectAtIndex:indexPickerView]];
    }else{
        barbtn.textField.text = [NSString stringWithFormat:@"%@ Days",[pickerDataArray objectAtIndex:indexPickerView]];
    }
    [barbtn.textField resignFirstResponder];
}

-(void)pickerViewCancel:(CustomBarButton *)barbtn
{
    [barbtn.textField  resignFirstResponder];
}


-(NSString *)encodeWithSHA512:(NSString *)source {
    
    const char *s = [source cStringUsingEncoding:NSASCIIStringEncoding];
    
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA512_DIGEST_LENGTH] = {0};
    
    CC_SHA512(keyData.bytes, keyData.length, digest);
    
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
    
    return [out description];
}

-(NSString*)uniqueTstamp
{
     return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970] * 1000];
}

-(NSArray*)splitString:(NSString*)string pattern:(NSString*)pattern
{
    NSArray *splitArray;
    splitArray=[string componentsSeparatedByString:pattern];
    return splitArray;
}

-(CGFloat)getSizeH
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    //CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    return screenHeight;
}




-(NSString*)textWithOrdinalStyle:(NSString*)string
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number=[formatter numberFromString:string];
    formatter.numberStyle = NSNumberFormatterOrdinalStyle;
    return [self stringFormat:[formatter stringFromNumber:number]];
}

-(NSString*)createAuth:(NSString*)string1 string2:(NSString*)string2 string3:(NSString*)string3
{
    NSString *auth;
    auth=[self encodeWithSHA512:[NSString stringWithFormat:@"%@|%@|%@",string1,string2,string3]];
    auth=[auth stringByReplacingOccurrencesOfString:@" " withString:@""];
    auth=[auth stringByReplacingOccurrencesOfString:@"<" withString:@""];
    auth=[auth stringByReplacingOccurrencesOfString:@">" withString:@""];
    //NSLog(@"aauth==>%@",auth);
    return auth;
}




-(NSString*)validateNullValue:(id)value isString:(BOOL)isString
{
    NSString *string;
    if (isString && [value isEqual:[NSNull null]]) {
        string=@"";
    }else if (!isString) {
        if ([value isEqual:[NSNull null]]) {
            string=@"0";
        }else{
            string=[NSString stringWithFormat:@"%@",value];
        }
    }else{
        string=value;
    }
    return string;
}

-(IBAction)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSString*)setRs:(NSString*)value
{
     NSString *rupees;
    
    if ([value isEqual:[NSNull null]]) {
        rupees=@"0";
    }else{
        rupees=value;
    }
    rupees=[NSString stringWithFormat:@"%@%@",rupee,rupees];
    return rupees;
}

-(NSString*)valueRoundOff:(NSString*)string{
    NSString *finalString;
    if ([string isEqual:[NSNull null]]) {
        string=@"0";
        finalString=string;
    }else{
        double strDouble = [string doubleValue];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
        [formatter setMaximumFractionDigits:2];
        NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithDouble:strDouble]];
        finalString=[numberString stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    return finalString;
}


-(void)setNavigationBarStyle{
    //0099cc
    self.navigationController.navigationBar.barTintColor = [self colorWithCode:@"0099cc"];//0195c3
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
}

-(void)setTextBoxLine:(UITextField*)textField
{
    textField.backgroundColor=[UIColor clearColor];
    textField.borderStyle=UITextBorderStyleNone;
    
    //Bottom border
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height - 1, textField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor =[self colorWithCode:@"242424"].CGColor;
    [textField.layer addSublayer:bottomBorder];
    
    
    //left border
    CALayer *leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0.0f, textField.frame.size.height-3, 1.0f,3);
    leftBorder.backgroundColor =[self colorWithCode:@"242424"].CGColor;
    [textField.layer addSublayer:leftBorder];

    //right border
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(textField.frame.size.width-1,textField.frame.size.height-3, 1.0f,3);
    rightBorder.backgroundColor =[self colorWithCode:@"242424"].CGColor;
    [textField.layer addSublayer:rightBorder];
}

-(void)setViewLine:(UIView*)view
{
    //Bottom border
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f,view.frame.size.height - 1,view.frame.size.width, 1.0f);
    bottomBorder.backgroundColor =[self colorWithCode:@"242424"].CGColor;
    [view.layer addSublayer:bottomBorder];
    
    //left border
    CALayer *leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0.0f, view.frame.size.height-3, 1.0f,3);
    leftBorder.backgroundColor =[self colorWithCode:@"242424"].CGColor;
    [view.layer addSublayer:leftBorder];
    
    //right border
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(view.frame.size.width-1,view.frame.size.height-3, 1.0f,3);
    rightBorder.backgroundColor =[self colorWithCode:@"242424"].CGColor;
    [view.layer addSublayer:rightBorder];
    
}

-(void)setLabelUnderLine:(UILabel*)label
{
    //Bottom border
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, label.frame.size.height - 1, label.frame.size.width, 1.0f);
    bottomBorder.backgroundColor =[self colorWithCode:@"242424"].CGColor;
    [label.layer addSublayer:bottomBorder];
}


-(void)setBoxShadow:(UIView*)view
{
    view.layer.masksToBounds = NO;
    view.layer.shadowOffset = CGSizeMake(-0.3,0.2);
    view.layer.shadowOpacity = 0.3;
}


-(void)setButtonShadow:(UIButton*)button
{
    
    //Bottom border
    
//    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, button.frame.size.height - 2.0f, button.frame.size.width,2)];
//    bottomBorder.backgroundColor = [UIColor redColor];
//    [button addSubview:bottomBorder];
    
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f,button.frame.size.height-10-2,button.frame.size.width,1.0f);
    bottomBorder.backgroundColor =[self colorWithCode:@"666666"].CGColor;
    bottomBorder.masksToBounds = NO;
    bottomBorder.shadowOffset = CGSizeMake(-0.2,0.3);
    bottomBorder.shadowOpacity = 0.2;
    [button.layer addSublayer:bottomBorder];
    
//    button.layer.borderWidth=1.0;
//    button.layer.borderColor=[UIColor redColor].CGColor;
//    button.layer.masksToBounds = NO;
//    button.layer.shadowOffset = CGSizeMake(-0.2,0.1);
//    button.layer.shadowOpacity = 0.1;
}

-(void)setButtonBorder:(UIButton*)button
{
    [[button layer] setBorderWidth:1.0f];
    [[button layer] setBorderColor:[self colorWithCode:@"0195c3"].CGColor];
    [button setBackgroundColor:[UIColor whiteColor]];
}

-(void)setViewBorder:(UIView*)view
{
    [[view layer] setBorderWidth:1.0f];
    [[view layer] setBorderColor:[self colorWithCode:@"0195c3"].CGColor];
    [view setBackgroundColor:[UIColor whiteColor]];
}

// --------------------Start Date format method-----------------------//
-(NSDate*)dateInIST{
    //
    NSDate* datetime = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"IST"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //
    NSString* dateTimeStrInIST =[dateFormatter stringFromDate:datetime];
    return [dateFormatter dateFromString:dateTimeStrInIST];
}

-(NSDate*)dateStringToDate:(NSString*)dateString
{
    NSArray *dateStyleArray=[self splitString:dateString pattern:@" "];
    //
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"IST"]];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    //
    NSDate *date = [dateFormatter dateFromString:dateStyleArray[0]];
    //
    return date;
}

-(NSDate*)dateStringToDateTime:(NSString*)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"IST"]];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    //
    NSDate *date = [dateFormatter dateFromString:dateString];
    //
    return date;
}


-(NSString*)dateWithOrdinalStyle:(NSString*)dateStr
{
    NSString *returnDate,*setDate;   // 1st Jan 2016
    //
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"IST"]];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    //
    setDate=[dateFormatter stringFromDate:[self dateStringToDate:dateStr]];
    
    NSArray *dateStyleArray=[self splitString:setDate pattern:@" "];
    returnDate=[NSString stringWithFormat:@"%@ %@ %@",[self textWithOrdinalStyle:dateStyleArray[0]],dateStyleArray[1],dateStyleArray[2]];
    //
    return returnDate;
}

-(NSString*)dateWithOrdinal_EEddMMMyy:(NSString*)dateStr
{
    NSString *returnDate,*setDate;   // 1st Jan 2016
    //
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"IST"]];
    [dateFormatter setDateFormat:@"EE dd MMM yy"];
    //
    setDate=[dateFormatter stringFromDate:[self dateStringToDate:dateStr]];
    //
    NSArray *dateStyleArray=[self splitString:setDate pattern:@" "];
    returnDate=[NSString stringWithFormat:@"%@, %@ %@ %@",dateStyleArray[0],[self textWithOrdinalStyle:dateStyleArray[1]],dateStyleArray[2],dateStyleArray[3]];
    return returnDate;
}

-(NSString*)dateWithDayStyle:(NSString*)dateStr
{
    NSString *returnDate;   //dd/MMM/yyyy
    //
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"IST"]];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    //
    returnDate=[dateFormatter stringFromDate:[self dateStringToDate:dateStr]];
    return returnDate;
}

-(NSString*)dateWith_ddMMyyyyhhmm:(NSDate*)dateStr
{
    NSString *returnDate;   //dd/MM/yyyy
    //
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"IST"]];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    //
    returnDate=[dateFormatter stringFromDate:dateStr];
    return returnDate;
}

-(NSString*)dateWith_ddMMyyyy:(NSDate*)dateStr
{
    NSString *returnDate;   //dd/MM/yyyy
    //
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"IST"]];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    //
    returnDate=[dateFormatter stringFromDate:dateStr];
    return returnDate;
}

-(NSString*)dateWith_ddMMMyyEEE:(NSDate*)dateStr{
    NSString *returnDate;   //dd/MMM/yy/EEE
    //
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"IST"]];
    [dateFormatter setDateFormat:@"dd/MMM/yy/EEE"];
    //
    returnDate=[dateFormatter stringFromDate:dateStr];
    return returnDate;
}

-(NSString*)dateWith_ddLLLLyyEEEE:(NSDate*)dateStr{
    NSString *returnDate;   //dd/MMM/yyyy/EEE
    //
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"IST"]];
    [dateFormatter setDateFormat:@"dd/LLLL/yy/EEEE"];
    //
    returnDate=[dateFormatter stringFromDate:dateStr];
    return returnDate;
}

-(int)dateTimeDiff:(NSString*)pickerTimeStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"]; //24hr time format
    NSString *currentTimeStr =[dateFormatter stringFromDate:[NSDate date]];
    
    //NSLog(@"pickerTimeStr ===>%@",pickerTimeStr);
    //NSLog(@"currentTimeStr===>%@",currentTimeStr);
    
    NSDate *pickerTime  = [dateFormatter dateFromString:pickerTimeStr];
    NSDate *currentTime = [dateFormatter dateFromString:currentTimeStr];
    
    NSTimeInterval interval = [pickerTime timeIntervalSinceDate:currentTime];
    int hours = (int)interval / 3600;             // integer division to get the hours part
    return hours;
}

-(NSDate*)dateWithNextYearDate:(NSDate*)nsdate{
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:1];
    NSDate *nextYearDate = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    return nextYearDate;
}
//-----------------------------------------------------------------------------
-(NSString*)dateWithTest:(NSString*)dateStr{
    NSString *setDate;NSDate *date;
    //
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy HH:MM:SS"];
    //
    date=[dateFormat dateFromString:dateStr];
    setDate=[dateFormat stringFromDate:date];
    return setDate;
}

-(NSString*)msToTimeUTCTest:(NSString*)ms
{
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSString *msStr=[self stringFormat:ms];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([msStr doubleValue] / 1000)];
    //
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //
    [dateFormat setTimeZone:timeZone];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:SS"];
    NSString *dateStr=[dateFormat stringFromDate:date];
    return dateStr;
}

-(NSString*)msToTimeUTC:(NSString*)msStr
{
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([msStr doubleValue] / 1000)];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //
    [dateFormat setTimeZone:timeZone];
    [dateFormat setDateFormat:@"HH:mm"];
    NSString *dateStr=[dateFormat stringFromDate:date];
    return dateStr;
}

-(NSString*)msWithOrdinalStyle_ddMMyy:(NSString*)ms
{
    NSString *returnDate,*setDate;   // 1st Jan 16
    //
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([ms doubleValue] / 1000)];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //
    [dateFormat setTimeZone:timeZone];
    [dateFormat setDateFormat:@"dd MMM yy"];
    setDate=[dateFormat stringFromDate:date];
    //
    NSArray *dateStyleArray=[self splitString:setDate pattern:@" "];
    returnDate=[NSString stringWithFormat:@"%@ %@ %@",[self textWithOrdinalStyle:dateStyleArray[0]],dateStyleArray[1],dateStyleArray[2]];
    //
    return returnDate;
}
// --------------------End Date format method-----------------------//

//
-(NSString*)trimValue:(NSString*)string{
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    return trimmedString;
}
@end
