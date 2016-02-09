//
//  OutStationView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/9/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "OutStationView.h"

@interface OutStationView ()

@end

@implementation OutStationView

@synthesize selectedLocation,datePicker,selectedDateFromDP,tripType;
@synthesize pickupDate,dropDate,cabList,selectedTripCites;
@synthesize owBtn,rtBtn;
@synthesize IVaddMoreCity;

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.mg=[ModalGlobal sharedManager];
    //
    [self setTextBoxStyleLine:_tfDepartureCity];
    [self setTextBoxStyleLine:_tfArrivalCity];
    [self setTextBoxStyleLine:_tfAddMoreCity];
    
    
    [self setUI];
    [self setCDOnDatesView];
    
    _tfAddMoreCity.inputView=nil;
    _tfArrivalCity.inputView=nil;
    _tfDepartureCity.inputView=nil;

    selectedTripCites=[[NSMutableDictionary alloc]init];
    [selectedTripCites setObject:@"" forKey:@"city1"];
    [selectedTripCites setObject:@"" forKey:@"city2"];
    [selectedTripCites setObject:@"" forKey:@"city3"];
    //hide other City textBox
    IVaddMoreCity.hidden=TRUE;
    

    // set date picker on DPView
    [self setGesturesOnDPView1];
    [self setGesturesOnDPView2];

    [self setTripTypeAction:0];
    [self hideDropView:0];
    [self setAddMoreCityView:1];
    
    
}


-(void)setUI
{
    _isShowPicker=FALSE;
    
    //
    [self setBoxShadow:uvTripAction];
    [self setBoxShadow:uvFrom];
    [self setBoxShadow:uvTo];
    [self setBoxShadow:uvMoreCity];
    [self setBoxShadow:uvDpPicker];
    
    //
    [self setButtonShadow:_btnSearchTaxi];
    [self setButtonBorder:_btnAddMoreCity];
    
    //
    [self setViewBorder:uvTripView];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self GATrackOnView:NSStringFromClass(self.class) kGAIScreenName:kGAIScreenName];
    
    //

}

//- (void)dispatch {
//    
//    //self.screenName = @"mytaxiindia";
//    NSMutableDictionary *event =
//    [[GAIDictionaryBuilder createEventWithCategory:@"UI"
//                                            action:@"load"
//                                             label:@"OSV Appear"
//                                             value:nil] build];
//    [[GAI sharedInstance].defaultTracker send:event];
//    [[GAI sharedInstance] dispatch];
//}



-(void)viewWillAppear:(BOOL)animated{
    //
    if ([self.mg.mbt.tripActionComplete isEqual:@"YES"]) {
        _tfDepartureCity.text=nil;
        _tfArrivalCity.text=nil;
        _tfAddMoreCity.text=nil;
        //
        self.mg.mbt.tripActionComplete=@"NO";
        //
        [self setCDOnDatesView];
    }
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAutoLocation:) name:@"pushToAutoLocation" object:nil];
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
        
        _tfDepartureCity.text=[self.mg.mbt.departureLocation capitalizedString];
        [selectedTripCites setObject:[[returnResponse valueForKey:@"locationDic"] valueForKey:@"cityId"] forKey:@"city1"];
    }else if ([[returnResponse valueForKey:@"locationTag"] integerValue]==102) {
        self.mg.mbt.arrivalCity=city;
        self.mg.mbt.arrivalLocation=location;
    
        _tfArrivalCity.text=[self.mg.mbt.arrivalLocation capitalizedString];
        [selectedTripCites setObject:[[returnResponse valueForKey:@"locationDic"] valueForKey:@"cityId"] forKey:@"city2"];
    }
    else if ([[returnResponse valueForKey:@"locationTag"] integerValue]==103) {
        self.mg.mbt.arrivalMoreCity=city;
        self.mg.mbt.arrivalMoreLocation=location;
    
        _tfAddMoreCity.text=[location capitalizedString];
        [selectedTripCites setObject:[[returnResponse valueForKey:@"locationDic"] valueForKey:@"cityId"] forKey:@"city3"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // tripType =>0:for local | 1 for outstation
    
    textField.inputView=nil;
    [textField resignFirstResponder];
    
    AutoCityView *acv = [self.storyboard
                         instantiateViewControllerWithIdentifier:@"AutoCityView"];
    acv.tripTag=1;
    switch (textField.tag){
        case 101:{
            [textField resignFirstResponder];
            acv.loctionTag=_tfDepartureCity.tag;
            [self.navigationController pushViewController:acv animated:YES];
            break;
        }case 102:{
            acv.loctionTag=_tfArrivalCity.tag;
            [self.navigationController pushViewController:acv animated:YES];
            break;
        }
        case 103:{
            acv.loctionTag=_tfAddMoreCity.tag;
            [self.navigationController pushViewController:acv animated:YES];
            break;
        }
        default:
            break;
    }
    //NSLog(@"tag====>%ld",(long)textField.tag);
}


// start--  add datepicker on view

- (void)setGesturesOnDPView1
{
    UITapGestureRecognizer* DPViewGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GesturesOnDPView1:)];
    [DPView1 addGestureRecognizer:DPViewGesture1];
}

