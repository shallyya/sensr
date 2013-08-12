//
//  SENSRAppDelegate.h
//  SENSR
//
//  Created by Sunyoung Kim on 8/5/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyProjectsTableViewController;

@interface SENSRAppDelegate : UIResponder <UIApplicationDelegate> {
    MyProjectsTableViewController *myProjectTableViewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) MyProjectsTableViewController *myProjectTableViewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
