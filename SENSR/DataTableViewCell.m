//
//  DataDetailViewController.m
//  StreamEyes
//
//  Created by Sunyoung Kim on 7/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataTableViewCell.h"
#import "Data.h"

#pragma mark -
#pragma mark SubviewFrames category

@interface DataTableViewCell (SubviewFrames)
- (CGRect)_imageViewFrame;
- (CGRect)_dateLabelFrame;
- (CGRect)_dateLabelFrameWithoutImage;
- (CGRect)_flageImageFrame;
- (CGRect)_campaignTitleLabelFrame;
- (CGRect)_campaignTitleLabelFrameWithoutImage;
- (CGRect)_subDateLabelFrame;
- (CGRect)_subDateLabelFrameWithoutImage;

@end




#pragma mark -
#pragma mark RecipeTableViewCell implementation

@implementation DataTableViewCell

@synthesize imageView, dateLabel, flagImage;
@synthesize data;
@synthesize titleLabel;//, dateLabel;
@synthesize caller;

static NSString *IMAGE_URL = @"http://www.sensr.org/syk/app/uploaded/";

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCaller:(NSString*)aCaller {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.caller = aCaller;
		if([caller isEqualToString:@"project"] || [caller isEqualToString:@"data"]){
			imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
			imageView.contentMode = UIViewContentModeScaleAspectFit;
			[self.contentView addSubview:imageView];
//            
//			dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//			[dateLabel setFont:[UIFont systemFontOfSize:18.0]];
//			[self.contentView addSubview:dateLabel];
            
			
			dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			[dateLabel setFont:[UIFont systemFontOfSize:12.0]];
			[dateLabel setTextColor:[UIColor darkGrayColor]];
			[dateLabel setHighlightedTextColor:[UIColor whiteColor]];
			[self.contentView addSubview:dateLabel];
			
			titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			[titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
			[titleLabel setTextColor:[UIColor blackColor]];
			[titleLabel setHighlightedTextColor:[UIColor whiteColor]];
			[self.contentView addSubview:titleLabel];
		}else if([caller isEqualToString:@"all"]){
			imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
			imageView.contentMode = UIViewContentModeScaleAspectFit;
			[self.contentView addSubview:imageView];
			
			dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			[dateLabel setFont:[UIFont systemFontOfSize:12.0]];
			[dateLabel setTextColor:[UIColor darkGrayColor]];
			[dateLabel setHighlightedTextColor:[UIColor whiteColor]];
			[self.contentView addSubview:dateLabel];
			
			titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			[titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
			[titleLabel setTextColor:[UIColor blackColor]];
			[titleLabel setHighlightedTextColor:[UIColor whiteColor]];
			[self.contentView addSubview:titleLabel];
		}else if([caller isEqualToString:@"projectList"]){
			imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
			imageView.contentMode = UIViewContentModeScaleAspectFit;
			[self.contentView addSubview:imageView];
			
			dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			[dateLabel setFont:[UIFont systemFontOfSize:18.0]];
			[self.contentView addSubview:dateLabel];
		}
        
		//flagImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"exclamation.png"]];
		//flagImage = [UIButton buttonWithType:UIButtonTypeInfoDark];
		//flagImage.frame = CGRectMake(282, 13, 20, 20);
        
		//flagImage.alpha = 0.0;
    }
    
    return self;
}


#pragma mark -
#pragma mark Laying out subviews


- (void)layoutSubviews {
    [super layoutSubviews];
	
	if([caller isEqualToString:@"project"] || [caller isEqualToString:@"data"]){
		if ([data valueForKey:@"imageName"] != nil) {
			[imageView setFrame:[self _imageViewFrame]];
			[dateLabel setFrame:[self _subDateLabelFrame]];
            [titleLabel setFrame:[self _campaignTitleLabelFrame ]];
		}else {
			[dateLabel setFrame:[self _subDateLabelFrameWithoutImage]];
            [titleLabel setFrame:[self _campaignTitleLabelFrameWithoutImage]];
		}
	}else if([caller isEqualToString:@"all"]){
		if ([data valueForKey:@"imageName"] != nil) {
			[imageView setFrame:[self _imageViewFrame]];
			[titleLabel setFrame:[self _campaignTitleLabelFrame]];
			[dateLabel setFrame:[self _subDateLabelFrame]];
		}else {
			[titleLabel setFrame:[self _campaignTitleLabelFrameWithoutImage]];
			[dateLabel setFrame:[self _subDateLabelFrameWithoutImage]];
		}
	}else if([caller isEqualToString:@"projectList"]){
		[imageView setFrame:[self _imageViewFrame]];
		[dateLabel setFrame:[self _dateLabelFrame]];
	}
}


#define IMAGE_SIZE          44.0
#define EDITING_INSET       10.0
#define TEXT_LEFT_MARGIN    8.0
#define TEXT_RIGHT_MARGIN   5.0
#define PREP_TIME_WIDTH     80.0

/*
 Return the frame of the various subviews -- these are dependent on the editing state of the cell.
 */
- (CGRect)_imageViewFrame {
    if (self.editing) {
        return CGRectMake(EDITING_INSET, 0.0, IMAGE_SIZE, IMAGE_SIZE);
    }
	else {
        return CGRectMake(0.0, 0.0, IMAGE_SIZE, IMAGE_SIZE);
    }
}

- (CGRect)_dateLabelFrame {
    if (self.editing) {
        return CGRectMake(IMAGE_SIZE + EDITING_INSET + TEXT_LEFT_MARGIN, 7.0, self.contentView.bounds.size.width - IMAGE_SIZE, 30.0);
    }
	else {
        return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN, 7.0, self.contentView.bounds.size.width - IMAGE_SIZE, 30.0);
    }
}

