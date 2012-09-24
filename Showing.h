//
//  Showing.h
//  Listing Agent
//
//  Created by Lubos Hrasko on 2012-09-20.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ActivityLog.h"


@interface Showing : ActivityLog

@property (nonatomic, retain) NSString * calendarEventIdentifier;

@end
