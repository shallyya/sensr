//
//  MyDataTableViewController.m
//  SENSR
//
//  Created by Sunyoung Kim on 8/10/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import "MyDataTableViewController.h"
#import "SENSRAppDelegate.h"
#import "DataTableViewCell.h"
#import "ReportTableViewController.h"

@interface MyDataTableViewController ()

@end

@implementation MyDataTableViewController


@synthesize managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    SENSRAppDelegate *appDelegate = (SENSRAppDelegate *)[[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Data" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [[_fetchedResultsController sections] count];
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    
    NSInteger count = [sectionInfo numberOfObjects];
    return count;
    
//    id  sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
//    return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    NSArray *objects = [sectionInfo objects];
    NSManagedObject *managedObject = [objects objectAtIndex:0];
    BOOL isDataUploaded = [[managedObject valueForKey:@"isDataUploaded"] intValue];
    
    return (isDataUploaded)?@"Uploaded Data":@"Data to Upload";
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"dataCell";
    DataTableViewCell *cell = [[DataTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withCaller:@"data"];
    
    if (cell == nil) {
        cell = [[DataTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withCaller:@"data"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self configureCell:cell atIndexPath:indexPath];
	return cell;
}

- (void)configureCell:(DataTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath  {
    Data *d = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.data = d;
}

- (NSArray *)sortData {
	NSSortDescriptor *sortLastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
	NSArray *sortDescriptors = [NSArray arrayWithObjects:sortLastNameDescriptor, nil];
	return [(NSSet *)[_fetchedResultsController fetchedObjects] sortedArrayUsingDescriptors:sortDescriptors];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSManagedObjectContext *context = [_fetchedResultsController managedObjectContext];
		[context deleteObject:[_fetchedResultsController objectAtIndexPath:indexPath]];
		
        NSError *error = nil;
        
        if(![context save:&error]){
            NSLog(@"unresolved error %@ %@",error, [error userInfo]);
            abort();
        }
	}
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Data *d = [_fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"MyDataDetailFromMyDataList" sender:d];
}

#pragma mark - passing data to next page

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MyDataDetailFromMyDataList"]) {
        ReportTableViewController *projectViewController = segue.destinationViewController;
        projectViewController.data = sender;
        projectViewController.isMyData = YES;
        projectViewController.hidesBottomBarWhenPushed = YES;
    }
}

- (NSManagedObject*)getProjectInfo:(NSString*)uniqueID{
	NSManagedObject *project = [[NSManagedObject alloc] init];
	NSManagedObjectContext *context = [self managedObjectContext];
	NSEntityDescription *prjEntity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:context];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:prjEntity];
	
	NSArray *projects = [context executeFetchRequest:fetchRequest error:nil];
	id p;
	NSEnumerator *it = [projects objectEnumerator];
	while((p = [it nextObject])!=nil){
		if([[p valueForKey:@"uniqueID"] isEqualToString:uniqueID])
			project = p;
	}
	
	return project;
}

- (NSMutableDictionary*)convertProjectInfo:(NSManagedObject*)project{
	NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
	
	[data setValue:[project valueForKey:@"author"] forKey:@"author"];
	[data setValue:[project valueForKey:@"campaignDescription"] forKey:@"campaignDescription"];
	[data setValue:[project valueForKey:@"category"] forKey:@"category"];
	[data setValue:[project valueForKey:@"itemsOrder"] forKey:@"itemsOrder"];
	[data setValue:[project valueForKey:@"keywords"] forKey:@"keywords"];
	[data setValue:[project valueForKey:@"labelForSubmitBtn"] forKey:@"labelForSubmitBtn"];
	[data setValue:[project valueForKey:@"labelsForTab2"] forKey:@"labelsForTab2"];
	[data setValue:[project valueForKey:@"labelsForTab3"] forKey:@"labelsForTab3"];
	[data setValue:[project valueForKey:@"labelsForTextfield"] forKey:@"labelsForTextfield"];
	[data setValue:[project valueForKey:@"logoPath"] forKey:@"logoPath"];
	[data setValue:[project valueForKey:@"title"] forKey:@"title"];
	[data setValue:[project valueForKey:@"uniqueID"] forKey:@"uniqueID"];
	[data setValue:[project valueForKey:@"url"] forKey:@"url"];
	[data setValue:[project valueForKey:@"numTab2"] forKey:@"numTab2"];
	[data setValue:[project valueForKey:@"numTab3"] forKey:@"numTab3"];
	[data setValue:[project valueForKey:@"numTextfield"] forKey:@"numTextfield"];
	[data setValue:[project valueForKey:@"usePhoto"] forKey:@"usePhoto"];
	
	return data;
}