- (CGRect)_dateLabelFrameWithoutImage {
    if (self.editing) {
        return CGRectMake(EDITING_INSET + TEXT_LEFT_MARGIN, 7.0, self.contentView.bounds.size.width, 30.0);
    }
	else {
        return CGRectMake(TEXT_LEFT_MARGIN, 7.0, self.contentView.bounds.size.width, 30.0);
    }
}

- (CGRect)_campaignTitleLabelFrame {
    if (self.editing) {
        return CGRectMake(IMAGE_SIZE + EDITING_INSET + TEXT_LEFT_MARGIN, 4.0, self.contentView.bounds.size.width - IMAGE_SIZE - EDITING_INSET - TEXT_LEFT_MARGIN, 16.0);
    }
	else {
        return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN, 4.0, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_RIGHT_MARGIN * 2 - PREP_TIME_WIDTH, 16.0);
    }
}

- (CGRect)_campaignTitleLabelFrameWithoutImage {
    if (self.editing) {
        return CGRectMake(EDITING_INSET + TEXT_LEFT_MARGIN, 4.0, self.contentView.bounds.size.width - EDITING_INSET - TEXT_LEFT_MARGIN, 16.0);
    }
	else {
        return CGRectMake(TEXT_LEFT_MARGIN, 4.0, self.contentView.bounds.size.width - TEXT_RIGHT_MARGIN * 2 - PREP_TIME_WIDTH, 16.0);
    }
}


- (CGRect)_subDateLabelFrame {
    if (self.editing) {
        return CGRectMake(IMAGE_SIZE + EDITING_INSET + TEXT_LEFT_MARGIN, 22.0, self.contentView.bounds.size.width - IMAGE_SIZE - EDITING_INSET - TEXT_LEFT_MARGIN, 16.0);
    }
	else {
        return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN, 22.0, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_LEFT_MARGIN, 16.0);
    }
}

- (CGRect)_subDateLabelFrameWithoutImage {
    if (self.editing) {
        return CGRectMake(EDITING_INSET + TEXT_LEFT_MARGIN, 22.0, self.contentView.bounds.size.width - EDITING_INSET - TEXT_LEFT_MARGIN, 16.0);
    }
	else {
        return CGRectMake(TEXT_LEFT_MARGIN, 22.0, self.contentView.bounds.size.width - TEXT_LEFT_MARGIN, 16.0);
    }
}

- (CGRect)_flageImageFrame {
    CGRect contentViewBounds = self.contentView.bounds;
    return CGRectMake(contentViewBounds.size.width - TEXT_LEFT_MARGIN*4, 14.0, 20.0, 20.0);
}


#pragma mark -
#pragma mark  set accessor

- (void)setData:(Data*)newData {
    
    if (newData != data) {
        data = newData;
	}
    
	if([caller isEqualToString:@"projectList"]){
		imageView.image = [data valueForKey:@"logoImage"];
		dateLabel.text = [data valueForKey:@"title"];
	}else if([caller isEqualToString:@"project"]){
		if ([data valueForKey:@"imageName"] != nil) {
			NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,[data valueForKey:@"imageName"]]];
			
			NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
			imageView.image = [UIImage imageWithData:imageData];
		}
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"Y/M/dd HH:mm"];
		dateLabel.text = [formatter stringFromDate:data.timestamp];
        titleLabel.text = [data valueForKey:@"title"];
	}else if([caller isEqualToString:@"data"]){
		if ([data valueForKey:@"imageName"] != nil)
			imageView.image = [data valueForKey:@"dataImage"];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"Y/M/dd HH:mm"];
		
		dateLabel.text = [formatter stringFromDate:data.timestamp];
        titleLabel.text = [data valueForKey:@"title"];
		
	}
}


@end
