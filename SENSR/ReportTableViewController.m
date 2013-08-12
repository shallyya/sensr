//
//  ReportTableViewController.m
//  SENSR
//
//  Created by Sunyoung Kim on 8/9/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import "ReportTableViewController.h"
#import "Reachability.h"
#import "SENSRAppDelegate.h"
#import "DataImageViewController.h"

@interface ReportTableViewController ()

@end

@implementation ReportTableViewController

@synthesize cancelButton;
@synthesize project;
@synthesize temp;
@synthesize isPhotoUsed, isPhotoLoaded;
@synthesize photoViewButton, footerButton;
@synthesize numTab2, numTab3, numTextfield, numTabs;
@synthesize dataToUpload;
@synthesize maskView;
@synthesize currentLocation;
@synthesize dataImage;
@synthesize labelsArray;
@synthesize managedObjectContext;
@synthesize loadingLabel, activityIndicator;
@synthesize data;
@synthesize isMyData;
@synthesize annotationData;
@synthesize activeField;
@synthesize centerY;

#define PHOTO_SECTION    0
#define DATA_SECTION     1

#define PHOTO 0
#define DATALABLE 1
#define TEXTFIELD 2
#define TAB2 3
#define TAB3 4
#define SUBMITBTN 5
#define TIME 6
#define LATITUTE 7
#define LONGITUDE 8

#define kTextFieldWidth	        190.0
#define kTextFieldHeight		30.0
#define kLeftMargin				115.0
#define kNumberFieldWidth	    70.0

#define originX 160
#define originY 208

static NSString *SAVE_IMAGE_URL = @"http://www.sensr.org/app/saveImage.php";
static NSString *SAVE_DATA_URL = @"http://www.sensr.org/app/saveData.php";

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
    
    SENSRAppDelegate *appDelegate = (SENSRAppDelegate *)[[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    if(isMyData) {
        project = data.project;
        cancelButton.titleLabel.text = @"Back";
        self.title = project.title;
    }
    isPhotoUsed = project.usePhoto;
    isPhotoLoaded = NO;
    
    numTab2 = 0;
    numTab3 = 0;
    numTabs = 0;
    numTextfield = 0;
    
    dataToUpload = [[NSMutableArray alloc] init];
    labelsArray = [[NSMutableArray alloc] init];
    
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 800)];
	maskView.backgroundColor = [UIColor blackColor];
	maskView.alpha = 0.75f;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
   
    BOOL myDataUploaded = [data.isDataUploaded intValue];

    if(!isMyData)
        [self setFooterView];
    else{
        if([self checkInternet] && !myDataUploaded)
            [self setFooterView];
    }
    
    [self registerForKeyboardNotifications] ;
    
    centerY = self.view.center.y;
}

-(void)viewWillAppear:(BOOL)animated{
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(id)sender{
    if(isMyData)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}


// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    CGPoint rootViewPoint = [[activeField superview] convertPoint:activeField.frame.origin toView:nil];
    
    if (rootViewPoint.y > 180) {
        centerY -= (rootViewPoint.y - 180);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        self.view.center = CGPointMake(originX, centerY);
        [UIView commitAnimations];
    }}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    activeField = nil;
    centerY = originY;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.center = CGPointMake(originX, originY);
    [UIView commitAnimations];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
}


#pragma mark -
#pragma mark Data Fields


- (void)addExtraTextFieldWithSection:(int)row withCell:(UITableViewCell *)aCell withField:(int)aField{
    CGRect frame = CGRectMake(kLeftMargin, 4, kTextFieldWidth, kTextFieldHeight);
    NSString *fieldName = nil;
    UILabel *textLabel = [[UILabel alloc] initWithFrame:frame];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:17.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"Y/M/dd HH:mm"];
    
    switch(aField){
        case 6:
            fieldName = @"Timestamp";
            textLabel.text = [formatter stringFromDate:data.timestamp];
            break;
        case 7:
            fieldName = @"Latitude";
            textLabel.text = [NSString stringWithFormat:@"%@", data.latitude];
            break;
        case 8:
            fieldName = @"Longitude";
            textLabel.text = [NSString stringWithFormat:@"%@", data.longitude];
            break;
        default:
            break;
            
    }
    aCell.textLabel.text = fieldName;
    aCell.textLabel.textColor = [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0];
    aCell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [aCell addSubview:textLabel];
}

