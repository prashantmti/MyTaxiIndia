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
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    //
    userGMaker=[[GMSMarker alloc]init];
    driverGMaker=[[GMSMarker alloc]init];  
    //
    mapView_.myLocationEnabled=YES;
    mapView_.settings.myLocationButton = YES;
    
    //
    _isLoader=YES;        //1 on===>ViewLoad
    [self getDriverLocation];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    //
    [timer invalidate];
    //
    [self.locationManager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //
    _clLocation = (CLLocation*)locations.firstObject;
    //
    //
    userGMaker.position = CLLocationCoordinate2DMake(_clLocation.coordinate.latitude, _clLocation.coordinate.longitude);
    
    
    NSLog(@"user latitude===>%f",_clLocation.coordinate.latitude);
    NSLog(@"user longitude===>%f",_clLocation.coordinate.longitude);
    
    userGMaker.icon = [UIImage imageNamed:@"userGMaker"];
    userGMaker.title = nil;
    userGMaker.snippet =nil;
    userGMaker.map = mapView_;
    //
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

    [WSC getServerResponseForUrl:postDic serviceURL:IDGetDriverLocation isPOST:YES isLoder:_isLoader auth:nil view:self.view  withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        if (success) {
            if ([[response valueForKey:@"status"] isEqualToString:@"error"]){
                //
                UIAlertController * alert=  [UIAlertController
                                              alertControllerWithTitle:nil
                                              message:@"Driver's Location not available. Please try later."
                                              preferredStyle:UIAlertControllerStyleAlert];
                //
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         //Do some thing here, eg dismiss the alertwindow
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         [self.navigationController popViewControllerAnimated:YES];
                                         
                                     }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                //
            }else{
                //
                NSLog(@"response==>%@",response);
                //-----------------//
                [mapView_ clear];
                //
                userGMaker.position = CLLocationCoordinate2DMake(_clLocation.coordinate.latitude, _clLocation.coordinate.longitude);
                userGMaker.icon = [UIImage imageNamed:@"userGMaker"];
                userGMaker.title = nil;
                userGMaker.snippet =nil;
                userGMaker.map = mapView_;
                //
                _isLoader=false;
                
                NSArray *driverLocation;
                double driverLat,driverLng;
                
                driverLocation=[self splitString:[response valueForKey:@"LATLNG"] pattern:@","];
                driverLat=[driverLocation[0] doubleValue];
                driverLng=[driverLocation[1] doubleValue];
                
                timer = [NSTimer scheduledTimerWithTimeInterval:20.0 target: self selector: @selector(getDriverLocationTimer) userInfo: nil repeats: YES];
                driverGMaker.position = CLLocationCoordinate2DMake(driverLat,driverLng);
                driverGMaker.icon = [UIImage imageNamed:@"driverGMaker"];
                driverGMaker.title = nil;
                driverGMaker.snippet =nil;
                driverGMaker.map = mapView_;
                //
                //
                CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(_clLocation.coordinate.latitude,_clLocation.coordinate.longitude);
                CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake(driverLat,driverLng);
                GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:coord1 coordinate:coord2];
                [mapView_ moveCamera: [GMSCameraUpdate fitBounds:bounds]];
                //-------------------//
            }
        }else{
            [self alertWithText:@"Error!" message:error.localizedDescription];
            return;
        }
    }];
}

-(void)getDriverLocationTimer{
    
    NSLog(@"setTime===>%@",[NSDate date]);
    
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
    
    [WSC getServerResponseForUrl:postDic serviceURL:IDGetDriverLocation isPOST:YES isLoder:_isLoader auth:nil view:self.view  withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        if (success) {
            if ([[response valueForKey:@"status"] isEqualToString:@"error"]){
                //
                UIAlertController * alert=  [UIAlertController
                                             alertControllerWithTitle:nil
                                             message:@"Driver's Location not available. Please try later."
                                             preferredStyle:UIAlertControllerStyleAlert];
                //
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         //Do some thing here, eg dismiss the alertwindow
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         [self.navigationController popViewControllerAnimated:YES];
                                         
                                     }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                //
            }else{
                
                NSLog(@"response==>%@",response);
                
                //-----------------//
                [mapView_ clear];
                //
                userGMaker.position = CLLocationCoordinate2DMake(_clLocation.coordinate.latitude, _clLocation.coordinate.longitude);
                userGMaker.icon = [UIImage imageNamed:@"userGMaker"];
                userGMaker.title = nil;
                userGMaker.snippet =nil;
                userGMaker.map = mapView_;
                //
                _isLoader=false;
                
                NSArray *driverLocation;
                double driverLat,driverLng;
                
                driverLocation=[self splitString:[response valueForKey:@"LATLNG"] pattern:@","];
                
                //
                NSString *lat,*Lng;
                //
                lat=[self valueRoundOff8:driverLocation[0]];
                Lng=[self valueRoundOff8:driverLocation[1]];
                //
                driverLat=[lat doubleValue];
                driverLng=[Lng doubleValue];
                
                
                driverGMaker.position = CLLocationCoordinate2DMake(driverLat,driverLng);
                driverGMaker.icon = [UIImage imageNamed:@"driverGMaker"];
                driverGMaker.title = nil;
                driverGMaker.snippet =nil;
                driverGMaker.map = mapView_;
                //
                //
                CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(_clLocation.coordinate.latitude,_clLocation.coordinate.longitude);
                CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake(driverLat,driverLng);
                GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:coord1 coordinate:coord2];
                [mapView_ moveCamera: [GMSCameraUpdate fitBounds:bounds]];
                //-------------------//
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