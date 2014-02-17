//
//  MyProjectViewController.m
//  SENSR
//
//  Created by Sunyoung Kim on 8/8/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MyProjectViewController.h"
#import "ReportTableViewController.h"
#import "Reachability.h"
#import "AnnotationType.h"
#import "AnnotationTableViewController.h"

@interface MyProjectViewController ()

@end

@implementation MyProjectViewController

@synthesize project;
@synthesize locationManager = _locationManager;
@synthesize mapView;
@synthesize toolBar;
@synthesize reportButton;
@synthesize navBar;
@synthesize selectedAnnotation;
@synthesize isLocationCalled;

static NSString *CALL_DATA_URL = @"http://www.sensr.org/app/callAnnotations.php";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navBar.title = project.title;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation=YES;
    //self.mapView.userTrackingMode=NO;
    
    //[self.mapView setUserTrackingMode:MKUserTrackingModeNone animated:NO];
    //self.mapView.userTrackingMode=MKUserTrackingModeFollow;
    //[self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    //[self showPinData:[self callPinData]];
    if([self checkInternet]){
        [[self locationManager] startUpdatingLocation];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"No Internet Connection"
                              message:@"The Internet connection appears to be offline."
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    
    [toolBar setFrame:CGRectMake(0, 410, 320, 70)];
    
    UIButton* button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(reportButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    UIImage *buttonImage = [UIImage imageNamed:@"report_btn.png"];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setTitle:@"Report Data!" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    button.frame = CGRectMake(115, 10, 199,50);
    
    [toolBar addSubview:button];
}

-(void)showPinData:(NSArray *)pins{
    
   // MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation, 800, 800);
    //[self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
//	NSMutableArray *pinArray = [[NSMutableArray alloc] init];
	NSMutableArray *mapAnnotations = [[NSMutableArray alloc] init];
	
	int i=0;
	
//	float maxLatitude = currentLocation.latitude;
//	float minLatitude = currentLocation.latitude;
//	float maxLongitude = currentLocation.longitude;
//	float minLongitude = currentLocation.longitude;
	
 	for(NSDictionary *data in pins){
        
        
        // Add an annotation
//        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//        point.coordinate = currentLocation;
//        point.title = @"Where am I?";
//        point.subtitle = @"I'm here!!!";
//        [self.mapView addAnnotation:point];
        
        
        
        
        
		AnnotationType *annotation = [[AnnotationType alloc] init];
		annotation.annotationData = data;
        annotation.project = project;
        
//		[pinArray addObject:data];
//		maxLatitude = (maxLatitude > [[data valueForKey:@"_latitude"] floatValue])?maxLatitude:[[data valueForKey:@"_latitude"] floatValue];
//		minLatitude = (minLatitude < [[data valueForKey:@"_latitude"] floatValue])?minLatitude:[[data valueForKey:@"_latitude"] floatValue];
//		maxLongitude = (maxLongitude > [[data valueForKey:@"_longitude"] floatValue])?maxLongitude:[[data valueForKey:@"_longitude"] floatValue];
//		minLongitude = (minLongitude < [[data valueForKey:@"_longitude"] floatValue])?minLongitude:[[data valueForKey:@"_longitude"] floatValue];
		
		[mapAnnotations insertObject:annotation atIndex:i++];
        
        NSArray *temp = [data allKeys];
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        for(id object in temp){
            if ([object rangeOfString:@"_col"].location == NSNotFound) {
            }else{
                NSString *key = [[object stringByReplacingOccurrencesOfString:@"_col" withString:@""] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
                [result setValue:[data valueForKey:object] forKey:key];
            }
        }
        annotation.dataDictionary = result;
        annotation.imageName = [data objectForKey:@"_imageName"];
        
        [mapView addAnnotation:annotation];
	}
	
//	CLLocation *locSouthWest = [[CLLocation alloc] initWithLatitude:minLatitude longitude:minLongitude];
//    CLLocation *locNorthEast = [[CLLocation alloc] initWithLatitude:maxLatitude longitude:maxLongitude];
//	CLLocationDistance meters = [locSouthWest distanceFromLocation:locNorthEast];
//	// if there is no pin to show, set the meters manully.
//	if (meters == 0) {
//		meters = 10000;
//	}
//	MKCoordinateRegion region;
//    region.center = currentLocation;
//    region.span.latitudeDelta = meters / 111319.5;
//    region.span.longitudeDelta = meters / 111319.5;//0.2;
//	[mapView setRegion:region animated:YES];
	
//	[mapView addAnnotations:mapAnnotations];
}

-(IBAction)reportButtonPressed:(id)sender{
    [self performSegueWithIdentifier:@"ShowReportView" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowReportView"]) {
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        ReportTableViewController *projectViewController = (ReportTableViewController*)[navController topViewController];
        
        projectViewController.project = project;
        projectViewController.currentLocation = currentLocation;
        projectViewController.isMyData = NO;
    }
    if ([segue.identifier isEqualToString:@"ShowAnnotationDataFromMap"]) {
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        AnnotationTableViewController *projectViewController = (AnnotationTableViewController*)[navController topViewController];
       projectViewController.annotation = sender;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionButtonPressed:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:project.url]];
}


#pragma mark - location manager

#pragma mark -
#pragma mark Location Manager

- (CLLocationManager *)locationManager {
    if (locationManager != nil)
        return locationManager;
	
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    locationManager.delegate = self;
    
    return locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	[manager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    currentLocation = newLocation.coordinate;
    //[mapView setCenterCoordinate:currentLocation animated:YES];
    if (!isLocationCalled){
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation, 800, 800);
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
        isLocationCalled = YES;
        
        [self showPinData:[self callPinData]];
    }
}



- (void)mapView:(MKMapView *)view didUpdateUserLocation:(MKUserLocation *)userLocation{
//    NSLog(@"b");
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
//    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
//    if ( initialLocation == nil ){
//        self.initialLocation = userLocation.location;
//        MKCoordinateRegion region;
//        region.center = mapView.userLocation.coordinate;
//        //region.span = MKCoordinateSpanMake(0.5, 0.5);
//        //region = [mapView regionThatFits:region];
//        //[mapView setRegion:region animated:YES];
//        
//        
//        [self showPinData:[self callPinData]];
//    }
}

#pragma mark - MKMapViewDelegate methods.
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    //MKCoordinateRegion region;
    
    //region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate,1000,1000);
    //[mv setRegion:region animated:YES];
}


