//
//  Project.h
//  SENSR
//
//  Created by Sunyoung Kim on 8/6/13.
//  Copyright (c) 2013 Sunyoung Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ImageToDataTransformer : NSValueTransformer {
}
@end

@interface Project : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) NSString * campaignDescription;
@property (nonatomic, retain) NSString * keywords;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * itemsOrder;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * labelsForTextfield;
@property (nonatomic, retain) NSString * labelsForTab2;
@property (nonatomic, retain) NSString * labelsForTab3;
@property (nonatomic, retain) NSString * labelForSubmitBtn;
@property (nonatomic, retain) NSString * logoPath;
@property (nonatomic, retain) NSString * iconPath;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, assign) BOOL filtering;
@property (nonatomic, assign) BOOL usePhoto;
@property (nonatomic, retain) id logoImage;
@property (nonatomic, retain) id iconImage;
@property (nonatomic, retain) NSData * timestamp;
@property (nonatomic, retain) NSNumber * expirationDate;
@property (nonatomic, retain) NSNumber * numTab2;
@property (nonatomic, retain) NSNumber * numTab3;
@property (nonatomic, retain) NSNumber * numTextfield;

@end
