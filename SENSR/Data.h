//
//  Data.h
//  SENSR
//
//  Created by Sunyoung Kim on 8/10/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface Data : NSManagedObject

@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * isDataUploaded;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * tabData;
@property (nonatomic, retain) NSString * textFieldData;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * postValue;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) id dataImage;
@property (nonatomic, retain) Project *project;

@end
