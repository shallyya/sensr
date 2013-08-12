//
//  ReportTableViewController.h
//  SENSR
//
//  Created by Sunyoung Kim on 8/9/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AnnotationType.h"
#import "Data.h"

@interface AnnotationTableViewController : UITableViewController <UINavigationControllerDelegate>{
    UIButton *backButton;
    AnnotationType *annotation;
    Project *project;
    Data *data;
    NSDictionary *annotationData;
    
    NSString *temp;
    BOOL isPhotoUsed;
    BOOL isPhotoLoaded;
    BOOL isMyData;
    BOOL isAnnotation;
    
    UIButton *footerButton;
    UIButton *photoViewButton;
    NSMutableArray *dataToUpload;
    UIImage *dataImage;
    NSMutableArray *labelsArray;
    UIView *maskView;
    
    int numTextfield;
    int numTab2;
    int numTab3;
    int numTabs;
    
    CLLocationCoordinate2D currentLocation;
    
    UILabel *loadingLabel;
    UIActivityIndicatorView *activityIndicator;
    
}

@property (nonatomic, assign) int numTextfield;
@property (nonatomic, assign) int numTab2;
@property (nonatomic, assign) int numTab3;
@property (nonatomic, assign) int numTabs;

@property (nonatomic, retain) NSMutableArray *dataToUpload;
@property (nonatomic, retain) NSMutableArray *labelsArray;

@property (nonatomic, retain) UIImage *dataImage;


@property (nonatomic, retain) NSString *temp;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) AnnotationType *annotation;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) Data *data;
@property (nonatomic, retain) NSDictionary *annotationData;

@property (nonatomic, readwrite) CLLocationCoordinate2D currentLocation;

- (IBAction)backButtonPressed:(id)sender;

@end
