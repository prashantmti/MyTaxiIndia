//
//  DriverTrackingView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 1/29/16.
//  Copyright © 2016 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GoogleMaps/GoogleMaps.h>
//
#import <CoreLocation/CoreLocation.h>


@interface DriverTrackingView : BaseView<GMSMapViewDelegate,CLLocationManagerDelegate>
{
    IBOutlet GMSMapView *mapView_;
    //
    NSTimer *timer;
}

//
@property(nonatomic,retain) CLLocationManager *locationManager;
//
@property (strong, nonatomic) NSDictionary *dicBookingDetails;
@property (strong, nonatomic) NSString *strDriverDetailsObj;
@end
