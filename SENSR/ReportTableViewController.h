//
//  ReportTableViewController.h
//  SENSR
//
//  Created by Sunyoung Kim on 8/9/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Project.h"
#import "Data.h"

@interface ReportTableViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate>{
    UIButton *cancelButton;
    Project *project;
    Data *data;
    NSDictionary *annotationData;
    
    NSString *temp;
    BOOL isPhotoUsed;
    BOOL isPhotoLoaded;
    BOOL isMyData;
    
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
    
    UITextField *activeField;
    int centerY;
}

@property (nonatomic, retain) UITextField *activeField;
@property (nonatomic, assign) int centerY;

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UILabel *loadingLabel;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, assign) int numTextfield;
@property (nonatomic, assign) int numTab2;
@property (nonatomic, assign) int numTab3;
@property (nonatomic, assign) int numTabs;

@property (nonatomic, retain) NSMutableArray *dataToUpload;
@property (nonatomic, retain) NSMutableArray *labelsArray;
@property (nonatomic, retain) UIButton *photoViewButton;
@property (nonatomic, retain) UIButton *footerButton;

@property (nonatomic, retain) UIView *maskView;
@property (nonatomic, retain) UIImage *dataImage;
@property (nonatomic, assign) BOOL isPhotoUsed;
@property (nonatomic, assign) BOOL isPhotoLoaded;
@property (nonatomic, assign) BOOL isMyData;


@property (nonatomic, retain) NSString *temp;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) Data *data;
@property (nonatomic, retain) NSDictionary *annotationData;

@property (nonatomic, readwrite) CLLocationCoordinate2D currentLocation;

- (IBAction)cancelButtonPressed:(id)sender;
- (void)showSpinners;
- (void)showAlert:(NSString*)condition;
- (BOOL)checkInternet;
- (BOOL)uploadImage:(NSString*)imageName;

@end