- (void)addTextFieldWithSection:(int)row withCell:(UITableViewCell *)aCell{
    
	CGRect frame = CGRectMake(kLeftMargin, 4, kTextFieldWidth, kTextFieldHeight);
    aCell.textLabel.text = [[project.labelsForTextfield componentsSeparatedByString:@"/"] objectAtIndex:numTextfield];
    aCell.textLabel.textColor = [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0];
    aCell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    
    if(isMyData){
        UILabel *textLabel = [[UILabel alloc] initWithFrame:frame];
        textLabel.textColor = [UIColor blackColor];
        textLabel.font = [UIFont systemFontOfSize:17.0];
        textLabel.text = [[data.textFieldData componentsSeparatedByString:@"/"] objectAtIndex:numTextfield];
        
        [aCell addSubview:textLabel];
    }else{
        UITextField *textField = [[UITextField alloc] initWithFrame:frame];
	
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.textColor = [UIColor blackColor];
        textField.font = [UIFont systemFontOfSize:17.0];
        textField.backgroundColor = [UIColor whiteColor];
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        textField.returnKeyType = UIReturnKeyDone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.delegate = self;
        textField.tag = row+1;
    
        [aCell addSubview:textField];
        [labelsArray addObject:[aCell.textLabel.text stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    
        [textField addTarget:self action:@selector(handleTouchValueChanged:forEvent:) forControlEvents:UIControlEventEditingChanged];
        [dataToUpload addObject:@""];
    }
    numTextfield +=1;
}

- (void)addSegmentedControlWithSection:(int)row withCell:(UITableViewCell*)aCell withNum:(int)num{
    NSString *labels = (num==2)?project.labelsForTab2:project.labelsForTab3;
    int n = (num==2)?numTab2:numTab3;
    
    CGRect frame = CGRectMake(kLeftMargin, 4, kTextFieldWidth, kTextFieldHeight);
	NSMutableArray *tabNames = (NSMutableArray*)[[[[[labels componentsSeparatedByString:@"/"] objectAtIndex:n] componentsSeparatedByString:@":"] objectAtIndex:1] componentsSeparatedByString:@","]; 
    [tabNames removeLastObject];
    
    UIFont *Boldfont = [UIFont boldSystemFontOfSize:15.0f];
    aCell.textLabel.text = [[[[labels componentsSeparatedByString:@"/"] objectAtIndex:n] componentsSeparatedByString:@":"] objectAtIndex:0];
    aCell.textLabel.textColor = [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0];
    aCell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    
    if(isMyData){
        UILabel *textLabel = [[UILabel alloc] initWithFrame:frame];
        textLabel.textColor = [UIColor blackColor];
        textLabel.font = [UIFont systemFontOfSize:17.0];
        textLabel.text = [[data.tabData componentsSeparatedByString:@"/"] objectAtIndex:numTabs];
        
        [aCell addSubview:textLabel];
    }else{
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:tabNames];
        [segmentedControl setSelectedSegmentIndex:-1];
        segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;// Plain;
        segmentedControl.frame = CGRectMake(115, 4, 193, 30);
        segmentedControl.tag = row+1;
    
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:Boldfont forKey:UITextAttributeFont];
        [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
        [aCell addSubview:segmentedControl];
        [labelsArray addObject:[aCell.textLabel.text stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
	
        [segmentedControl addTarget:self action:@selector(handleTouchValueChanged:forEvent:) forControlEvents:UIControlEventValueChanged];
        [dataToUpload addObject:@""];
    }
    numTabs += 1;
    if(num==2)
        numTab2+=1;
    if(num==3)
        numTab3+=1;
}

- (void)handleTouchValueChanged:(id)sender forEvent:(UIEvent *)event{
    NSString *itemClass = [NSString stringWithFormat:@"%@", [sender class]];
    if([itemClass isEqualToString:@"UITextField"]){
        NSString *t = ([[sender text] isEqualToString:@""])?[sender text]:[NSString stringWithFormat:@"textField:%@",[sender text]];
        [dataToUpload setObject:t atIndexedSubscript:([sender tag]-1)];
    }else if([itemClass isEqualToString:@"UISegmentedControl"]){
        NSString *t = [NSString stringWithFormat:@"tab:%@", [sender titleForSegmentAtIndex:[sender selectedSegmentIndex]]];
        [dataToUpload setObject:t atIndexedSubscript:([sender tag]-1)];
    }
    
	BOOL isDataEntered = ![dataToUpload containsObject:@""];
	BOOL isReady = isPhotoUsed?(isDataEntered && isPhotoLoaded):isDataEntered;
    
	if(isReady){
		UIImage *image = [[UIImage imageNamed:@"button_green.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:8];
        [footerButton setBackgroundImage:image forState:UIControlStateNormal];
    }else{
		UIImage *image = [[UIImage imageNamed:@"button_grey.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:8];
        [footerButton setBackgroundImage:image forState:UIControlStateNormal];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)setFooterView{
	UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(10, 3, 300, 44)];
	NSString *footerImageName = (isMyData)?@"button_green.png":@"button_grey.png";
    
	UIImage *image = [[UIImage imageNamed:footerImageName] stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    footerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[footerButton setBackgroundImage:image forState:UIControlStateNormal];
	[footerButton setFrame:CGRectMake(10, 3, 300, 44)];
	[footerButton setTitle:project.labelForSubmitBtn forState:UIControlStateNormal];
	[footerButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[footerButton addTarget:self action:@selector(saveData) forControlEvents:UIControlEventTouchUpInside];
    
	[footerView addSubview:footerButton];
    
	CGRect newFrame = CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, footerView.frame.size.height+5);
	footerView.frame = newFrame;
	self.tableView.tableFooterView = footerView;
}


#pragma mark -
#pragma mark Save Data

- (void)saveData{
	[self resignFirstResponder];
    
    BOOL isDataEntered = ![dataToUpload containsObject:@""];
    BOOL isReady = NO;
    if(isMyData)
        isReady = YES;
    else
        isReady = isPhotoUsed?(isDataEntered && isPhotoLoaded):isDataEntered;
    
    if(isReady){
        [self showSpinners];
        [self performSelector:@selector(saveImageAfterIndicator) withObject:nil afterDelay:0];
    }else{
        [self showAlert:@"noData"];
    }
}

- (void)saveImageAfterIndicator{
    if(isMyData){
        
        if([self uploadImage:data.imageName])
            NSLog(@"image saved");
            
        if([self sendDataToServer:data.postValue]){
            //[self showAlert:@"uploaded"];
        }else
            [self showAlert:@"error"];
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Data"];
        request.predicate = [NSPredicate predicateWithFormat:@"(uniqueID == %@) AND (timestamp ==%@)", data.uniqueID, data.timestamp]; // make is an attribute of the Car entity
        
        NSArray *fetchResults = [managedObjectContext executeFetchRequest:request error:nil];
        [fetchResults setValue:[NSNumber numberWithBool:YES] forKey:@"isDataUploaded"];
        
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }else{
        // convert array data to save
        NSString *textfieldDataString = @"";
        NSString *tabDataString = @"";
        
        id objectInstance;
        for (objectInstance in dataToUpload){
            NSString *class = [[objectInstance componentsSeparatedByString:@":"] objectAtIndex:0];
            NSString *value = [[objectInstance componentsSeparatedByString:@":"] objectAtIndex:1];
            
            if([class isEqualToString:@"textField"])
                textfieldDataString = [textfieldDataString stringByAppendingString:[NSString stringWithFormat:@"%@/",value]];
            else if([class isEqualToString:@"tab"])
                tabDataString = [tabDataString stringByAppendingString:[NSString stringWithFormat:@"%@/",value]];
        }
        
        NSMutableDictionary *dataToSave = [[NSMutableDictionary alloc] init];
        [dataToSave setValue:textfieldDataString forKey:@"textFieldData"];
        [dataToSave setValue:tabDataString forKey:@"tabData"];
        [dataToSave setValue:[NSNumber numberWithFloat:currentLocation.latitude] forKey:@"latitude"];
        [dataToSave setValue:[NSNumber numberWithFloat:currentLocation.longitude] forKey:@"longitude"];
        [dataToSave setObject:[NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];
        [dataToSave setObject:project.title forKey:@"title"];
        [dataToSave setObject:project.uniqueID forKey:@"uniqueID"];
        
        // create a post string to save
        NSString *imageName = [NSString stringWithFormat:@"%@_%@.jpg", project.uniqueID,[NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]]];
        NSString *post = [NSString stringWithFormat:@"uniqueID=%@&_reported_timestamp=%0.0f&_latitude=%f&_longitude=%f", project.uniqueID, [[NSDate date] timeIntervalSince1970], currentLocation.latitude, currentLocation.longitude];
        
        for(int i=0;i<[dataToUpload count];i++){
            NSString *key = [labelsArray objectAtIndex:i];
            NSString *val = [[[dataToUpload objectAtIndex:i] componentsSeparatedByString:@":"] objectAtIndex:1];
            post = [post stringByAppendingString:@"&"];
            post = [post stringByAppendingString:key];
            post = [post stringByAppendingString:@"_col='"];
            post = [post stringByAppendingString:val];
            post = [post stringByAppendingString:@"'"];
        }
        
        if(isPhotoUsed){
            post = [post stringByAppendingString:@"&_imageName='"];
            post = [post stringByAppendingString:imageName];
            post = [post stringByAppendingString:@"'"];
        }
        
        [dataToSave setValue:post  forKey:@"postValue"];
        // save data
        if([self checkInternet]){
            if(isPhotoUsed && isPhotoLoaded){
                
                [dataToSave setObject:dataImage forKey:@"dataImage"];
                [dataToSave setValue:imageName forKey:@"imageName"];
                if([self uploadImage:imageName])
                    NSLog(@"image saved");
            }
            
            [dataToSave setValue:[NSNumber numberWithBool:YES]  forKey:@"isDataUploaded"];
            if([self sendDataToServer:post]){
                //[self showAlert:@"uploaded"];
            }else
                [self showAlert:@"error"];
        }else{
            if(isPhotoUsed && isPhotoLoaded){
                NSString *imageName = [NSString stringWithFormat:@"%@@%@", [[[UIDevice currentDevice] identifierForVendor] UUIDString],[NSDate date]];
                [dataToSave setObject:dataImage forKey:@"dataImage"];
                [dataToSave setValue:[NSString stringWithFormat:@"'%@'", imageName] forKey:@"imageName"];
            }
            [dataToSave setValue:[NSNumber numberWithBool:NO]  forKey:@"isDataUploaded"];
            [self showAlert:@"savedLocally"];
        }
        
        [self insertDatToCore:dataToSave image:dataImage];
	}
}

- (void)insertDatToCore:(NSDictionary*)newData image:(UIImage*)image{
    NSEntityDescription *dataEntity = [NSEntityDescription entityForName:@"Data" inManagedObjectContext:managedObjectContext];
	NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[dataEntity name] inManagedObjectContext:managedObjectContext];
	
	[newManagedObject setValue:[newData valueForKey:@"isDataUploaded"] forKey:@"isDataUploaded"];
	[newManagedObject setValue:[newData valueForKey:@"latitude"] forKey:@"latitude"];
	[newManagedObject setValue:[newData valueForKey:@"longitude"] forKey:@"longitude"];
	[newManagedObject setValue:[newData valueForKey:@"tabData"] forKey:@"tabData"];
	[newManagedObject setValue:[newData valueForKey:@"textFieldData"] forKey:@"textFieldData"];
	[newManagedObject setValue:image forKey:@"dataImage"];
	[newManagedObject setValue:[newData valueForKey:@"title"] forKey:@"title"];
	[newManagedObject setValue:[newData valueForKey:@"uniqueID"] forKey:@"uniqueID"];
	[newManagedObject setValue:[newData valueForKey:@"imageName"] forKey:@"imageName"];
    [newManagedObject setValue:[newData valueForKey:@"postValue"] forKey:@"postValue"];
    [newManagedObject setValue:project forKey:@"project"];
    
    NSTimeInterval t =[[newData valueForKey:@"timestamp"] doubleValue];
    [newManagedObject setValue:[NSDate dateWithTimeIntervalSince1970:t]forKey:@"timestamp"];

	NSError *error = nil;
	if(![managedObjectContext save:&error]){
		NSLog(@"unresolved error %@ %@",error, [error userInfo]);
		abort();
	}
}

- (BOOL)uploadImage:(NSString*)imageName{
    BOOL isImageUploaded = NO;
    UIImage *image = dataImage;
    NSString *i = imageName;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSURL *imageUrl = [NSURL URLWithString:SAVE_IMAGE_URL];

    if([self checkInternet]){
        NSMutableURLRequest *imageRequest = [NSMutableURLRequest requestWithURL:imageUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
        [imageRequest setURL:imageUrl];
        [imageRequest setHTTPMethod:@"POST"];
    
        NSString *boundary = [NSString stringWithFormat:@"---------------------------%@",i];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [imageRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded\"; filename=\"%@\"\r\n", i] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

        [imageRequest setHTTPBody:body];
        [imageRequest addValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:imageRequest returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",returnString);
        isImageUploaded = YES;
    }else{
        NSLog(@"problem uploading image");
    }
	
	return isImageUploaded;
	
}

- (BOOL)sendDataToServer:(NSString*)p{
    BOOL isDataUploaded= NO;
    NSString *post = p;
    NSData *postData= [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[post length]];
    
    NSURL *url = [NSURL URLWithString: SAVE_DATA_URL];
    if([self checkInternet]){
    	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    	[request setURL:url];
    	[request setHTTPMethod:@"POST"];
    
    	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    	[request setHTTPBody:postData];
    	NSData *serverReply = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    	NSString *replyString = [[NSString alloc] initWithBytes:[serverReply bytes] length:[serverReply length] encoding: NSUTF8StringEncoding];
    	NSLog(@"%@", replyString);
    		
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(showAlertWithTimer:) userInfo:@"uploaded" repeats:NO];
    	isDataUploaded = YES;
    }
    
	return isDataUploaded;
}


-(void)hideSpinners{
	[loadingLabel removeFromSuperview];
	[maskView removeFromSuperview];
	[activityIndicator removeFromSuperview];
	[activityIndicator stopAnimating];
}


-(void)showSpinners{
    activityIndicator =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	CGFloat totalWidth = activityIndicator.frame.size.width;
	CGRect spinnerFrame = activityIndicator.frame;
	spinnerFrame.origin.x = (self.view.bounds.size.width - totalWidth) / 2.0;
	spinnerFrame.origin.y = (self.view.bounds.size.height - totalWidth) / 2.0;
	
	activityIndicator.frame = spinnerFrame;
	
    loadingLabel = [[UILabel alloc] init];
	loadingLabel.text = @"Uploading...";
	loadingLabel.backgroundColor = [UIColor clearColor];
	loadingLabel.textColor = [UIColor whiteColor];
	CGSize size = [loadingLabel.text sizeWithFont:[UIFont systemFontOfSize:15]];
	[loadingLabel setFrame:CGRectMake(spinnerFrame.origin.x - size.width/3, spinnerFrame.origin.y+totalWidth, 300, 40)];
	
	[self.tableView addSubview:maskView];
	[self.tableView addSubview:activityIndicator];
	[self.tableView addSubview:loadingLabel];
	
	[activityIndicator startAnimating];
}

- (void)showAlertWithTimer:(NSTimer*)userInfo{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Data Uploaded" message:@"Thank you for contributing!"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	
	[alertView show];
}

- (void)showAlert:(NSString*)condition{
	NSString *message = nil;
	NSString *alertTitle = nil;
	
	if([condition isEqualToString:@"uploaded"] ){
		alertTitle = @"Data Uploaded";
		message = @"Thank you for contributing!";
	}else if([condition isEqualToString:@"savedLocally"]){
		alertTitle = @"Data Saved Locally";
		message = @"You are not connected to the network or GPS. You will need to manually upload any data you capture offline when you re-connect.";
	}else if([condition isEqualToString:@"noData"]){
		alertTitle = @"Fill out fields";
		message= @"Please fill out all fields to report.";
	}else if([condition isEqualToString:@"error"]){
		alertTitle = @"Error!";
		message= @"Please try it later.";
	}
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	
	[alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (![alertView.title isEqualToString:@"Fill out fields"]) {
		[self hideSpinners];
        if(isMyData)
            [self.navigationController popViewControllerAnimated:YES];
        else
            [self dismissViewControllerAnimated:YES completion:nil];
	}
	
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return (!isPhotoUsed)?1:2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows=0;
	if(isPhotoUsed){
		switch (section) {
			case PHOTO_SECTION:
				rows = 1;
				break;
			case DATA_SECTION:
				rows = [project.numTab2 intValue]+[project.numTab3 intValue]+[project.numTextfield intValue];
                if(isMyData) rows += 3;
				break;
			default:
				break;
		}
	}else{
        rows = [project.numTab2 intValue]+[project.numTab3 intValue]+[project.numTextfield intValue];
        if(isMyData) rows += 3;
    }

	return rows;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat height = 0.0f;
	if(isPhotoUsed){
		if(indexPath.section == PHOTO_SECTION)
			height = 110.f;
		else if(indexPath.section == DATA_SECTION)
			height = 38.f;
		
	}else{
		height = 38.f;
	}
	
	return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DataCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
   
    NSMutableArray *itemsOrder = [NSMutableArray array];
    NSString *items = project.itemsOrder;
    items = [ items stringByAppendingString:@"678"];
    for (int i = 0; i < [items length]; i++) {
        NSString *item = [items substringWithRange:NSMakeRange(i, 1)];
        if(![item isEqualToString:@"1"] && ![item isEqualToString:@"0"] &&![item isEqualToString:@"5"])
            [itemsOrder addObject:item];
    }
    
	if(isPhotoUsed){
		if(indexPath.section == PHOTO_SECTION){
			if (cell == nil)
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [self showPhotoSectionWithCell:cell];
		}else if(indexPath.section == DATA_SECTION){
			if (cell == nil)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            int field = [[itemsOrder objectAtIndex:indexPath.row] intValue];
            switch (field) {
                case 2:
                    [self addTextFieldWithSection:indexPath.row withCell:cell];
                    break;
                case 3:
                    [self addSegmentedControlWithSection:indexPath.row withCell:cell withNum:2];
                    break;
                case 4:
                    [self addSegmentedControlWithSection:indexPath.row withCell:cell withNum:3];
                    break;
                case 6:
                case 7:
                case 8:
                    [self addExtraTextFieldWithSection:indexPath.row withCell:cell withField:field];
                    break;
                default:
                    break;
            }
		}
	}else {
		if (cell == nil)
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        int field = [[itemsOrder objectAtIndex:indexPath.row] intValue];
        switch (field) {
            case 2:
                [self addTextFieldWithSection:indexPath.row withCell:cell];
                break;
            case 3:
                [self addSegmentedControlWithSection:indexPath.row withCell:cell withNum:2];
                break;
            case 4:
                [self addSegmentedControlWithSection:indexPath.row withCell:cell withNum:3];
                break;
            case 6:
            case 7:
            case 8:
                [self addExtraTextFieldWithSection:indexPath.row withCell:cell withField:field];
                break;
            default:
                break;
        }
	}
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *headerTitle = nil;
    if(!isPhotoUsed)
            headerTitle = @"Data";
    else
        headerTitle = (section ==0)?@"Photo":@"Data";
    
    return headerTitle;
}

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
#pragma mark Camera actions

- (void)showPhotoSectionWithCell:(UITableViewCell*)aCell{
    
    UIImage *image = nil;
    
    photoViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoViewButton setFrame:CGRectMake(40, 10, 90, 90)];
    [photoViewButton setUserInteractionEnabled:YES];
    [aCell addSubview:photoViewButton];
    
    UIButton *pButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pButton setFrame:CGRectMake(170, 35, 120, 40)];
    [pButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [pButton setUserInteractionEnabled:YES];
    [aCell addSubview:pButton];
    
    if(isMyData){
        image = data.dataImage;
        
        [photoViewButton setBackgroundImage:image forState:UIControlStateNormal];
        [photoViewButton addTarget:self action:@selector(showImage) forControlEvents:UIControlEventTouchUpInside];
        
        [pButton setTitle:@"Show Image" forState:UIControlStateNormal];
        [pButton addTarget:self action:@selector(showImage) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        [pButton setTitle:@"Take Photo" forState:UIControlStateNormal];
        [pButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
        
        image = [UIImage imageNamed:@"no_photo.png"];
        [photoViewButton setBackgroundImage:image forState:UIControlStateNormal];
        [photoViewButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)showImage{
   [self performSegueWithIdentifier:@"ShowMyDataImage" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowMyDataImage"]) {
        DataImageViewController *projectViewController = segue.destinationViewController;
        projectViewController.image = data.dataImage;
    }
}

- (void)takePhoto{
    if(!isMyData){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        BOOL camAvail = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        picker.sourceType = (camAvail?UIImagePickerControllerSourceTypeCamera:UIImagePickerControllerSourceTypePhotoLibrary);
	
        [self presentViewController:picker animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage : (UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo{
	
	CGSize size = selectedImage.size;
	
	CGFloat ratio = 0;
	if (size.width > size.height)
		ratio = 300.0 / size.width;
	else
		ratio = 300.0 / size.height;
	
    CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
    UIGraphicsBeginImageContext(rect.size);
    [selectedImage drawInRect:rect];
    
    dataImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //
    //	CGSize tSize = selectedImage.size;
    //	CGFloat tRatio = 0;
    //	if (tSize.width > tSize.height)
    //		tRatio = 44.0 / tSize.width;
    //	else
    //		tRatio = 44.0 / tSize.height;
    //
    //	CGRect tRect = CGRectMake(0.0, 0.0, tRatio * tSize.width, tRatio * tSize.height);
    //
    //	UIGraphicsBeginImageContext(tRect.size);
    //	[selectedImage drawInRect:tRect];
    //
    //	if(dataThumbnailImage!=nil)
    //		dataThumbnailImage = nil;
    //
    //	dataThumbnailImage = [UIGraphicsGetImageFromCurrentImageContext() retain];
    //
    //	UIGraphicsEndImageContext();
    //
    [photoViewButton setBackgroundImage:selectedImage forState:UIControlStateNormal];
    isPhotoLoaded = YES;
    
    BOOL isDataEntered = ![dataToUpload containsObject:@""];
	BOOL isReady = isDataEntered && isPhotoLoaded;
    
	if(isReady){
		UIImage *image = [[UIImage imageNamed:@"button_green.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:8];
        [footerButton setBackgroundImage:image forState:UIControlStateNormal];
    }else{
		UIImage *image = [[UIImage imageNamed:@"button_grey.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:8];
        [footerButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    //
    //	[checkFields removeAllObjects];
    //	[labelsArray removeAllObjects];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