- (NSMutableDictionary*)convertDataInfo:(NSManagedObject*)project{
	NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
	
	NSString *tabDataString = [project valueForKey:@"tabData"];
	NSString *textFieldDataString = [project valueForKey:@"textFieldData"];
	NSArray *tabDataValues = [tabDataString componentsSeparatedByString:@"/"];
	NSArray *textFieldDataValues = [textFieldDataString componentsSeparatedByString:@"/"];
	
	for(int i=0;i<[textFieldDataValues count]-1;i++){
		NSArray *tempArray = [[textFieldDataValues objectAtIndex:i] componentsSeparatedByString:@":"];
		NSString *token= [tempArray objectAtIndex:1];
		[data setValue:[token substringWithRange:NSMakeRange(1, [token length]-2)] forKey:[tempArray objectAtIndex:0]];
	}
	
	
	for(int i=0;i<[tabDataValues count]-1;i++){
		NSArray *tempArray = [[tabDataValues objectAtIndex:i] componentsSeparatedByString:@":"];
		[data setValue:[tempArray objectAtIndex:1] forKey:[tempArray objectAtIndex:0]];
	}
	
	[data setValue:[project valueForKey:@"tabData"] forKey:@"tabData"];
	[data setValue:[project valueForKey:@"textFieldData"] forKey:@"textFieldData"];
	
	[data setValue:[project valueForKey:@"imageName"] forKey:@"imageName"];
	[data setValue:[project valueForKey:@"isDataUploaded"] forKey:@"isDataUploaded"];
	[data setValue:[project valueForKey:@"latitude"] forKey:@"latitude"];
	[data setValue:[project valueForKey:@"longitude"] forKey:@"longitude"];
	[data setValue:[project valueForKey:@"timestamp"] forKey:@"timestamp"];
	[data setValue:[project valueForKey:@"title"] forKey:@"title"];
	[data setValue:[project valueForKey:@"uniqueID"] forKey:@"uniqueID"];
	[data setValue:[project valueForKey:@"image"] forKey:@"image"];
	
	return data;
}

#pragma mark -
#pragma mark Fetched results controller
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Data" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"timestamp" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sectorSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"isDataUploaded" ascending: YES];
	NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending: NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects: sectorSortDescriptor, dateSortDescriptor, nil];
	[fetchRequest setSortDescriptors: sortDescriptors];

    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:managedObjectContext sectionNameKeyPath:@"isDataUploaded"
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

//- (NSFetchedResultsController *)fetchedResultsController {
//	
//    if (_fetchedResultsController != nil) {
//        return _fetchedResultsController;
//    }
//    
//    /*
//     Set up the fetched results controller.
//	 */
//    // Create the fetch request for the entity.
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    // Edit the entity name as appropriate.
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Data" inManagedObjectContext:self.managedObjectContext];
//	[fetchRequest setEntity:entity];
//    
//	// // Set the batch size to a suitable number.
//    [fetchRequest setFetchBatchSize:20];
//	
//	NSSortDescriptor *sectorSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"isDataUploaded" ascending: YES];
//	NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending: NO];
//	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects: sectorSortDescriptor, dateSortDescriptor, nil];
//	[fetchRequest setSortDescriptors: sortDescriptors];
//
//    // Edit the section name key path and cache name if appropriate.
//    // nil for section name key path means "no sections".
//    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"isDataUploaded" cacheName:@"Root"];
//    aFetchedResultsController.delegate = self;
//    self.fetchedResultsController = aFetchedResultsController;
// 
//    
//    NSError *error = nil;
//    if (![_fetchedResultsController performFetch:&error]) {
//        /*
//         Replace this implementation with code to handle the error appropriately.
//         
//         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
//         */
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    
//	
//	//myCampaigns = [fetchedResultsController_ fetchedObjects];
//    return _fetchedResultsController;
//}


#pragma mark -
#pragma mark Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(DataTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
