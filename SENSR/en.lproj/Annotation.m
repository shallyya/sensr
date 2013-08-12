//
//  Annotation.m
//  Sensr
//
//  Created by Sunyoung Kim on 2/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Annotation.h"


@implementation Annotation

@synthesize coordinate;

- (NSString *)subtitle{
	return @"You are here";
}

- (NSString *)title{
	return @"Current Location";
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	//NSLog(@"%f,%f",c.latitude,c.longitude);
	return self;
}
@end