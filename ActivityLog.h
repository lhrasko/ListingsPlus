//
//  ActivityLog.h
//  Realtor Assist
//
//  Created by Lubos Hrasko on 2012-09-11.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact, Listing;

@interface ActivityLog : NSManagedObject

@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * feedback;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSSet *contacts;
@property (nonatomic, retain) Listing *listing;

-(NSString *)label;

@end

@interface ActivityLog (CoreDataGeneratedAccessors)

- (void)addContactsObject:(Contact *)value;
- (void)removeContactsObject:(Contact *)value;
- (void)addContacts:(NSSet *)values;
- (void)removeContacts:(NSSet *)values;

@end
