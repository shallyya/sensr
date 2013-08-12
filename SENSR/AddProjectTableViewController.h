//
//  AddProjectTableViewController.h
//  SENSR
//
//  Created by Sunyoung Kim on 8/7/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddProjectTableViewController : UITableViewController{
    NSArray *categories;
}

@property (nonatomic, retain) NSArray *categories;

- (IBAction)backAction:(id)sender;
- (void)fetchCategories;

@end
