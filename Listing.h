//
//  Listing.h
//  Agent Assist
//
//  Created by Lubos Hrasko on 2012-09-04.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ActivityLog;

@interface Listing : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSMutableSet *activityLogs;
@end

@interface Listing (CoreDataGeneratedAccessors)

- (void)addActivityLogsObject:(ActivityLog *)value;
- (void)removeActivityLogsObject:(ActivityLog *)value;
- (void)addActivityLogs:(NSSet *)values;
- (void)removeActivityLogs:(NSSet *)values;

@end
