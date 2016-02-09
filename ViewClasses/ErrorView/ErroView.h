//
//  ErroView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 12/5/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErroView : UIViewController
{
    IBOutlet UIImageView * errorImgView;
}
@property(strong,nonatomic) NSString *errorMsgStr;
@property(strong,nonatomic) IBOutlet UILabel *errorMsg;
@end
