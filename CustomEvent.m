//
//  CustomEvent.m
//  Listing Agent
//
//  Created by Lubos Hrasko on 2012-09-19.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "CustomEvent.h"


@implementation CustomEvent

@dynamic name;


-(NSString *)label
{
    if (self.name != nil)
        return self.name;
    else
        return @"Other";
}


@end
