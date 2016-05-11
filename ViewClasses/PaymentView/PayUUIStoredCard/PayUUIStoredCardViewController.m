//
//  PayUUIStoredCardViewController.m
//  SeamlessTestApp
//
//  Created by Umang Arya on 08/10/15.
//  Copyright © 2015 PayU. All rights reserved.
//

#import "PayUUIStoredCardViewController.h"
#import "PayUUIPaymentUIWebViewController.h"
@interface PayUUIStoredCardViewController ()

@end

@implementation PayUUIStoredCardViewController
@synthesize selectedCabInfo;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    _lblTotalFare.text=[NSString stringWithFormat:@"%@%@/-",rupee,self.paymentParam.amount];
    _lblTxnID.text=self.paymentParam.transactionID;
    
    [self setUI];
}


-(void)setUI{
    [self setBoxShadow:uvView1];
}

-(void)dismissKeyboard {
    [self.textFieldPaymentTypeForSC resignFirstResponder];
    [self.textFieldCVV resignFirstResponder];
}

#pragma TableView DataSource and Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.paymentType isEqual:PAYMENT_PG_ONE_TAP_STOREDCARD]) {
        return self.paymentRelatedDetail.oneTapStoredCardArray.count;
    }
    else{
        return self.paymentRelatedDetail.storedCardArray.count;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_STOREDCARD];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_STOREDCARD];
    }
    PayUModelStoredCard *modelStoredCard = [PayUModelStoredCard new];
    if ([self.paymentType isEqual:PAYMENT_PG_ONE_TAP_STOREDCARD]) {
        modelStoredCard = [self.paymentRelatedDetail.oneTapStoredCardArray objectAtIndex:indexPath.row];
    }
    else{
        modelStoredCard = [self.paymentRelatedDetail.storedCardArray objectAtIndex:indexPath.row];
    }
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
    if ([self.paymentType isEqual:PAYMENT_PG_ONE_TAP_STOREDCARD]) {
        modelStoredCard = [self.paymentRelatedDetail.oneTapStoredCardArray objectAtIndex:index];
    }
    else{
        modelStoredCard = [self.paymentRelatedDetail.storedCardArray objectAtIndex:index];
    }
    self.paymentParam.cardToken = modelStoredCard.cardToken;
    self.paymentParam.cardBin = modelStoredCard.cardBin;
    self.paymentParam.oneTapFlag = modelStoredCard.oneTapFlag;
}

-(PayUModelPaymentParams *) getPaymentParam{
    return self.paymentParam;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)PayBySC:(id)sender {

    self.paymentParam.CVV = self.textFieldCVV.text;
    self.createRequest = [PayUCreateRequest new];
    [self.createRequest createRequestWithPaymentParam:self.paymentParam forPaymentType:PAYMENT_PG_STOREDCARD withCompletionBlock:^(NSMutableURLRequest *request, NSString *postParam, NSString *error) {
        if (error == nil) {
            PayUUIPaymentUIWebViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_CONTROLLER_IDENTIFIER_PAYMENT_UIWEBVIEW];
            webView.paymentRequest = request;
            webView.merchantKey = self.paymentParam.key;
            webView.txnID = self.paymentParam.transactionID;
            webView.selectedCabInfo=selectedCabInfo;
            [self.navigationController pushViewController:webView animated:true];
        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"ERROR" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            
        }
    }];
}

- (IBAction)deleteStoredCard:(id)sender {
    self.webServiceResponse = [PayUWebServiceResponse new];
    [self.webServiceResponse deleteStoredCard:self.paymentParam withCompletionBlock:^(NSString *deleteStoredCardStatus, NSString *deleteStoredCardMessage, NSString *errorMessage, id extraParam) {
        if (errorMessage == nil) {
            
            //NSString *fullMessage =[NSString stringWithFormat:@"Status:%@ & Message:%@",deleteStoredCardStatus,deleteStoredCardMessage];
        
            
            UIAlertController * alert=[UIAlertController
                                          alertControllerWithTitle:nil
                                          message:@"Card has been deleted."
                                          preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                    [alert dismissViewControllerAnimated:YES completion:nil];
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
@end
