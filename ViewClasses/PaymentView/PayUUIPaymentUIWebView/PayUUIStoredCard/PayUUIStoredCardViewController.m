//
//  PayUUIStoredCardViewController.m
//  SeamlessTestApp
//
//  Created by Umang Arya on 08/10/15.
//  Copyright © 2015 PayU. All rights reserved.
//

#import "PayUUIStoredCardViewController.h"
#import "PayUSAOneTapToken.h"
#import "iOSDefaultActivityIndicator.h"

//
#import "CheckoutView.h"
@interface PayUUIStoredCardViewController ()

@property (strong, nonatomic) iOSDefaultActivityIndicator *defaultActivityIndicator;

@end

@implementation PayUUIStoredCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    _lblTotalFare.text=[NSString stringWithFormat:@"%@%@/-",rupee,self.paymentParam.amount];
    _lblTxnID.text=self.paymentParam.transactionID;
    
    //
    if ([self.paymentType isEqual:PAYMENT_PG_ONE_TAP_STOREDCARD]) {
        [self hideStoredCardObject];
        self.paymentType = PAYMENT_PG_ONE_TAP_STOREDCARD;
        _storedArray=[NSMutableArray arrayWithArray:self.paymentRelatedDetail.oneTapStoredCardArray];
    }
    else{
        self.textFieldCVV.hidden = false;
        self.paymentType = PAYMENT_PG_STOREDCARD;
        _storedArray=[NSMutableArray arrayWithArray:self.paymentRelatedDetail.storedCardArray];
        //
        //
        if (self.paymentParam.OneTapTokenDictionary == nil) {
            self.btnOneTab.hidden = true;
            self.lblOneTab.hidden = true;
        }
        else{
            self.btnOneTab.hidden = false;
            self.lblOneTab.hidden = false;
        }
    }
    [self setOTAction:0];
    [self setUI];
}


-(void)setUI{
    [self setBoxShadow:uvView1];
    [self setTextBoxLine:_textFieldCVV];
}

-(void)hideStoredCardObject{
    self.textFieldCVV.hidden = true;
    self.btnOneTab.hidden = true;
    self.lblOneTab.hidden = true;
}

-(void)dismissKeyboard {
    [self.textFieldPaymentTypeForSC resignFirstResponder];
    [self.textFieldCVV resignFirstResponder];
}

#pragma TableView DataSource and Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _storedArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_STOREDCARD];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_STOREDCARD];
    }
    PayUModelStoredCard *modelStoredCard = [PayUModelStoredCard new];
    modelStoredCard=[_storedArray objectAtIndex:indexPath.row];
    //
    cell.textLabel.text = modelStoredCard.cardNo;
    cell.detailTextLabel.text = modelStoredCard.cardName;
    return cell;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self configurePaymentParamWithIndex:indexPath.row];
}

-(void)configurePaymentParamWithIndex:(NSInteger) index{
    PayUModelStoredCard *modelStoredCard = [PayUModelStoredCard new];
    modelStoredCard=[_storedArray objectAtIndex:index];
    //
    self.paymentParam.cardToken = modelStoredCard.cardToken;
    self.paymentParam.cardBin = modelStoredCard.cardBin;
    self.paymentParam.oneTapFlag = modelStoredCard.oneTapFlag;
}

//---------------------------------------
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    [self configurePaymentParamWithIndex:indexPath.row];
    //
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_storedArray removeObjectAtIndex:indexPath.row];
        [self deleteStoredCard];
        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//----------------------

-(PayUModelPaymentParams *) getPaymentParam{
    return self.paymentParam;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)PayBySC:(id)sender {
    
    self.createRequest = [PayUCreateRequest new];
    if ([self.paymentType isEqual:PAYMENT_PG_ONE_TAP_STOREDCARD]) {
        //self.paymentParam.isPaymentTypeOneTap = true;
        //            self.paymentParam.
    }
    else{
        self.paymentParam.CVV = self.textFieldCVV.text;
        if (_isOneTab==YES) {
            self.paymentParam.isOneTap = 1;
        }
    }

    [self.createRequest createRequestWithPaymentParam:self.paymentParam forPaymentType:self.paymentType withCompletionBlock:^(NSMutableURLRequest *request, NSString *postParam, NSString *error) {
        
        if (error == nil) {
            PayUUIPaymentUIWebViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_CONTROLLER_IDENTIFIER_PAYMENT_UIWEBVIEW];
            webView.paymentRequest = request;
            webView.paymentParam = self.paymentParam;
            [self.navigationController pushViewController:webView animated:true];
        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"ERROR" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }];
}

- (void)deleteStoredCard{
    [IDLoader setOnView:self.view withTitle:nil animated:YES];
    //
    self.webServiceResponse = [PayUWebServiceResponse new];
    [self.webServiceResponse deleteStoredCard:self.paymentParam withCompletionBlock:^(NSString *deleteStoredCardStatus, NSString *deleteStoredCardMessage, NSString *errorMessage, id extraParam) {
        if (errorMessage == nil) {
            UIAlertController * alert=[UIAlertController
                                          alertControllerWithTitle:nil
                                          message:@"Your Saved Card has been deleted."
                                          preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action){
                                    //
                                    [IDLoader hideFromView:self.view animated:YES];
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                     for (UIViewController *controller in self.navigationController.viewControllers) {
                                         
                                         if ([controller isKindOfClass:[CheckoutView class]]) {
                                             
                                             [self.navigationController popToViewController:controller
                                                                                   animated:YES];
                                             break;
                                         }
                                     }
                                    [self.navigationController popViewControllerAnimated:YES];
                                     
                                 }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            PAYUALERT(@"Error",errorMessage);
        }
    }];
}

-(void)addErrorLabel{
    _tableViewStoredCard.hidden=true;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    errorLbl=[[UILabel alloc]init];
    
    CGFloat srW=screenRect.size.width;
    CGFloat srH=screenRect.size.height;
    
    CGFloat lblW=srW-20;
    CGFloat lblH=40;
    
    errorLbl.frame=CGRectMake(srW/2-lblW/2,srH/2-lblH/2,lblW,lblH);
    errorLbl.text=@"No Booking Found";
    errorLbl.textAlignment=NSTextAlignmentCenter;
    errorLbl.textColor=[UIColor lightGrayColor];
    errorLbl.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:errorLbl];
}

-(IBAction)oneTabAction:(UIButton*)sender{
    [self setOTAction:sender.tag];
}

-(void)setOTAction:(NSInteger)tagValue{
    //
    if (tagValue==0) {
        _isOneTab=NO;
        _btnOneTab.tag=1;
        [_btnOneTab setImage:[UIImage imageNamed:@"checkFalse"]
                    forState:UIControlStateNormal];
    }else{
        _isOneTab=YES;
        _btnOneTab.tag=0;
        [_btnOneTab setImage:[UIImage imageNamed:@"checkTrue"]
                    forState:UIControlStateNormal];
    }
    //
    NSLog(@"setOTAction tag===>%d",tagValue);
    NSLog(@"_isOneTab===>%d",_isOneTab);
}
@end
