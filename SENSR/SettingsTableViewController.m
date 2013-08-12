//
//  SettingsTableViewController.m
//  SENSR
//
//  Created by Sunyoung Kim on 8/12/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "AboutUsViewController.h"

@interface SettingsTableViewController ()

@end

#define USER_DATA 0
#define EXPOSE_DATA 1
#define ABOUT_US 2


#define kTextFieldWidth	        190.0
#define kTextFieldHeight		30.0
#define kLeftMargin				115.0
#define kNumberFieldWidth	    70.0

@implementation SettingsTableViewController

@synthesize prefs;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    prefs = [NSUserDefaults standardUserDefaults];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}

- (IBAction)switchChanged:(id)sender{
    UISwitch *onoff = (UISwitch *) sender;
    if(onoff.on)
        [prefs setBool:YES forKey:@"ExposeProfile"];
    else
        [prefs setBool:NO forKey:@"ExposeProfile"];
    
    [prefs synchronize];
}

#pragma mark - Table view data source


- (void)handleTouchValueChanged:(id)sender forEvent:(UIEvent *)event{
    NSString *key = ([sender tag]==0)?@"Name":(([sender tag]==1)?@"Email":@"Location");
    [prefs setObject:[sender text] forKey:key];
    [prefs synchronize];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;
    switch (section) {
        case ABOUT_US:
            rows = 1;
            break;
        case USER_DATA:
            rows = 3;
            break;
        case EXPOSE_DATA:
            rows = 2;
            break;
        default:
            break;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

	
	return 38.f;;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    if(section ==USER_DATA)
        sectionName = @"My Profile";
    
    return sectionName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == USER_DATA){ 
        cell.textLabel.textColor = [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 8, 185, 30)];
        textField.borderStyle = UITextBorderStyleNone;
        textField.textColor = [UIColor blackColor];
        textField.font = [UIFont systemFontOfSize:17.0];
        textField.backgroundColor = [UIColor clearColor];
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.returnKeyType = UIReturnKeyDone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.delegate = self;
        [textField addTarget:self action:@selector(handleTouchValueChanged:forEvent:) forControlEvents:UIControlEventEditingChanged];
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Name";
            textField.placeholder = @"Your name";
            textField.text = [prefs objectForKey:@"Name"];
            textField.tag = 0;
        }
        else if (indexPath.row == 1){
            cell.textLabel.text = @"Email";
            textField.placeholder = @"example@gmail.com";
            textField.text = [prefs objectForKey:@"Email"];
            textField.keyboardType = UIKeyboardTypeEmailAddress;
            textField.tag = 1;
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"Location";
            textField.text = [prefs objectForKey:@"Location"];
            textField.placeholder = @"The state you live";
            textField.tag = 2;
        }
        
        [cell addSubview:textField];
         // no auto correction support
        // no auto capitalization support
       // playerTextField.textAlignment = UITextAlignmentLeft;
        //playerTextField.tag = 0;
        //playerTextField.delegate = self;
        //[cell.contentView addSubview:playerTextField];
        
    }else if (indexPath.section == EXPOSE_DATA){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Expose my profile";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            [switchView setOn:[prefs boolForKey:@"ExposeProfile"] animated:NO];
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        }else if (indexPath.row == 1){
            [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.text = @"If \"Expose my profile\" is on, your profile information will be sent with the data when you report.";
        }
    }else if (indexPath.section == ABOUT_US){
        cell.textLabel.text = @"About us";
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
         cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if(indexPath.section == USER_DATA)
        return YES;
    return NO;
}

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
    
    if(indexPath.section == ABOUT_US)
       [self performSegueWithIdentifier:@"ShowAboutUs" sender:nil];
    else{
        
    }
   
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowAboutUs"]) {
        AboutUsViewController *projectViewController = segue.destinationViewController;
        projectViewController.hidesBottomBarWhenPushed = YES;
    }
    //if ([segue.identifier isEqualToString:@"ShowFindProject"]) {
    // FindByIdViewController *projectViewController = segue.destinationViewController;
    
    //}
    
}

@end
