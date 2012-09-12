//
//  ActivityLog.h
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-08-31.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ListingModel : NSObject
    @property NSString *name; // name of listing
    @property NSString *address; // address
    @property NSDate *CreatedDate;
    @property NSDate *ModifiedDate;
@end



@interface ContactModel : NSObject
@property NSString *name;
@property NSString *company;
@property NSString *phone;
@property NSString *email;
@end



@interface ActivityLogModel : NSObject
    @property NSDate *date;
    @property NSString *source;
    @property NSString *note;
    @property NSString *feedback;
    @property NSDate *CreatedDate;
    @property NSDate *ModifiedDate;
    @property ContactModel *contact;
@end


@interface InquiryModel : ActivityLogModel 
@end



@interface ShowingModel : ActivityLogModel
@end



@interface OpenHouseModel : ActivityLogModel
    @property (nonatomic) NSInteger *visitors;
@end


@interface OfferModel : ActivityLogModel
@end


@interface SourceModel : NSObject
@property NSString *label;
@end
