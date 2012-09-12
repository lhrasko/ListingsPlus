//
//  ActivityLog.m
//  Realtor Assist
//
//  Created by Lubos Hrasko on 2012-09-11.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "ActivityLog.h"
#import "Contact.h"
#import "Listing.h"


@implementation ActivityLog

@dynamic createdDate;
@dynamic date;
@dynamic feedback;
@dynamic modifiedDate;
@dynamic note;
@dynamic source;
@dynamic contacts;
@dynamic listing;

-(NSString *)label
{
    return @"ActivityLog";
}

@end
