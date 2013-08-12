//
//  ProjectViewController.h
//  SENSR
//
//  Created by Sunyoung Kim on 8/5/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"

@interface ProjectViewController : UIViewController <NSFetchedResultsControllerDelegate, UIAlertViewDelegate>{
    NSMutableDictionary *projectDictionary;
    UIImageView *logoImageView;
    UILabel *titleLabel;
    UILabel *contactLabel;
    UILabel *keywordsLabel;
    UILabel *locationLabel;
    UITextView *description;
    UIScrollView *scrollView;
    UIButton *url;
    UIBarButtonItem *participateButton;
    UIToolbar *toolBar;
    Project *project;
    BOOL isMyproject;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Project *project;
@property (nonatomic, assign) BOOL isMyproject;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;
@property (nonatomic, retain) NSMutableDictionary * projectDictionary;
@property (nonatomic, retain) IBOutlet UIImageView *logoImageView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *contactLabel;
@property (nonatomic, retain) IBOutlet UILabel *keywordsLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UITextView *description;
@property (nonatomic, retain) IBOutlet UIButton *url;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *participateButton;

- (void) saveProject;
- (IBAction) participateButtonPressed:(id)sender;

@end
