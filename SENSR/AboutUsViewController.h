//
//  AboutUsViewController.h
//  SENSR
//
//  Created by Sunyoung Kim on 8/12/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsViewController : UIViewController{
    UIScrollView *scrollView;
    UITextView *textView;
    UIImageView *backgroundView;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundView;

@end
