//
//  CategoryTableViewController.h
//  Sensr
//
//  Created by Sunyoung Kim on 8/5/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewController : UITableViewController {
    UIBarButtonItem *backButton;
    NSArray *categories;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, retain) NSArray *categories;

- (void)fetchCategories;
- (IBAction)backAction:(id)sender;

@end
