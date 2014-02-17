//
//  SENSRViewController.m
//  SENSR
//
//  Created by Sunyoung Kim on 8/5/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import "SENSRViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ProjectListTableViewController.h"
#import "ProjectViewController.h"
#import "Reachability.h"

@interface SENSRViewController () <UIScrollViewDelegate>

@end

@implementation SENSRViewController

@synthesize keywords;
@synthesize featuredProjects;
@synthesize recentProjects;

@synthesize featuredProjectView;
@synthesize pageControl;
@synthesize keywordView;
@synthesize recentProjectView;

@synthesize featuredProjectIndicator, keywordIndicator, recentProjectIndicator;
@synthesize connection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkConnection];
}
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayView:(BOOL)connected{
    if(connected){
        [self fetchProjects];
        [self fetchKeywords];
        [self fetchRecentProjects];
    }else{
        [featuredProjectIndicator stopAnimating];
        [keywordIndicator stopAnimating];
        [recentProjectIndicator stopAnimating];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"No Internet Connection"
                              message:@"The Internet connection appears to be offline."
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    };
}


#pragma mark -
#pragma mark Check Connectivity
- (void)checkConnection{
    connection = [Reachability reachabilityWithHostname:@"www.google.com"];
    __block id myself = self;
    
    // Internet is reachable
    connection.reachableBlock = ^(Reachability*reach){
        dispatch_async(dispatch_get_main_queue(), ^{
            [myself displayView:YES];
        });
    };
    
    // Internet is not reachable
    connection.unreachableBlock = ^(Reachability*reach){
        dispatch_async(dispatch_get_main_queue(), ^{
            [myself displayView:NO];

        });
    };
    
    [connection startNotifier];
}

#pragma mark - call JSON
- (void)fetchKeywords{
    // call keyword
    
    [keywordIndicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString: @"http://www.sensr.org/getKeywords.php"]];
        NSError* error;
        keywords = [NSJSONSerialization JSONObjectWithData:data
                                                   options:kNilOptions
                                                     error:&error];

        UIFont *keywordFont = [UIFont systemFontOfSize:16.0f];;//[UIFont fontWithName:@"Helvetica" size:16];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            int x = 0;//-20;
            int y = 0;
            int margin = 20;
            
            for(int i=0;i<[keywords count];i++){
                if(i<8){
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    [button addTarget:self
                               action:@selector(keywordPressed:)
                     forControlEvents:UIControlEventTouchDown];
            
                    NSString *keyword = [[keywords objectAtIndex:i] objectForKey:@"word"];
                    CGSize keywordSize = [keyword sizeWithFont:keywordFont];
                
                    [button setTitle:keyword forState:UIControlStateNormal];
                    button.titleLabel.font = keywordFont;
                    button.titleLabel.textColor = [UIColor whiteColor];
                
                    if(x+keywordSize.width>300){
                        x = 0;//-20;
                        y = 25;
                    }
                    button.frame = CGRectMake(x, y, 80.0, 30.0);
                    button.tag = i;
                    [keywordView addSubview:button];
                    x += keywordSize.width+ margin;
                }
            };
            [keywordIndicator stopAnimating];
        });
    });
}

