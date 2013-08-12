//
//  FindByIdViewController.h
//  SENSR
//
//  Created by Sunyoung Kim on 8/8/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindByIdViewController : UIViewController <UITextFieldDelegate>{
    UITextField *idField;
    UIButton *findButton;
}

@property (nonatomic, retain) IBOutlet UITextField *idField;
@property (nonatomic, retain) IBOutlet UIButton *findButton;

- (IBAction) findButtonPressed:(id)sender;

@end
