//
//  SettingsTableViewController.h
//  SENSR
//
//  Created by Sunyoung Kim on 8/12/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController <UITextFieldDelegate>{
    NSUserDefaults *prefs;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;

@end
