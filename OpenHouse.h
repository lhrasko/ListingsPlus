//
//  OpenHouse.h
//  Agent Assist
//
//  Created by Lubos Hrasko on 2012-09-04.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ActivityLog.h"


@interface OpenHouse : ActivityLog

@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * visitors;

@end
