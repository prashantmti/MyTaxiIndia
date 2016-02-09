//
//  CabListView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/27/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CabListViewCell.h"
#import "PopPickerView.h"
#import "CheckoutView.h"

@interface CabListView : BaseView<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UILabel *pickUPdate;
}
@property (weak, nonatomic) IBOutlet UITableView *TBcabList;

@property (strong, nonatomic) NSArray *cabList;

@property (strong, nonatomic) NSDictionary *DicSelectedCab;

@property (strong, nonatomic) NSDictionary *DicTripDates;
//@property (assign, nonatomic) NSInteger noOfCars;


@property (strong, nonatomic) ModalGlobal *mg;

@property (strong, nonatomic) ModalBaseTaxis *mbt;
@end
