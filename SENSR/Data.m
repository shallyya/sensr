//
//  Data.m
//  SENSR
//
//  Created by Sunyoung Kim on 8/10/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import "Data.h"
#import "Project.h"


@implementation Data

@dynamic imageName;
@dynamic isDataUploaded;
@dynamic latitude;
@dynamic longitude;
@dynamic tabData;
@dynamic textFieldData;
@dynamic timestamp;
@dynamic title;
@dynamic uniqueID;
@dynamic dataImage;
@dynamic project;
@dynamic postValue;

@end

@implementation DataImageToDataTransformer


+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}


- (id)transformedValue:(id)value {
	NSData *data = UIImagePNGRepresentation(value);
	return data;
}


- (id)reverseTransformedValue:(id)value {
	UIImage *uiImage = [[UIImage alloc] initWithData:value];
	return uiImage;
}

@end