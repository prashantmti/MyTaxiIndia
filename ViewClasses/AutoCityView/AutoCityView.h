//
//  AutoCityView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/16/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

#import "AutoCityCell.h"
@interface AutoCityView : BaseView<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
        NSDictionary * resultWSDic;
    
    NSOperationQueue *operationQueue;
    NSBlockOperation *blockOperation;

}

@property (weak, nonatomic) IBOutlet UISearchBar *SBautoSearch;


@property (weak, nonatomic) IBOutlet UITableView *TbLocation;

@property(strong, nonatomic) NSArray * locationArray;
@property(strong, nonatomic) NSArray * plistLocationArray;

@property(assign, nonatomic) NSInteger loctionTag;
@property(assign, nonatomic) NSInteger tripTag;

@property(assign, nonatomic) BOOL isSearchAction;
@end
