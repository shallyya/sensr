//
//  MyProjectViewController.h
//  SENSR
//
//  Created by Sunyoung Kim on 8/8/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Project.h"
#import "Data.h"

@interface MyProjectViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>{
    Project *project;
    CLLocationCoordinate2D currentLocation;
	CLLocationManager *locationManager;
    UIToolbar *toolBar;
    UIBarButtonItem *reportButton;
    UINavigationItem *navBar;
    Data *selectedAnnotation;
}

@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) Data *selectedAnnotation;

@property (nonatomic, readwrite) BOOL isLocationCalled;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *reportButton;
@property (nonatomic, retain) IBOutlet UINavigationItem *navBar;

- (IBAction)closeButtonPressed:(id)sender;
- (IBAction)actionButtonPressed:(id)sender;
- (BOOL)checkInternet;

@end
