//
//  ProjectTableViewCell.m
//  SENSR
//
//  Created by Sunyoung Kim on 8/5/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import "ProjectTableViewCell.h"
#import "Project.h"
@implementation ProjectTableViewCell

@synthesize imageView, nameLabel;
@synthesize project;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark Recipe set accessor

- (void)setProject:(Project *)newProject {
//    if (newProject != project) {
//        [project release];
//        project = [newProject retain];
//	}
	imageView.image = project.iconImage;
	nameLabel.text = project.title;

}

@end
