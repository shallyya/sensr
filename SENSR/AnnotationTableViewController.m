//
//  ReportTableViewController.m
//  SENSR
//
//  Created by Sunyoung Kim on 8/9/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import "AnnotationTableViewController.h"
#import "DataImageViewController.h"

@interface AnnotationTableViewController ()

@end

@implementation AnnotationTableViewController

@synthesize backButton;
@synthesize project;
@synthesize temp;
@synthesize numTab2, numTab3, numTextfield, numTabs;
@synthesize dataToUpload;
@synthesize currentLocation;
@synthesize dataImage;
@synthesize labelsArray;
@synthesize data;
@synthesize annotationData;
@synthesize annotation;

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
    project = annotation.project;
    isPhotoUsed = project.usePhoto;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender{
   [self dismissViewControllerAnimated:YES completion:nil];
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
            textLabel.text = annotation.title;//[formatter stringFromDate:data.timestamp];
            break;
        case 7:
            fieldName = @"Latitude";
            textLabel.text = [NSString stringWithFormat:@"%0.4f", annotation.coordinate.latitude];
            break;
        case 8:
            fieldName = @"Longitude";
            textLabel.text = [NSString stringWithFormat:@"%0.4f", annotation.coordinate.longitude];
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
    NSString *label = [[project.labelsForTextfield componentsSeparatedByString:@"/"] objectAtIndex:numTextfield];

    aCell.textLabel.text = label;
    aCell.textLabel.textColor = [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0];
    aCell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:frame];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:17.0];
    
    if ([label rangeOfString:@"email"].location != NSNotFound || [label rangeOfString:@"Email"].location != NSNotFound) {
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"-/:;()$&\".,?!\'[]{}#%^*+=_|~<>€£¥•."];
        NSString *s = [[aCell.textLabel.text componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
        NSArray *emails = [[annotation.dataDictionary objectForKey:s] componentsSeparatedByString: @"@"];
        NSString *eid = [@"" stringByPaddingToLength:[[emails objectAtIndex: 0] length] withString: @"*" startingAtIndex:0];
        NSString *address = [emails objectAtIndex:1];
        NSString *email = [NSString stringWithFormat:@"%@@%@", eid, address];
        textLabel.text = email;
    }else{
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"-/:;()$&@\".,?!\'[]{}#%^*+=_|~<>€£¥•."];
        NSString *s = [[aCell.textLabel.text componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
        textLabel.text = [annotation.dataDictionary objectForKey:s];
    }
    
    [aCell addSubview:textLabel];

    numTextfield +=1;
}

- (void)addSegmentedControlWithSection:(int)row withCell:(UITableViewCell*)aCell withNum:(int)num{
    NSString *labels = (num==2)?project.labelsForTab2:project.labelsForTab3;
    int n = (num==2)?numTab2:numTab3;
    
    CGRect frame = CGRectMake(kLeftMargin, 4, kTextFieldWidth, kTextFieldHeight);
	NSMutableArray *tabNames = (NSMutableArray*)[[[[[labels componentsSeparatedByString:@"/"] objectAtIndex:n] componentsSeparatedByString:@":"] objectAtIndex:1] componentsSeparatedByString:@","];
    [tabNames removeLastObject];
    
    aCell.textLabel.text = [[[[labels componentsSeparatedByString:@"/"] objectAtIndex:n] componentsSeparatedByString:@":"] objectAtIndex:0];
    aCell.textLabel.textColor = [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0];
    aCell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:frame];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:17.0];
    textLabel.text = [annotation.dataDictionary objectForKey:aCell.textLabel.text];
    
    [aCell addSubview:textLabel];

    numTabs += 1;
    if(num==2)
        numTab2+=1;
    if(num==3)
        numTab3+=1;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return (!isPhotoUsed)?1:2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray * allKeys = [annotation.dataDictionary allKeys];
    NSInteger rows = [allKeys count] + 3;
    
	if(isPhotoUsed){
		switch (section) {
			case PHOTO_SECTION:
				rows = 1;
				break;
			default:
				break;
		}
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
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
#pragma mark Camera actions

- (void)showPhotoSectionWithCell:(UITableViewCell*)aCell{
    
    UIImage *image = nil;
    NSString *urlString = [NSString stringWithFormat:@"http://www.sensr.org/app/uploaded/%@.jpg",annotation.imageName];
    NSData *d = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    image = [UIImage imageWithData:d];
    
    photoViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoViewButton setFrame:CGRectMake(40, 10, 90, 90)];
    [photoViewButton setBackgroundImage:image forState:UIControlStateNormal];
    [photoViewButton setUserInteractionEnabled:YES];
    [photoViewButton addTarget:self action:@selector(showImage) forControlEvents:UIControlEventTouchUpInside];
    [aCell addSubview:photoViewButton];
    
    UIButton *pButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pButton setTitle:@"Show Image" forState:UIControlStateNormal];
    [pButton setFrame:CGRectMake(170, 35, 120, 40)];
    [pButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [pButton setUserInteractionEnabled:YES];
    [pButton addTarget:self action:@selector(showImage) forControlEvents:UIControlEventTouchUpInside];
    [aCell addSubview:pButton];
    
    image = [UIImage imageNamed:@"no_photo.png"];
    
}

- (void)showImage{
    [self performSegueWithIdentifier:@"ShowAnnotationImage" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowAnnotationImage"]) {
        
        NSString *urlString = [NSString stringWithFormat:@"http://www.sensr.org/app/uploaded/%@",annotation.imageName];
        NSData *d = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        UIImage *image = [UIImage imageWithData:d];
        
        DataImageViewController *projectViewController = segue.destinationViewController;
        projectViewController.image = image;
    }
}
@end
