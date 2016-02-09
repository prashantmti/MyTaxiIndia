//
//  LocalStationView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/9/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "LocalStationView.h"

@interface LocalStationView ()

@end

@implementation LocalStationView

@synthesize selectedTripCites,cabList,datePicker,pickupDate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //
    self.mg=[ModalGlobal sharedManager];
    //
    [self setTextBoxStyleLine:_tfPickUpCity];
    [self setTextBoxStyleLine:_tfDays];
    //
    [self setCDOnDatesView];
    
    selectedTripCites=[[NSMutableDictionary alloc]init];
    [selectedTripCites setObject:@"" forKey:@"city1"];
    
    // set date picker on DPView
    [self setGesturesOnDPView1];
    //
    [self setUI];
}

-(void)setUI
{
    //
    [self setBoxShadow:uvView1];
    [self setBoxShadow:uvView2];
    [self setBoxShadow:DPView1];
    //
    [self setButtonShadow:_btnSearchTaxi];
    
    //
    _isShowPicker=FALSE;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self GATrackOnView:NSStringFromClass(self.class) kGAIScreenName:kGAIScreenName];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillAppear:(BOOL)animated{
    //
    if ([self.mg.mbt.tripActionComplete isEqual:@"YES"]) {
        _tfPickUpCity.text=nil;
        _tfDays.text=nil;
        [self setCDOnDatesView];
    }
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAutoLocation:) name:@"pushToAutoLocationforLocal" object:nil];
}


