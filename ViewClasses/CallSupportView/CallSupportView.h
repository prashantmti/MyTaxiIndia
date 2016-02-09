//
//  CallSupportView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/16/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallSupportView : BaseView<UITextViewDelegate>
{
    IBOutlet UIView *vwMain;
    
    IBOutlet UILabel *llHeadTitle;
    IBOutlet UIView  *uvEnquiry;
    IBOutlet UIView  *uvCallSuport;
}

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *TPScrollView;

@property (weak, nonatomic) IBOutlet UITextField *TFName;
@property (weak, nonatomic) IBOutlet UITextField *TFPhoneNo;
@property (weak, nonatomic) IBOutlet UITextField *TFEmailID;
@property (weak, nonatomic) IBOutlet UITextView *TVEnquiry;

@property (weak, nonatomic) IBOutlet UIButton *BTNCallUs;
@property (weak, nonatomic) IBOutlet UIButton *BTNSendEnquiry;

@property (weak,nonatomic) IBOutlet UIBarButtonItem *barButton;

@property (nonatomic, assign) BOOL isTextViewEmpty;
@end