- (void)GesturesOnDPView1: (UITapGestureRecognizer *)recognizer
{
    if (_isShowPicker){
        return;
    }else{
        [self addDatePickerWithToolBar:1001];
    }
}

-(void)setGesturesOnDPView2
{
    UITapGestureRecognizer* DPViewGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GesturesOnDPView2:)];
    [DPView2 addGestureRecognizer:DPViewGesture2];
}

- (void)GesturesOnDPView2: (UITapGestureRecognizer *)recognizer
{
    if (_isShowPicker) {
        return;
    }else{
        [self addDatePickerWithToolBar:1002];
    }
}

//  end --  end add datepicker on view


-(void)setGesturesOnLabel1
{
    UITapGestureRecognizer* gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction1:)];
    [_tfDepartureCity addGestureRecognizer:gesture1];
    [_tfDepartureCity setUserInteractionEnabled:YES];
}

- (void)gestureAction1: (UITapGestureRecognizer *)recognizer
{
    //Code to handle the gesture
    AutoCityView *acv = [self.storyboard instantiateViewControllerWithIdentifier:@"AutoCityView"];
    acv.loctionTag=_tfDepartureCity.tag;
    [self.navigationController pushViewController:acv animated:YES];
}


-(void)setGesturesOnLabel2
{
    UITapGestureRecognizer* gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction2:)];
    // if labelView is not set userInteractionEnabled, you must do so
    
    [_tfArrivalCity setUserInteractionEnabled:YES];
    [_tfArrivalCity addGestureRecognizer:gesture2];
}


- (void)gestureAction2: (UITapGestureRecognizer *)recognizer
{
    //Code to handle the gesture
    AutoCityView *acv = [self.storyboard instantiateViewControllerWithIdentifier:@"AutoCityView"];
    //acv.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    acv.loctionTag=_tfArrivalCity.tag;
    [self.navigationController pushViewController:acv animated:YES];
}

-(void)addDatePickerWithToolBar:(int)tag{
    
    _isShowPicker=TRUE;
    CGFloat orgW=self.view.frame.size.width;
    CGFloat orgPVH=180;
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-orgPVH-44,orgW,44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-orgPVH,orgW,orgPVH);
    
    //pickerView
    datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height+44,orgW, orgPVH)];
    datePicker.backgroundColor=[UIColor whiteColor];
    //
    //NSTimeZone *timeZoneJ = [NSTimeZone timeZoneWithAbbreviation:@"UTC+09:00"];
    //datePicker.timeZone=timeZoneJ;
    //[datePicker addTarget:self action:@selector(pickerAction:) forControlEvents:UIControlEventValueChanged]; // method to respond to changes in the picker value
    
    //Set Date
    datePicker.tag=tag;
    //
    datePicker.timeZone=[NSTimeZone timeZoneWithAbbreviation:@"IST"];
    if (tag==1001) {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
        //
        datePicker.locale=locale;
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        datePicker.date=[self dateStringToDateTime:pickupDate]; //For One Way
        datePicker.minimumDate=[self dateInIST];
        datePicker.maximumDate=[self dateWithNextYearDate:[self dateInIST]];
    }else{
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.date=[self dateStringToDate:dropDate];   //For Return
        datePicker.minimumDate=[self dateStringToDate:pickupDate];
        datePicker.maximumDate=[self dateWithNextYearDate:[self dateStringToDate:dropDate]];
    }
    
    [self.view addSubview:datePicker];
    
    //toolBar
    CGFloat tbH;
    tbH=44;
    
    toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height,orgW, 44)];
    
    UIBarButtonItem *IDLeftTBBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    IDLeftTBBtn.tintColor=[UIColor lightGrayColor];
    IDLeftTBBtn.tag=tag;
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //
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
    //
    if (sender.tag==1001){
        //
        NSString *dateStringhhmm=[self dateWith_ddMMyyyyhhmm:datePicker.date];
        NSString *dateString=[self dateWith_ddMMyyyy:datePicker.date];
        //
        pickupDate=dateStringhhmm;
        dropDate=dateString;
        //
        NSArray *dateStyleArray=[self splitString:[self dateWith_ddMMMyyEEE:datePicker.date] pattern:@"/"];
        _lbDpView1dd.text=[self textWithOrdinalStyle:dateStyleArray[0]];
        _lbDpView1mmyy.text=[NSString stringWithFormat:@"%@ %@",dateStyleArray[1],dateStyleArray[2]];
        _lbDpView1Day.text=dateStyleArray[3];
        
        _lbDpView2dd.text=[self textWithOrdinalStyle:dateStyleArray[0]];
        _lbDpView2mmyy.text=[NSString stringWithFormat:@"%@ %@",dateStyleArray[1],dateStyleArray[2]];
        _lbDpView2Day.text=dateStyleArray[3];
        
    }else if (sender.tag==1002){
        //
        NSString *dateString=[self dateWith_ddMMyyyy:datePicker.date];
        NSArray *dateStyleArray=[self splitString:[self dateWith_ddMMMyyEEE:datePicker.date] pattern:@"/"];
        
        dropDate=dateString;
        _lbDpView2dd.text=[self textWithOrdinalStyle:dateStyleArray[0]];
        _lbDpView2mmyy.text=[NSString stringWithFormat:@"%@ %@",dateStyleArray[1],dateStyleArray[2]];
        _lbDpView2Day.text=dateStyleArray[3];
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


-(void)showPopPicker
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PopPickerView"];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:vc animated:YES completion:nil];
}


