//
//  ProjectListTableViewController.h
//  Sensr
//
//  Created by Sunyoung Kim on 8/5/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectListTableViewController : UITableViewController{
    NSString *category;
    NSString *keyword;
    
    NSArray *projects;
}

@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *keyword;
@property (nonatomic, retain) NSArray *projects;

- (void)fetchProjectsWithcategory:(NSString*)c WithKeyword:(NSString*)k;

@end