-(void)pushToAutoLocation:(NSNotification *)notis{
    
    NSDictionary *returnResponse = notis.userInfo;
    
    //NSString *locality=[[returnResponse valueForKey:@"locationDic"] valueForKey:@"locality"];
    NSString *city=[[returnResponse valueForKey:@"locationDic"] valueForKey:@"city"];
    NSString *state=[[returnResponse valueForKey:@"locationDic"] valueForKey:@"state"];
    //NSString *country=[[returnResponse valueForKey:@"locationDic"] valueForKey:@"country"];

    NSString *location=[NSString stringWithFormat:@"%@, %@",city,state];
    
    if ([[returnResponse valueForKey:@"locationTag"] integerValue]==101) {
        self.mg.mbt.departureCity=city;
        self.mg.mbt.departureLocation=location;
        
        _tfPickUpCity.text=[location capitalizedString];
        [selectedTripCites setObject:[[returnResponse valueForKey:@"locationDic"] valueForKey:@"cityId"] forKey:@"city1"];
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //  tripTag 0:for local | 1 for outstation
    textField.keyboardAppearance=false;
    AutoCityView *acv = [self.storyboard instantiateViewControllerWithIdentifier:@"AutoCityView"];
   // acv.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    acv.tripTag=2;
    switch (textField.tag) {
        case 101:{
            acv.loctionTag=_tfPickUpCity.tag;
            [textField resignFirstResponder];
            [self.navigationController pushViewController:acv animated:YES];
            //[self presentViewController:acv animated:YES completion:nil];
            break;
        }case 102:{
            acv.loctionTag=_tfDays.tag;
            [self addPickerViewWithToolBar:textField];
            break;
        }
        default:
            break;
    }
    //NSLog(@"tag====>%ld",(long)textField.tag);
}

-(IBAction)searchTaxi:(id)sender{
    
    if (_tfPickUpCity.text.length==0)
    {
        [self alertWithText:nil message:atDCity];
        return;
    }
    else if (_tfDays.text.length==0)
    {
        [self alertWithText:nil message:@"Select Days"];
        return;
    }
    else if (pickupDate.length==0)
    {
        [self alertWithText:nil message:@"Enter Pick Date"];
        return;
    }
    else{
        [self callService];
    }
}


//-(void)callService1{
//
//    NSInteger val=[[self splitString:_tfDays.text pattern:@" "][0] integerValue]*8;
//    
//    WebServiceClass *WSC = [[WebServiceClass alloc] init];
//    NSString *auth=[self createAuth:merchantId string2:[self uniqueTstamp] string3:authPassword];
//    NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
//    [postDic setObject:merchantId forKey:@"merchantId"];
//    [postDic setObject:[self uniqueTstamp] forKey:@"salt"];
//    
//    [postDic setObject:[selectedTripCites valueForKey:@"city1"] forKey:@"cityIds"];
//    //[postDic setObject:[selectedTripCites valueForKey:@"city1"] forKey:@"regionIds"];
//    [postDic setObject:@"2" forKey:@"tripType"];
//    [postDic setObject:pickupDate forKey:@"pickupDate"];
//    //[postDic setObject:DPView1Lbldd.text forKey:@"dropDate"];
//    [postDic setObject:[NSString stringWithFormat:@"%ld",(long)val] forKey:@"hours"];
//    
//    [WSC getServerResponseForUrl:postDic serviceURL:IDSearchTaxi isPOST:YES isLoder:YES auth:auth view:self.view  withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
//        if (success) {
//            if ([[response valueForKey:@"status"] isEqualToString:@"error"])
//            {
//                [self alertWithText:@"Error!" message:[response valueForKey:@"error"]];
//                return ;
//            }
//            else{
//            cabList=[[[response valueForKey:@"result"] valueForKey:@"results"] valueForKey:@"taxis"];
//            
//            CabListView *cdv = [self.storyboard instantiateViewControllerWithIdentifier:@"CabListView"];
//            cdv.cabList=cabList;
//            [self.navigationController pushViewController:cdv animated:YES];
//            }
//        }else{
//            [self alertWithText:@"Error!" message:error.localizedDescription];
//            return ;
//        }
//    }];
//}

-(void)callService{
    
     NSInteger val=[[self splitString:_tfDays.text pattern:@" "][0] integerValue]*8;
    
    //set setModalBaseTaxi
    self.mg.mbt.departureDate=pickupDate;
    self.mg.mbt.tripType=@"2";
    self.mg.mbt.locationIds=[selectedTripCites valueForKey:@"city1"];
    self.mg.mbt.tripSelectDays=[NSString stringWithFormat:@"%ld",(long)val];
    
    //
    WebServiceClass *WSC = [[WebServiceClass alloc] init];
    NSString *auth=[self createAuth:merchantId string2:[self uniqueTstamp] string3:authPassword];
    NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
    //
    [postDic setObject:merchantId forKey:@"merchantId"];
    [postDic setObject:[self uniqueTstamp] forKey:@"salt"];
    //
    [postDic setObject:self.mg.mbt.locationIds forKey:@"cityIds"];
    [postDic setObject:self.mg.mbt.tripType forKey:@"tripType"];
    [postDic setObject:self.mg.mbt.departureDate forKey:@"pickupDate"];
    [postDic setObject:self.mg.mbt.tripSelectDays forKey:@"hours"];

    [WSC getServerResponseForUrl:postDic serviceURL:IDSearchTaxi isPOST:YES isLoder:YES auth:auth view:self.view  withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        if (success) {
            if ([[response valueForKey:@"status"] isEqualToString:@"error"])
            {
                [self alertWithText:@"Error!" message:[response valueForKey:@"error"]];
                return ;
            }
            else{
                cabList=[[[response valueForKey:@"result"] valueForKey:@"results"] valueForKey:@"taxis"];
                CabListView *cdv = [self.storyboard instantiateViewControllerWithIdentifier:@"CabListView"];
                cdv.cabList=cabList;
                [self.navigationController pushViewController:cdv animated:YES];
            }
        }else{
            [self alertWithText:@"Error!" message:error.localizedDescription];
            return ;
        }
    }];
}


-(NSString*)dicToStr:(NSDictionary*)setDic
{
    NSString *string=@"";
    NSString *city1=[NSString stringWithFormat:@"%@",[setDic valueForKey:@"city1"]];
    NSString *city2=[NSString stringWithFormat:@"%@",[setDic valueForKey:@"city2"]];
    NSString *city3=[NSString stringWithFormat:@"%@",[setDic valueForKey:@"city3"]];
    
    if (city3.length==0) {
        string=[NSString stringWithFormat:@"%@,%@",city1,city2];
    }else{
        string=[NSString stringWithFormat:@"%@,%@,%@",city1,city2,city3];
    }
    return string;
}

// start--  add datepicker on view

- (void)setGesturesOnDPView1
{
    UITapGestureRecognizer* DPViewGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GesturesOnDPView1:)];
    [DPView1 addGestureRecognizer:DPViewGesture1];
}

