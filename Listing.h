//
//  Listing.h
//  Listing Agent
//
//  Created by Lubos Hrasko on 2012-09-20.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ActivityLog, Contact;

@interface Listing : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * mlsNumber;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * doorCode;
@property (nonatomic, retain) NSString * alarmCode;
@property (nonatomic, retain) NSDecimalNumber * listPrice;
@property (nonatomic, retain) NSDecimalNumber * taxValue;
@property (nonatomic, retain) NSSet *activityLogs;
@property (nonatomic, retain) NSSet *contacts;
@end

@interface Listing (CoreDataGeneratedAccessors)

- (void)addActivityLogsObject:(ActivityLog *)value;
- (void)removeActivityLogsObject:(ActivityLog *)value;
- (void)addActivityLogs:(NSSet *)values;
- (void)removeActivityLogs:(NSSet *)values;

- (void)addContactsObject:(Contact *)value;
- (void)removeContactsObject:(Contact *)value;
- (void)addContacts:(NSSet *)values;
- (void)removeContacts:(NSSet *)values;

@end
