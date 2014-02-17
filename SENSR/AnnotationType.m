//
//  AnnotationTypeB.m
//  Water2
//
//  Created by Sunyoung Kim on 6/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AnnotationType.h"


@implementation AnnotationType

@synthesize annotationData, project, data, dataDictionary, imageName;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	theCoordinate=c;
	return self;
}

-(CLLocationCoordinate2D)coordinate{
	theCoordinate.latitude = [[annotationData objectForKey:@"_latitude"] doubleValue];
	theCoordinate.longitude = [[annotationData objectForKey:@"_longitude"] doubleValue];
	
	return theCoordinate;
}

- (NSString *)title{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"Y/M/dd HH:mm:ss"];
	NSString *stringFromDate = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[[annotationData valueForKey:@"_timestamp"] description] intValue] ]];
	
	return stringFromDate;
}

-(NSString *)subtitle{
	return nil;
}

-(NSString *)image{
	NSString *i = [annotationData objectForKey:@"image"];
	return i;
}

- (void)setData:(NSDictionary*)d{
    annotationData = d;
}

- (void)setProject:(Project*)p{
    project = p;
}

- (void)setDataDictionary:(NSDictionary *)d{
    dataDictionary = d;
}

- (void)setImageName:(NSString *)i{
    imageName = i;
}
#pragma mark -
#pragma mark Memory management

- (void)dealloc {
}

@end
