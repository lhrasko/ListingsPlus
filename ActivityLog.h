//
//  ActivityLog.h
//  Agent Assist
//
//  Created by Lubos Hrasko on 2012-09-04.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Listing;

@interface ActivityLog : NSManagedObject

@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * feedback;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) Listing *listing;

-(NSString *)label;
@end
