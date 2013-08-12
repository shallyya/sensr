//
//  Project.m
//  SENSR
//
//  Created by Sunyoung Kim on 8/6/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import "Project.h"


@implementation Project

@dynamic timestamp;
@dynamic author;
@dynamic email;
@dynamic uniqueID;
@dynamic campaignDescription;
@dynamic keywords;
@dynamic url;
@dynamic category;
@dynamic itemsOrder;
@dynamic title;
@dynamic usePhoto;
@dynamic labelsForTextfield;
@dynamic numTab2;
@dynamic labelsForTab2;
@dynamic numTab3;
@dynamic labelsForTab3;
@dynamic labelForSubmitBtn;
@dynamic logoPath;
@dynamic logoImage;
@dynamic iconPath;
@dynamic iconImage;
@dynamic location;
@dynamic state;
@dynamic filtering;
@dynamic numTextfield;
@dynamic expirationDate;

@end

@implementation ImageToDataTransformer


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