-(IBAction)searchTaxi:(id)sender{
    if (_tfDepartureCity.text.length==0){
        [self alertWithText:nil message:atDCity];
        return;
    }
    else if (_tfArrivalCity.text.length==0){
        [self alertWithText:nil message:atACity];
        return;
    }
    else if ([_tfArrivalCity.text isEqualToString:_tfDepartureCity.text]){
        [self alertWithText:nil message:atValidateCity];
        return;
    }
    else{
        [self callService];
    }
}


-(IBAction)tripAction:(UIButton*)sender{
    [self setTripTypeAction:sender.tag];
}

-(void)setTripTypeAction:(NSInteger)sender{
    [self hideDropView:sender];
    
    if (sender==0) {
        tripType=@"0";  //for One Way
        [owBtn setBackgroundColor:[self colorWithCode:@"1896C1"]];
        [owBtn setTitleColor:[self colorWithCode:@"ffffff"] forState:UIControlStateNormal];
        
        [rtBtn setBackgroundColor:[self colorWithCode:@"ffffff"]];
        [rtBtn setTitleColor:[self colorWithCode:@"1896C1"] forState:UIControlStateNormal];
    }else if (sender==1){
        tripType=@"1";  //for Return Way

        [owBtn setBackgroundColor:[self colorWithCode:@"ffffff"]];
        [owBtn setTitleColor:[self colorWithCode:@"1896C1"] forState:UIControlStateNormal];
        
        [rtBtn setBackgroundColor:[self colorWithCode:@"1896C1"]];
        [rtBtn setTitleColor:[self colorWithCode:@"ffffff"] forState:UIControlStateNormal];
    }
}

-(void)hideDropView:(NSInteger)sender
{
    if (sender==0) {
        DPView2.hidden=TRUE;
    }
    else{
        DPView2.hidden=FALSE;
    }
}

-(IBAction)addMoreCity:(UIButton*)sender{
    [self setAddMoreCityView:sender.tag];
}


-(void)setAddMoreCityView:(NSInteger)tag
{
    if (tag==0) {
        _isAddMoreCtiy=TRUE;
        _btnAddMoreCity.tag=1;
        [_btnAddMoreCity setTitle:@"Remove City" forState:UIControlStateNormal];
       
        uvMoreCity.hidden=FALSE;
        //
        CGRect uvDpPickerFrame = uvDpPicker.frame;
        uvDpPickerFrame.origin=CGPointMake(uvMoreCity.frame.origin.x, uvMoreCity.frame.origin.y+uvMoreCity.frame.size.height+8);
        uvDpPicker.frame=uvDpPickerFrame;
        
        //
        CGRect uvBtnFrame = _btnSearchTaxi.frame;
        uvBtnFrame.origin=CGPointMake(_btnSearchTaxi.frame.origin.x,uvDpPicker.frame.origin.y+uvDpPicker.frame.size.height+8);
        _btnSearchTaxi.frame=uvBtnFrame;
    }else{
        
        _isAddMoreCtiy=FALSE;
        
        _btnAddMoreCity.tag=0;
        [_btnAddMoreCity setTitle:@"Add More City" forState:UIControlStateNormal];
        
        uvMoreCity.hidden=TRUE;
        
        //
        CGRect uvDpPickerFrame = uvDpPicker.frame;
        uvDpPickerFrame.origin=CGPointMake(uvMoreCity.frame.origin.x, uvMoreCity.frame.origin.y);
        uvDpPicker.frame=uvDpPickerFrame;
        
        //
        CGRect uvBtnFrame = _btnSearchTaxi.frame;
        uvBtnFrame.origin=CGPointMake(_btnSearchTaxi.frame.origin.x,uvDpPicker.frame.origin.y+uvDpPicker.frame.size.height+8);
        _btnSearchTaxi.frame=uvBtnFrame;
    }
}


