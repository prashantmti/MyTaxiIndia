//
//  DriverTrackingView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 1/29/16.
//  Copyright © 2016 mytaxiit. All rights reserved.
//

#import "DriverTrackingView.h"

@interface DriverTrackingView ()

@end

@implementation DriverTrackingView
//@synthesize locationManager;

- (void)viewDidLoad {
    //
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    //
    mapView_.myLocationEnabled=YES;
    mapView_.settings.myLocationButton = YES;
    
    //
    [self getDriverLocation];
    //
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    timer = [NSTimer timerWithTimeInterval:10.0
                                                 target:self
                                               selector:@selector(getDriverLocation)
                                               userInfo:nil
                                                repeats:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        });        
    });
}

-(void)viewWillDisappear:(BOOL)animated{
    
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //
    //NSLog(@"location==>%@",locations);
    //
    [mapView_ clear];
    //
    CLLocation *location = (CLLocation*)locations.firstObject;
    //
    GMSMarker *pinview = [[GMSMarker alloc] init];
    pinview.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    pinview.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
    pinview.title = @"Your Location";
    pinview.snippet =nil;
    pinview.map = mapView_;
}


-(void)getDriverLocation{
    NSString*token,*tokenStr,*driverID,*bookingID;
    NSDictionary *driverDetails;
    //
    driverDetails=[[_dicBookingDetails valueForKey:@"items"][[_strDriverDetailsObj integerValue]] valueForKey:@"driver"];
    //
    bookingID=[_dicBookingDetails valueForKey:@"id"];
    driverID=[driverDetails valueForKey:@"driverId"];
    //
    tokenStr=[NSString stringWithFormat:@"%@#%@",driverID,bookingID];
    token=[self encodeWithSHA512:tokenStr];
    token=[token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token=[token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token=[token stringByReplacingOccurrencesOfString:@">" withString:@""];
    //
    WebServiceClass *WSC = [[WebServiceClass alloc] init];
    //
    NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
    [postDic setObject:token forKey:@"token"];
    [postDic setObject:driverID forKey:@"driverId"];
    [postDic setObject:bookingID forKey:@"id"];
    //
    [WSC getServerResponseForUrl:postDic serviceURL:IDGetDriverLocation isPOST:YES isLoder:nil auth:nil view:self.view  withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        if (success) {
            if ([[response valueForKey:@"status"] isEqualToString:@"error"]){
                [self alertWithText:@"Error!" message:[response valueForKey:@"error"]];
                return;
            }else{
                NSLog(@"response==>%@",response);
            }
        }else{
            [self alertWithText:@"Error!" message:error.localizedDescription];
            return;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end