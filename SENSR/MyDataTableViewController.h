//
//  MyDataTableViewController.h
//  SENSR
//
//  Created by Sunyoung Kim on 8/10/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataTableViewCell;

@interface MyDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>{
    
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)configureCell:(DataTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end
