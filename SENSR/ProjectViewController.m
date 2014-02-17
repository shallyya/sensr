//
//  ProjectViewController.m
//  SENSR
//
//  Created by Sunyoung Kim on 8/5/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import "ProjectViewController.h"
#import "Project.h"
#import "SENSRAppDelegate.h"
#import "Reachability.h"

@interface ProjectViewController ()

@end

@implementation ProjectViewController

@synthesize managedObjectContext, fetchedResultsController = _fetchedResultsController;
@synthesize project;

@synthesize projectDictionary;
@synthesize logoImageView;
@synthesize titleLabel;
@synthesize contactLabel;
@synthesize keywordsLabel;
@synthesize locationLabel;
@synthesize description;
@synthesize url;
@synthesize participateButton;
@synthesize isMyproject;
@synthesize toolBar;
@synthesize scrollView;


static NSString *ADD_PARTICIPANT_URL = @"http://www.sensr.org/app/addParticipant.php";

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
	// Do any additional setup after loading the view.
    
    SENSRAppDelegate *appDelegate = (SENSRAppDelegate *)[[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Project" inManagedObjectContext:managedObjectContext];
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
    
    isMyproject = (project!=nil)?YES:NO;
    
    [self displayView:isMyproject];
}

- (void)viewWillAppear:(BOOL)animated{
    //toolBar = [[UIToolbar alloc] init];
    [toolBar setFrame:CGRectMake(0, 410, 320, 70)];
    [toolBar setBarStyle:UIBarStyleBlack];
    toolBar.translucent = YES;
    
    
//    const float colorMask[6] = {222, 255, 222, 255, 222, 255};
//    UIImage *img = [[UIImage alloc] init];
//    UIImage *maskedImage = [UIImage imageWithCGImage: CGImageCreateWithMaskingColors(img.CGImage, colorMask)];
//    
//    [toolBar setBackgroundImage:maskedImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
//    toolBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    UIButton* button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(participateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *buttonImage = [UIImage imageNamed:@"blueButton.png"];
    UIImage *stretchedBackground = [buttonImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [button setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
    [button setTitle:@"Participate it!" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    button.frame = CGRectMake(115, 10, 199,50);
    [toolBar addSubview:button];
}

//- (void)serializeProject{
//    projectDictionary = [[NSMutableDictionary alloc] init];
//    [projectDictionary setObject:project.title forKey:@"title"];
//    [projectDictionary setObject:project.email forKey:@"email"];
//    [projectDictionary setObject:project.keywords forKey:@"keywords"];
//    [projectDictionary setObject:project.url forKey:@"url"];
//    [projectDictionary setObject:project.campaignDescription forKey:@"campaignDescription"];
//    
//}

- (void) displayView:(BOOL)value{
    if(isMyproject){
        [toolBar setHidden:YES];
        self.title = project.title;
        titleLabel.text = project.title;
        contactLabel.text = project.email;
        keywordsLabel.text = project.keywords;
        locationLabel.text = ([project.location isEqualToString:@""])?@"Nationwide":project.location;
        [url setTitle:project.url forState: UIControlStateNormal];
        logoImageView.image = project.logoImage;
    }else{
        self.title = [projectDictionary objectForKey:@"title"];
        titleLabel.text = [projectDictionary objectForKey:@"title"];
        contactLabel.text = [projectDictionary objectForKey:@"email"];
        keywordsLabel.text = [projectDictionary objectForKey:@"keywords"];
        locationLabel.text = ([[projectDictionary objectForKey:@"state"] isEqualToString:@""])?@"Nationwide":[projectDictionary objectForKey:@"state"];
        [url setTitle:[projectDictionary objectForKey:@"url"] forState: UIControlStateNormal];
        
        [description setText:[projectDictionary objectForKey:@"campaignDescription"]];
        
        NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.sensr.org/%@", [projectDictionary objectForKey:@"logoPath"]]];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        logoImageView.image = image;
        
        CGRect rect      = description.frame;
        rect.size.height = description.contentSize.height;
        description.frame   = rect;

        
        [scrollView setContentSize:(CGSizeMake(320, 300+rect.size.height))];
    }
    
    NSArray *t = [[projectDictionary objectForKey:@"location"] componentsSeparatedByString:@","] ;
    NSMutableArray *m = [[NSMutableArray alloc] init];
    for(id object in t){
        NSString *s = [object  stringByReplacingOccurrencesOfString:@"(" withString:@""];
        s = [s  stringByReplacingOccurrencesOfString:@")" withString:@""];
        [m addObject:s];
    }
}

- (IBAction) participateButtonPressed:(id)sender{
    NSString *newId = [projectDictionary objectForKey:@"uniqueID"];
 
    NSArray *fetchedData = [_fetchedResultsController fetchedObjects];
    BOOL isNewProject = YES;
    
    for(int i=0;i<[fetchedData count];i++){
        Project *p = [fetchedData objectAtIndex:i];
        
        NSString *oldId = p.uniqueID;
        
        if([oldId isEqualToString:newId])
            isNewProject = NO;
    }
    
    if(isNewProject){
        NSURL *add_p_url = [NSURL URLWithString: ADD_PARTICIPANT_URL];
        NSString *post = [NSString stringWithFormat:@"uniqueID=%@", newId];
        NSData *postData= [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d",[post length]];
        
        if([self checkInternet]){
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:add_p_url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            
            [request setURL:add_p_url];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            NSData *serverReply = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString *replyString = [[NSString alloc] initWithBytes:[serverReply bytes] length:[serverReply length] encoding: NSUTF8StringEncoding];
            NSLog(@"%@",replyString);
        }
        
        
        [self showAlert:@"confirm"];
    }else{
        [self showAlert:@"duplicate"];
    }
}

- (void)showAlert:(NSString*)notice{
	NSString *title = nil;
	NSString *message = nil;
	NSString *cancel = nil;
    NSString *other = nil;
	if ([notice isEqualToString:@"duplicate"]) {
		title = nil;
		message = @"You are already participating in this project.";
        cancel = @"Close";
        other = nil;
	}else if ([notice isEqualToString:@"confirm"]){
		title = nil;
		message = @"Do you want to participate in this project?";
        cancel = @"No";
        other = @"Yes, I do!";
	}else if (([notice isEqualToString:@"added"])){
		title = nil;
		message = @"Thank you for participating! This project is now added to your list.";
        cancel = @"Close";
        other =nil;
    }
	
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:title
						  message:message
						  delegate:self
						  cancelButtonTitle:cancel
						  otherButtonTitles:other,nil];
	[alert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
//        [self dismissViewControllerAnimated:YES completion:^{
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }];
        [self.navigationController popToRootViewControllerAnimated:YES];
        //[self.navigationController popViewControllerAnimated:YES];
    }else if(buttonIndex == 1){
        [self saveProject];
    }
}

- (void)saveProject{
    NSManagedObjectContext *context = [self managedObjectContext];
    Project *newProject = [NSEntityDescription
                        insertNewObjectForEntityForName:@"Project"
                        inManagedObjectContext:context];
    
    NSString *labelsForTextfield = [[projectDictionary objectForKey:@"labelsForTextfield"] stringByReplacingOccurrencesOfString:@"?" withString:@""];
    NSString *labelsForTab2 = [[projectDictionary objectForKey:@"labelsForTab2"] stringByReplacingOccurrencesOfString:@"?" withString:@""];
    NSString *labelsForTab3 = [[projectDictionary objectForKey:@"labelsForTab3"] stringByReplacingOccurrencesOfString:@"?" withString:@""];
    
    NSNumber *expirationDate =[ NSNumber numberWithInt:[[projectDictionary objectForKey:@"expirationDate"] intValue]];
    NSNumber *numTab2 = [ NSNumber numberWithInt:[[projectDictionary objectForKey:@"numTab2"] intValue]];
    NSNumber *numTab3 = [ NSNumber numberWithInt:[[projectDictionary objectForKey:@"numTab3"] intValue]];
    NSNumber *numTextfield = [ NSNumber numberWithInt:[[projectDictionary objectForKey:@"numTextfield"] intValue]];
    BOOL filtering = ([[projectDictionary objectForKey:@"filtering"] isEqualToString:@"NO"])?NO:YES;
    BOOL usePhoto = ([[projectDictionary objectForKey:@"usePhoto"] isEqualToString:@"no"])?NO:YES;

    [newProject setValue:[projectDictionary objectForKey:@"author"] forKey:@"author"];
    [newProject setValue:[projectDictionary objectForKey:@"campaignDescription"] forKey:@"campaignDescription"];
    [newProject setValue:[projectDictionary objectForKey:@"category"] forKey:@"category"];
    [newProject setValue:[projectDictionary objectForKey:@"email"] forKey:@"email"];
    [newProject setValue:[projectDictionary objectForKey:@"iconPath"] forKey:@"iconPath"];
    [newProject setValue:[projectDictionary objectForKey:@"itemsOrder"] forKey:@"itemsOrder"];
    [newProject setValue:[projectDictionary objectForKey:@"keywords"] forKey:@"keywords"];
    [newProject setValue:[projectDictionary objectForKey:@"labelForSubmitBtn"] forKey:@"labelForSubmitBtn"];
    [newProject setValue:labelsForTab2 forKey:@"labelsForTab2"];
    [newProject setValue:labelsForTab3 forKey:@"labelsForTab3"];
    [newProject setValue:labelsForTextfield forKey:@"labelsForTextfield"];
    [newProject setValue:[projectDictionary objectForKey:@"state"] forKey:@"location"];
    [newProject setValue:[projectDictionary objectForKey:@"logoPath"] forKey:@"logoPath"];
    [newProject setValue:[projectDictionary objectForKey:@"uniqueID"] forKey:@"uniqueID"];
    [newProject setValue:[projectDictionary objectForKey:@"url"] forKey:@"url"];
    [newProject setValue:[projectDictionary objectForKey:@"state"] forKey:@"state"];
    [newProject setValue:[projectDictionary objectForKey:@"title"] forKey:@"title"];
    [newProject setValue:[NSNumber numberWithBool:filtering] forKey:@"filtering"];
    [newProject setValue:[NSNumber numberWithBool:usePhoto] forKey:@"usePhoto"];
    [newProject setValue: expirationDate forKey:@"expirationDate"];
    [newProject setValue: numTab2 forKey:@"numTab2"];
    [newProject setValue: numTab3 forKey:@"numTab3"];
    [newProject setValue:numTextfield forKey:@"numTextfield"];
    [newProject setValue: [NSDate date] forKey:@"timestamp"];
    
    NSURL * logoImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.sensr.org/%@",[projectDictionary valueForKey:@"logoPath"]]];
	NSData * logoImageData = [NSData dataWithContentsOfURL:logoImageURL];
	UIImage * logoImage = [UIImage imageWithData:logoImageData];
	[newProject setValue:logoImage forKey:@"logoImage"];

    NSURL * iconImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.sensr.org/%@",[projectDictionary valueForKey:@"iconPath"]]];
	NSData * iconImageData = [NSData dataWithContentsOfURL:iconImageURL];
	UIImage * iconImage = [UIImage imageWithData:iconImageData];
	[newProject setValue:iconImage forKey:@"iconImage"];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    [self showAlert:@"added"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Check Connectivity

- (BOOL)checkInternet{
    Reachability *r = [Reachability reachabilityWithHostname:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    
    BOOL internet;
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
        internet = NO;
    else
        internet = YES;
    
    return internet;
}

#pragma mark -

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Project" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"timestamp" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

@end
