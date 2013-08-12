//
//  MyProjectsTableViewController.h
//  SENSR
//
//  Created by Sunyoung Kim on 8/7/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MyProjectsTableViewController : UITableViewController <MKMapViewDelegate, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate>{
    UIBarButtonItem *editButton;
}


@property (nonatomic, retain) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


- (IBAction)editButtonPressed:(id)sender;

@end
