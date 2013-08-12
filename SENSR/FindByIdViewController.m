//
//  FindByIdViewController.m
//  SENSR
//
//  Created by Sunyoung Kim on 8/8/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import "FindByIdViewController.h"
#import "ProjectViewController.h"

@interface FindByIdViewController ()

@end

@implementation FindByIdViewController

@synthesize idField;
@synthesize findButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [idField becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [idField resignFirstResponder];
    
    /* textField here is referenced from
     textFieldShouldReturn:(UITextField *)textField
     */
    return YES;
}

- (IBAction) findButtonPressed:(id)sender{
    //[self performSegueWithIdentifier:@"ProjectFromFindProject" sender:idField.text];
    [self fetchProject:idField.text];
}

- (void)fetchProject:(NSString*) sender{
    NSString *uniqueID = sender;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.sensr.org/json/jsonCallFindProject.php?uniqueID=%@",uniqueID]];
    NSData* data = [NSData dataWithContentsOfURL:url];
    NSError* error;
    
    NSArray *resultArray = [NSJSONSerialization JSONObjectWithData:data
                                                     options:kNilOptions
                                                       error:&error];
    
    
    
    if([resultArray count] == 0){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:nil
                              message:@"The ID does not exist."
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }else{
        NSDictionary *p = [resultArray objectAtIndex:0];
        [self performSegueWithIdentifier:@"ProjectFromFindProject" sender:p];
    }
}

#pragma mark - passing data to next page
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ProjectFromFindProject"]) {
        ProjectViewController *projectViewController = segue.destinationViewController;
        projectViewController.projectDictionary = sender;
    }
}

@end
