//
//  cabListTV.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/15/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cabListTVCell.h"
#import "cabDetailsView.h"

@interface cabListTV : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (weak, nonatomic) IBOutlet UITableView *cabListTb;



@end