- (void)fetchProjects{
    // call featured projects
    
    [featuredProjectIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString: @"http://www.sensr.org/json/jsonCallFeaturedProjects.php"]];
        
        NSError* error;
        
        featuredProjects = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for(int i=0;i<[featuredProjects count];i++){
                CGRect imageFrame;
                imageFrame.origin.x = self.featuredProjectView.frame.size.width * i;
                imageFrame.origin.y = 0;
                imageFrame.size = self.featuredProjectView.frame.size;

                CGRect titleFrame;
                titleFrame.origin.x = 10+ self.featuredProjectView.frame.size.width * i;
                titleFrame.origin.y = 100;
                titleFrame.size = CGSizeMake(self.featuredProjectView.frame.size.width, 28);
                
                CGRect categoryFrame;
                categoryFrame.origin.x = 10+ self.featuredProjectView.frame.size.width * i;
                categoryFrame.origin.y = 123;
                categoryFrame.size = CGSizeMake(self.featuredProjectView.frame.size.width, 22);

                NSDictionary *featuredProject = [featuredProjects objectAtIndex:i];
                NSString *logoURL = [NSString stringWithFormat:@"http://www.sensr.org/%@", [featuredProject objectForKey:@"logoPath"]];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button addTarget:self
                           action:@selector(featuredProjectPressed:)
                 forControlEvents:UIControlEventTouchDown];
                
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:logoURL]];
                UIImage *image = [UIImage imageWithData:data];
                [button setBackgroundImage:image forState:UIControlStateNormal];
                button.frame = imageFrame;
                button.tag = i;
                button.adjustsImageWhenHighlighted = NO;

                UIView *view = [[UIView alloc] initWithFrame:imageFrame];
                CAGradientLayer *gradient = [CAGradientLayer layer];
                gradient.frame = view.bounds;
                gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] CGColor], nil];
                [view.layer insertSublayer:gradient atIndex:0];
                view.userInteractionEnabled = NO;

                UILabel  *title = [[UILabel alloc] initWithFrame:titleFrame];
                title.textColor = [UIColor whiteColor];
                title.backgroundColor = [UIColor clearColor];
                title.font = [UIFont boldSystemFontOfSize:17.0f];
                
                UILabel  *cat = [[UILabel alloc] initWithFrame:categoryFrame];
                cat.backgroundColor = [UIColor clearColor];
                cat.textColor = [UIColor whiteColor];
                cat.font = [UIFont systemFontOfSize:14.0f];

                title.text = [[featuredProjects objectAtIndex:i] objectForKey:@"title"];
                cat.text = [NSString stringWithFormat:@"Category: %@", [[featuredProjects objectAtIndex:i] objectForKey:@"category"]];
                [self.featuredProjectView addSubview:button];
                [self.featuredProjectView addSubview:view];
                [self.featuredProjectView addSubview:title];
                [self.featuredProjectView addSubview:cat];
                
            };
            featuredProjectView.contentSize = CGSizeMake(featuredProjectView.frame.size.width * [featuredProjects count], featuredProjectView.frame.size.height);
            [featuredProjectIndicator stopAnimating];
        });
    });
    
//    [featuredProjectIndicator startAnimating];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSData* data = [NSData dataWithContentsOfURL:
//                        [NSURL URLWithString: @"http://www.sensr.org/json/jsonCallFeaturedProjects.php"]];
//        
//        NSError* error;
//        
//        featuredProjects = [NSJSONSerialization JSONObjectWithData:data
//                                                           options:kNilOptions
//                                                             error:&error];
//        
//        for (int i = 0; i < [featuredProjects count]; i++) {
//            CGRect imageFrame;
//            imageFrame.origin.x = self.featuredProjectView.frame.size.width * i;
//            imageFrame.origin.y = 0;
//            imageFrame.size = self.featuredProjectView.frame.size;
//            
//            CGRect titleFrame;
//            titleFrame.origin.x = 5+ self.featuredProjectView.frame.size.width * i;
//            titleFrame.origin.y = 90;
//            titleFrame.size = CGSizeMake(self.featuredProjectView.frame.size.width, 28);
//            
//            CGRect categoryFrame;
//            categoryFrame.origin.x = 5+ self.featuredProjectView.frame.size.width * i;
//            categoryFrame.origin.y = 113;
//            categoryFrame.size = CGSizeMake(self.featuredProjectView.frame.size.width, 22);
//            
//            CGRect locationFrame;
//            locationFrame.origin.x = 5+ self.featuredProjectView.frame.size.width * i;
//            locationFrame.origin.y = 128;
//            locationFrame.size = CGSizeMake(self.featuredProjectView.frame.size.width, 22);
//            
//            NSDictionary *featuredProject = [featuredProjects objectAtIndex:i];
//            NSString *logoURL = [NSString stringWithFormat:@"http://www.sensr.org/%@", [featuredProject objectForKey:@"logoPath"]];
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            [button addTarget:self
//                       action:@selector(featuredProjectPressed:)
//             forControlEvents:UIControlEventTouchDown];
//            
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:logoURL]];
//            UIImage *image = [UIImage imageWithData:data];
//            [button setBackgroundImage:image forState:UIControlStateNormal];
//            button.frame = imageFrame;
//            button.tag = i;
//            button.adjustsImageWhenHighlighted = NO;
//            
//            UILabel  *title = [[UILabel alloc] initWithFrame:titleFrame];
//            title.textColor = [UIColor whiteColor];
//            title.backgroundColor = [UIColor clearColor];
//            title.font = [UIFont boldSystemFontOfSize:17.0f];
//            
//            UILabel  *cat = [[UILabel alloc] initWithFrame:categoryFrame];
//            cat.backgroundColor = [UIColor clearColor];
//            cat.textColor = [UIColor whiteColor];
//            cat.font = [UIFont systemFontOfSize:14.0f];
//            
//            UILabel  *loc = [[UILabel alloc] initWithFrame:locationFrame];
//            loc.backgroundColor = [UIColor clearColor];
//            loc.textColor = [UIColor whiteColor];
//            loc.font = [UIFont systemFontOfSize:14.0f];
//            
//            UIView *view = [[UIView alloc] initWithFrame:imageFrame];
//            CAGradientLayer *gradient = [CAGradientLayer layer];
//            gradient.frame = view.bounds;
//            gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] CGColor], nil];
//            [view.layer insertSublayer:gradient atIndex:0];
//            view.userInteractionEnabled = NO;
//            
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                [self.featuredProjectView addSubview:button];
//                title.text = [[featuredProjects objectAtIndex:i] objectForKey:@"title"];
//                cat.text = [NSString stringWithFormat:@"Category: %@", [[featuredProjects objectAtIndex:i] objectForKey:@"category"]];
//                NSString *l = ([[[featuredProjects objectAtIndex:i] objectForKey:@"state"] isEqualToString:@""])?@"Nationwide":[[featuredProjects objectAtIndex:i] objectForKey:@"state"];
//                loc.text = [NSString stringWithFormat:@"Location: %@", l];
//            });
//            
//            [self.featuredProjectView addSubview:view];
//            [self.featuredProjectView addSubview:title];
//            [self.featuredProjectView addSubview:cat];
//            [self.featuredProjectView addSubview:loc];
//            
//        }
//        featuredProjectView.contentSize = CGSizeMake(featuredProjectView.frame.size.width * [featuredProjects count], featuredProjectView.frame.size.height);
//        [featuredProjectIndicator stopAnimating];
//    });
}

