//
//  ProjectListTableViewController.m
//  Sensr
//
//  Created by Sunyoung Kim on 8/5/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import "ProjectListTableViewController.h"
#import "ProjectViewController.h"
#import "ProjectTableViewCell.h"

@interface ProjectListTableViewController ()

@end

@implementation ProjectListTableViewController

@synthesize category;
@synthesize keyword;
@synthesize projects;

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
    self.title = (category!=nil)?category:keyword;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self fetchProjectsWithcategory:category WithKeyword:keyword];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - call JSON

- (void)fetchProjectsWithcategory:(NSString*)c WithKeyword:(NSString*)k{
    NSString *url;
    if(c!=nil){
        url = [NSString stringWithFormat:@"http://www.sensr.org/json/jsonCallProjects.php?category=%@", c];
    }else if(k!=nil){
        url = [NSString stringWithFormat:@"http://www.sensr.org/json/jsonCallProjects.php?keyword=%@", k];
        
    }
    
    if(projects != nil) projects = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString: url]];
        
        NSError* error;
        
        projects = [NSJSONSerialization JSONObjectWithData:data
                                                   options:kNilOptions
                                                     error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark - passing data to next page
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ProjectFromList"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ProjectViewController *projectViewController = segue.destinationViewController;
        projectViewController.projectDictionary = [projects objectAtIndex:indexPath.row];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return projects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Dequeue or if necessary create a RecipeTableViewCell, then set its recipe to the recipe for the current row.
    static NSString *CellIdentifier = @"ProjectCell";
    
 //   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    NSDictionary *project = [projects objectAtIndex:indexPath.row];
//    NSString *c = [project objectForKey:@"title"];
//    cell.textLabel.text = c;
//    
//    return cell;

    ProjectTableViewCell *projectCell = (ProjectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (projectCell == nil) {
        projectCell = [[ProjectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		projectCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
	[self configureCell:projectCell atIndexPath:indexPath];
    
    return projectCell;
}


- (void)configureCell:(ProjectTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell
    NSDictionary *project = [projects objectAtIndex:indexPath.row];
    NSString *c = [project objectForKey:@"title"];
    
    cell.nameLabel.text = c;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *iconURL = [NSString stringWithFormat:@"http://www.sensr.org/%@", [project objectForKey:@"iconPath"]];
        
        NSData   *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:iconURL]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            cell.imageView.image = [UIImage imageWithData:data];
        });
    });
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
