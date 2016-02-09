//
//  CabPickerView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/31/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "CabPickerView.h"

@interface CabPickerView ()

@end

@implementation CabPickerView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    availabilityArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 1; i <= 40; i++)
        [availabilityArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    
    NSLog(@"availabilityArray==>%@",availabilityArray);
    
    
    
    dataArray=[NSArray arrayWithObjects:@"New Delhi",@"Agra",@"Noida",@"Lucknow",@"Kanpur", nil];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma - pickerView delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [availabilityArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [availabilityArray objectAtIndex:row];
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    index =row;
}

@end
