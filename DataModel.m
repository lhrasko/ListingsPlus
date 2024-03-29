//
//  ActivityLog.m
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-08-31.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "DataModel.h"


@implementation ListingModel
    @synthesize name;
    @synthesize address;
    @synthesize CreatedDate;
    @synthesize ModifiedDate;
@end


@implementation ActivityLogModel
    @synthesize date;
    @synthesize source;
    @synthesize note;
    @synthesize feedback;
    @synthesize CreatedDate;
    @synthesize ModifiedDate;
@end


@implementation InquiryModel
@end


@implementation ShowingModel
@end


@implementation OpenHouseModel
    @synthesize visitors;
@end


@implementation OfferModel
@end

@implementation SourceModel
@synthesize label;
@end


@implementation ContactModel
@synthesize name;
@synthesize company;
@synthesize phone;
@synthesize email;
@end