- (void)GesturesOnDPView1: (UITapGestureRecognizer *)recognizer
{
    if (_isShowPicker==TRUE) {
        return;
    }else{
        [self addDatePickerWithToolBar:1001];
    }
    
}
//  end --  end add datepicker on view



-(void)addDatePickerWithToolBar:(int)tag{
    
    _isShowPicker=TRUE;
    CGFloat orgW=self.view.frame.size.width;
    CGFloat orgPVH=180;
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-orgPVH-44,orgW,44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-orgPVH,orgW,orgPVH);
    
    //pickerView
    datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height+44,orgW, orgPVH)];
    datePicker.backgroundColor=[UIColor whiteColor];
    
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(pickerAction:) forControlEvents:UIControlEventValueChanged]; // method to respond to changes in the picker value
    
    //Set Date
    datePicker.date=[self dateStringToDate:pickupDate];
    datePicker.minimumDate=[self dateInIST];
    
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker setMaximumDate:[self dateWithNextYearDate:[NSDate date]]];
    //
    datePicker.tag=tag;
    [self.view addSubview:datePicker];
    
    //toolBar
    CGFloat tbH;
    tbH=44;
    
    toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height,orgW, 44)];
    
    UIBarButtonItem *IDLeftTBBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    IDLeftTBBtn.tintColor=[UIColor whiteColor];
    IDLeftTBBtn.tag=tag;
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *IDRightTBBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(IDRightTBBtnAction:)];
    IDRightTBBtn.tintColor=[self colorWithCode:@"0195c3"];
    IDRightTBBtn.tag=tag;
    
    [toolBar setItems:[[NSArray alloc] initWithObjects:IDLeftTBBtn,spacer,IDRightTBBtn,nil]];
    [toolBar setBarStyle:UIBarStyleDefault];
    [toolBar setTranslucent:NO];
    [toolBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    [self.view addSubview:toolBar];
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    datePicker.frame = datePickerTargetFrame;
    [UIView commitAnimations];
}

//-(void)IDLeftTBBtnAction:(UIBarButtonItem*)sender
//{
//    NSDate *chosen = [datePicker date];
//    [datePicker removeFromSuperview];
//    [toolBar removeFromSuperview];
//    NSLog(@"%@",chosen);
//}

-(void)IDRightTBBtnAction:(UIBarButtonItem*)sender
{
    _isShowPicker=FALSE;
    NSString *dateString=[self dateWith_ddMMyyyy:datePicker.date];
    NSArray *dateStyleArray=[self splitString:[self dateWith_ddLLLLyyEEEE:datePicker.date] pattern:@"/"];
    
    if (sender.tag==1001){
        pickupDate=dateString;
        _lbDpView1dd.text=[self textWithOrdinalStyle:dateStyleArray[0]];
        _lbDpView1mmyy.text=[NSString stringWithFormat:@"%@ %@",dateStyleArray[1],dateStyleArray[2]];
        _lbDpView1Day.text=dateStyleArray[3];
    }
    
    CGFloat orgW=self.view.frame.size.width;
    CGFloat orgPVH=180;
    
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, orgW, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, orgW, orgPVH);
    [UIView beginAnimations:@"MoveOut" context:nil];
    datePicker.frame = datePickerTargetFrame;
    toolBar.frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
}


- (void)removeViews:(id)object {
    [datePicker removeFromSuperview];
    [datePicker removeFromSuperview];
}


- (IBAction)pickerAction:(UIDatePicker*)sender
{
    datePicker.date=sender.date;
}


-(void)setCDOnDatesView
{
    NSString *dateString=[self dateWith_ddMMyyyy:[NSDate date]];
    NSArray *dateStyleArray=[self splitString:[self dateWith_ddLLLLyyEEEE:[NSDate date]] pattern:@"/"];
    
    pickupDate=dateString;
    
    _lbDpView1dd.text=[self textWithOrdinalStyle:dateStyleArray[0]];
    _lbDpView1mmyy.text=[NSString stringWithFormat:@"%@ %@",dateStyleArray[1],dateStyleArray[2]];
    _lbDpView1Day.text=dateStyleArray[3];
}

-(void)setTextBoxStyleLine:(UITextField*)textField
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
@end
