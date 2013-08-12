//
//  AnnotationTypeB.h
//  Water2
//
//  Created by Sunyoung Kim on 6/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Project.h"
#import "Data.h"

@interface AnnotationType : NSObject <MKAnnotation>{
	CLLocationCoordinate2D  theCoordinate;
	NSDictionary           *annotationData;
    Project *project;
    NSDictionary *dataDictionary;
	NSString *mTitle;
	NSString *mSubTitle;
    NSString *imageName;
}

@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, retain) Data *data;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSDictionary *annotationData;
@property (nonatomic, retain) NSDictionary *dataDictionary;

@end
