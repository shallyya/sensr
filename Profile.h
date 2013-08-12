//
//  Profile.h
//  SENSR
//
//  Created by Sunyoung Kim on 8/10/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface Profile : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * exposeInfo;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) Project *project;

@end
