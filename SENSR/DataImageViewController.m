//
//  DataImageViewController.m
//  SENSR
//
//  Created by Sunyoung Kim on 8/12/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import "DataImageViewController.h"

@interface DataImageViewController ()

@end

@implementation DataImageViewController

@synthesize image, imageView;

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
	// Do any additional setup after loading the view.
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
