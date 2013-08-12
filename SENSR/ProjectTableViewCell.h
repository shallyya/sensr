//
//  ProjectTableViewCell.h
//  SENSR
//
//  Created by Sunyoung Kim on 8/5/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"

@interface ProjectTableViewCell : UITableViewCell{
    UIImageView *imageView;
    UILabel *nameLabel;
    
    Project *project;
}

@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;

@end