#pragma mark -
#pragma mark Annotation

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    //if you did all the steps this methosd will be called when a user taps the annotation on the map.
  //  NSLog(@"ADB");
}

- (void)showAnnotationData:(id)sender{

}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    AnnotationType *annView = view.annotation;
    [self performSegueWithIdentifier:@"ShowAnnotationDataFromMap" sender:annView];
}

- (MKAnnotationView *) mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>) annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
	MKPinAnnotationView* pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:nil];
	
	if (!pinView) {
		MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
		customPinView.animatesDrop = YES;
		customPinView.canShowCallout = YES;
		
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		[rightButton addTarget:self action:@selector(showAnnotationData:) forControlEvents:UIControlEventTouchUpInside];
        
        customPinView.rightCalloutAccessoryView = rightButton;
		
		return customPinView;
	}
	
	return pinView;
}

- (NSArray *)callPinData{
	int radius =  10;
    
	NSString *urlString = [NSString stringWithFormat:@"%@?uniqueID=%@&lat=%.6f&lng=%.6f&radius=%d", CALL_DATA_URL,project.uniqueID, currentLocation.latitude, currentLocation.longitude, radius];
	
	NSString *escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSError* error;
	NSArray *pinData = [[NSArray alloc] init];
    
    if([self checkInternet]){
		NSURL *url = [NSURL URLWithString:escapedUrl];
        NSData* data = [NSData dataWithContentsOfURL:url];
       NSDictionary* results = [NSJSONSerialization
                              JSONObjectWithData:data //1
                              
                              options:kNilOptions
                              error:&error];
        pinData = [results objectForKey:@"data"];
	}else{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Data cannot be loaded because you are not connected to the network. Please check your network connectivity." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes", nil];
		[alert show];
	}
	return pinData;
}

#pragma mark -
#pragma mark Check Connectivity

- (BOOL)checkInternet{
    Reachability *r = [Reachability reachabilityWithHostname:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    
    BOOL internet;
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
        internet = NO;
    else
        internet = YES;
    
    return internet;
}

@end
