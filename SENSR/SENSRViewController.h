//
//  SENSRViewController.h
//  SENSR
//
//  Created by Sunyoung Kim on 8/5/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface SENSRViewController : UIViewController <UIScrollViewDelegate> {
    NSArray *keywords;
    NSArray *featuredProjects;
    NSArray *recentProjects;
    
    UIScrollView *featuredProjectView;
    UIPageControl *pageControl;
    UIView *keywordView;
    UIView *recentProjectView;
    
    UIActivityIndicatorView *featuredProjectIndicator;
    UIActivityIndicatorView *keywordIndicator;
    UIActivityIndicatorView *recentProjectIndicator;
    
    Reachability *connection;
}

@property (nonatomic, retain) NSArray *keywords;
@property (nonatomic, retain) NSArray *featuredProjects;
@property (nonatomic, retain) NSArray *recentProjects;

@property (nonatomic, retain) IBOutlet UIScrollView *featuredProjectView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UIView *keywordView;
@property (nonatomic, retain) IBOutlet UIView *recentProjectView;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *featuredProjectIndicator;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *keywordIndicator;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *recentProjectIndicator;

@property (nonatomic, retain) Reachability *connection;

- (void)fetchProjects;
- (void)fetchKeywords;
- (void)fetchRecentProjects;

- (void)keywordPressed:(id)sender;
- (void)recentProjectPressed:(id)sender;
- (void)checkConnection;

@end