- (void)fetchRecentProjects{
    [recentProjectIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString: @"http://www.sensr.org/json/jsonCallRecentProjects.php"]];
        
        NSError* error;
        
        recentProjects = [NSJSONSerialization JSONObjectWithData:data
                                                   options:kNilOptions
                                                     error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for(int i=0;i<[recentProjects count];i++){
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button addTarget:self
                           action:@selector(recentProjectPressed:)
                 forControlEvents:UIControlEventTouchDown];
                
                NSString *iconURL = [NSString stringWithFormat:@"http://www.sensr.org/%@", [[recentProjects objectAtIndex:i] objectForKey:@"iconPath"]];
                NSData   *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:iconURL]];
                UIImage *image = [UIImage imageWithData:data];
                [button setBackgroundImage:image forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor whiteColor]];
                CALayer * layer = [button layer];
                [layer setMasksToBounds:YES];
                [layer setCornerRadius:0.0]; //when radius is 0, the border is a rectangle
                [layer setBorderWidth:2.0];
                [layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
                
                button.frame = CGRectMake(63*i + i, 0, 63.0, 63.0);
                button.tag = i;
                [recentProjectView addSubview:button];
            };
            [recentProjectIndicator stopAnimating];
        });
    });
}

- (void)featuredProjectPressed:(id)sender{
    [self performSegueWithIdentifier:@"ProjectFromHome" sender:[featuredProjects objectAtIndex:((UIControl*)sender).tag]];
}

- (void)keywordPressed:(id)sender{
    [self performSegueWithIdentifier:@"ProjectListFromHome" sender:[[keywords objectAtIndex:((UIControl*)sender).tag] objectForKey:@"word"]];
}

- (void)recentProjectPressed:(id)sender{
    [self performSegueWithIdentifier:@"ProjectFromHome" sender:[recentProjects objectAtIndex:((UIControl*)sender).tag]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ProjectListFromHome"]) {
        ProjectListTableViewController *projectViewController = segue.destinationViewController;
        projectViewController.keyword =sender;
        projectViewController.hidesBottomBarWhenPushed = YES;
    }
    if ([segue.identifier isEqualToString:@"ProjectFromHome"]) {
        ProjectViewController *projectViewController = segue.destinationViewController;
        projectViewController.projectDictionary =sender;
        projectViewController.hidesBottomBarWhenPushed = YES;
    }
}



#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.featuredProjectView.frame.size.width;
    int page = floor((self.featuredProjectView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

@end
