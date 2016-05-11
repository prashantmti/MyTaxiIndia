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
    //
    GMSMarker*driverGMaker,*userGMaker;
}

@property (strong, nonatomic) NSOperationQueue *operationQueue;
@property (strong, nonatomic) NSOperation *operation;

//
@property(nonatomic,retain) CLLocationManager *locationManager;
@property(nonatomic,retain) CLLocation *clLocation;
//
@property (strong, nonatomic) NSDictionary *dicBookingDetails;
@property (strong, nonatomic) NSString *strDriverDetailsObj;

@property (assign, nonatomic) NSInteger trackinTag;

@property (assign, nonatomic) BOOL isLoader;
@end
