//
//  ErroView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 12/5/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "ErroView.h"

@interface ErroView ()

@end

@implementation ErroView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setImgOnView];
    _errorMsg.text=_errorMsgStr;
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



-(void)setImgOnView{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    if (screenHeight==480) {
        errorImgView.image=[UIImage imageNamed:@"Error320X480"];
    }
    if (screenHeight==568) {
        errorImgView.image=[UIImage imageNamed:@"Error320X568"];
    }
    if (screenHeight==667) {
        errorImgView.image=[UIImage imageNamed:@"Error375X667"];
    }
    else{
        errorImgView.image=[UIImage imageNamed:@"Error414X736"];
    }
    
    errorImgView.contentMode = UIViewContentModeScaleAspectFit;
}


-(IBAction)backActionFromErrorView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