-(void)setCDOnDatesView{
    NSString *dateStringhhmm=[self dateWith_ddMMyyyyhhmm:[self dateInIST]];
    NSString *dateString=[self dateWith_ddMMyyyy:[self dateInIST]];
    //
    NSArray *dateStyleArray=[self splitString:[self dateWith_ddMMMyyEEE:[self dateInIST]] pattern:@"/"];
    //
    pickupDate=dateStringhhmm;
    dropDate=dateString;
    //
    _lbDpView1dd.text=[self textWithOrdinalStyle:dateStyleArray[0]];
    _lbDpView1mmyy.text=[NSString stringWithFormat:@"%@ %@",dateStyleArray[1],dateStyleArray[2]];
    _lbDpView1Day.text=dateStyleArray[3];
    //
    _lbDpView2dd.text=[self textWithOrdinalStyle:dateStyleArray[0]];
    _lbDpView2mmyy.text=[NSString stringWithFormat:@"%@ %@",dateStyleArray[1],dateStyleArray[2]];
    _lbDpView2Day.text=dateStyleArray[3];
}

-(void)callService{
    
    //set setModalBaseTaxi
    self.mg.mbt.departureDate=[self splitString:pickupDate pattern:@" "][0];
    self.mg.mbt.returnDate=dropDate;
    self.mg.mbt.tripType=tripType;
    self.mg.mbt.locationIds=[self locationIDdicToStr:selectedTripCites];
    
    //
    WebServiceClass *WSC = [[WebServiceClass alloc] init];
    NSString *auth=[self createAuth:merchantId string2:[self uniqueTstamp] string3:authPassword];
    NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
    [postDic setObject:merchantId forKey:@"merchantId"];
    [postDic setObject:[self uniqueTstamp] forKey:@"salt"];
    [postDic setObject:self.mg.mbt.locationIds forKey:@"cityIds"];
    [postDic setObject:self.mg.mbt.tripType forKey:@"tripType"];
    [postDic setObject:self.mg.mbt.departureDate forKey:@"pickupDate"];
    
    if ([self.mg.mbt.tripType isEqualToString:@"1"]) {
        [postDic setObject:self.mg.mbt.returnDate forKey:@"dropDate"];
    }
    [WSC getServerResponseForUrl:postDic serviceURL:IDSearchTaxi isPOST:YES isLoder:YES auth:auth view:self.view  withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        if (success) {
            if ([[response valueForKey:@"status"] isEqualToString:@"error"])
            {
                [self alertWithText:@"Error!" message:[response valueForKey:@"error"]];
                return;
            }else{
                cabList=[[[response valueForKey:@"result"] valueForKey:@"results"] valueForKey:@"taxis"];
                CabListView *cdv = [self.storyboard instantiateViewControllerWithIdentifier:@"CabListView"];
                cdv.cabList=cabList;
                [self.navigationController pushViewController:cdv animated:YES];
            }
        }else{
            [self alertWithText:@"Error!" message:error.localizedDescription];
            return;
        }
    }];
}

-(NSString*)locationIDdicToStr:(NSDictionary*)setDic
{
    NSString *string=@"";
    NSString *city1=[NSString stringWithFormat:@"%@",[setDic valueForKey:@"city1"]];
    NSString *city2=[NSString stringWithFormat:@"%@",[setDic valueForKey:@"city2"]];
    NSString *city3=[NSString stringWithFormat:@"%@",[setDic valueForKey:@"city3"]];
    
    if (_isAddMoreCtiy && city3.length!=0) {
        string=[NSString stringWithFormat:@"%@,%@,%@",city1,city2,city3];
    }else{
        string=[NSString stringWithFormat:@"%@,%@",city1,city2];
    }
    return string;
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
