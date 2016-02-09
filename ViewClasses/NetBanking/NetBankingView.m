//
//  NetBankingView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/5/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "NetBankingView.h"

@interface NetBankingView ()

@end

@implementation NetBankingView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _lblTotalFare.text=[NSString stringWithFormat:@"%@%@/-",rupee,self.paymentParam.amount];
    _lblTxnID.text=self.paymentParam.transactionID;
    
    //    NSLog(@"paymentParam===>%@",self.paymentParam);
    //    NSLog(@"paymentRelatedDetail===>%@",self.paymentRelatedDetail);
    
    //
    [self setUI];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    if ([self.paymentType isEqual:PAYMENT_PG_CASHCARD]) {
        self.lblTitlePaymentOption.text = @"Select Cashcard";
        //
        self.navigationItem.title=@"CASH CARD";
    }else{
        self.lblTitlePaymentOption.text = @"Select Bank";
        //
        self.navigationItem.title=@"NET BANKING";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUI{
    [self setBoxShadow:uvView1];
    
    //
    [self setLabelUnderLine:_lblTitlePaymentOption];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma TableView DataSource and Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.paymentType isEqual:PAYMENT_PG_CASHCARD]) {
        return self.paymentRelatedDetail.cashCardArray.count;
    }
    else{
        return self.paymentRelatedDetail.netBankingArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_NETBANKING];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_NETBANKING];
    }
    if ([self.paymentType isEqual:PAYMENT_PG_CASHCARD]) {
        PayUModelCashCard *modelCashCard = [PayUModelCashCard new];
        modelCashCard = [self.paymentRelatedDetail.cashCardArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = modelCashCard.bankCode;
        cell.detailTextLabel.text = modelCashCard.title;
    }
    else{
        PayUModelNetBanking *modelNetBanking = [PayUModelNetBanking new];
        modelNetBanking = [self.paymentRelatedDetail.netBankingArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = modelNetBanking.bankCode;
        cell.detailTextLabel.text = modelNetBanking.title;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.paymentType isEqual:PAYMENT_PG_CASHCARD]) {
        PayUModelCashCard *modelCashCard = [PayUModelCashCard new];
        modelCashCard = [self.paymentRelatedDetail.cashCardArray objectAtIndex:indexPath.row];
        _bankCode=modelCashCard.bankCode;
    }
    else{
        PayUModelNetBanking *modelNetBanking = [PayUModelNetBanking new];
        modelNetBanking = [self.paymentRelatedDetail.netBankingArray objectAtIndex:indexPath.row];
        _bankCode=modelNetBanking.bankCode;
    }
}


- (IBAction)PayByNetBanking:(id)sender {
    
    if ([self.paymentType isEqual:PAYMENT_PG_NET_BANKING]) {
        self.paymentParam.bankCode = _bankCode;
    }else{
        self.paymentParam.bankCode = _bankCode;
    }
    self.createRequest = [PayUCreateRequest new];
    
    [self.createRequest createRequestWithPaymentParam:self.paymentParam forPaymentType:self.paymentType withCompletionBlock:^(NSMutableURLRequest *request, NSString *postParam, NSString *error) {
        if (error == nil) {
            PayUUIPaymentUIWebViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_CONTROLLER_IDENTIFIER_PAYMENT_UIWEBVIEW];
            webView.paymentRequest = request;
            webView.merchantKey = self.paymentParam.key;
            webView.txnID = self.paymentParam.transactionID;
            [self.navigationController pushViewController:webView animated:true];
        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"ERROR" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            
        }
    }];
}
@end
