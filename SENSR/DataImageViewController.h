//
//  DataImageViewController.h
//  SENSR
//
//  Created by Sunyoung Kim on 8/12/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataImageViewController : UIViewController{
    UIImageView *imageView;
    UIImage *image;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

@end
