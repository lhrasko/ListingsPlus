//
//  CustomEvent.m
//  Listing Agent
//
//  Created by Lubos Hrasko on 2012-09-20.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "CustomEvent.h"


@implementation CustomEvent

@dynamic name;
@dynamic calendarEventIdentifier;


-(NSString *)label
{
    if (self.name != nil)
        return self.name;
    else
        return @"Custom Event";
}


@end
