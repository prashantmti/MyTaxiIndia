//
//  PopPickerView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/31/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "PopPickerView.h"

@interface PopPickerView ()

@end

@implementation PopPickerView
@synthesize seatingAvailability,selectedValue,DicSelectedCab,DicTripDates;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    seatingAvailability=[DicSelectedCab valueForKey:@"availability"];
    availabilityArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 1; i <=[seatingAvailability intValue]; i++)
        [availabilityArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
    [datePicker setLocale:locale];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self GATrackOnView:NSStringFromClass(self.class) kGAIScreenName:kGAIScreenName];
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

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    index =row;
}


-(IBAction)close:(id)sender{
    //NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    //[timeFormatter setTimeZone:timeZone];
    [timeFormatter setDateFormat:@"HH:mm"]; //24hr time format
    NSString *timeString = [timeFormatter stringFromDate:datePicker.date];
    
    NSString *pickDateStr=[NSString stringWithFormat:@"%@ %@",[DicTripDates valueForKey:@"pickupDate"],timeString];
    
    int diff=[self dateTimeDiff:pickDateStr];

    if (diff<12) {
        [self alertWithText:nil message:@"Booking should be done at least 12 hours in advance"];
        return;
    }else{
        NSInteger selectedAvailability=[[availabilityArray objectAtIndex:index] integerValue];
        if (selectedAvailability>[seatingAvailability integerValue])
        {
            [self alertWithText:nil message:@"car not available"];
        }else{            
            NSDictionary* postParmsDic= @{
                                          @"noOfCars":[NSString stringWithFormat:@"%ld",(long)selectedAvailability],
                                          @"pickTime":timeString,
                                          @"DicSelectedCab":DicSelectedCab,
                                          };
            [self dismissViewControllerAnimated:YES completion:^
             {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"pushToSingle" object:nil userInfo:postParmsDic];
             }];
        }
    }
}

-(IBAction)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)displayNewVC
{
    PopPickerView *PPV = [[PopPickerView alloc] init];
    PPV.view.frame=CGRectMake(PPV.view.frame.origin.x,PPV.view.frame.origin.y, PPV.view.frame.size.width, PPV.view.frame.size.height);
    
    PPV.view.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [self.view addSubview:PPV.view];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        PPV.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // do something once the animation finishes, put it here
    }];
}
@end
