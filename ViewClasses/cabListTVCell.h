//
//  cabListTVCell.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/15/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cabListTVCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *cabIMG;
@property (strong, nonatomic) IBOutlet UILabel *cabName;

@property (strong, nonatomic) IBOutlet UILabel *cabDetails;
@property (strong, nonatomic) IBOutlet UILabel *cabDistance;
@property (strong, nonatomic) IBOutlet UILabel *cabDisHR;


@end
