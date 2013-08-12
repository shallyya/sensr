//
//  DataDetailViewController.m
//  StreamEyes
//
//  Created by Sunyoung Kim on 7/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Data.h"

@interface DataTableViewCell : UITableViewCell {
    
    Data *data;
    UIImageView     *imageView;
    UIImageView     *flagImage;
	//UIButton        *flagImage;
	
	UILabel *titleLabel;
	UILabel *dateLabel;
	NSString *caller;
}

@property (nonatomic, retain) NSString *caller;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *dateLabel;

@property (nonatomic, retain) Data *data;

@property (nonatomic, retain) UIImageView   *imageView;
@property (nonatomic, retain) UIImageView   *flagImage;
//@property (nonatomic, retain) UIButton      *flagImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCaller:(NSString*)aCaller;

@end
