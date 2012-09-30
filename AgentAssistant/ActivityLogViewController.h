//
//  ListingDetailViewController.h
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-08-29.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "listing.h"
#import "InquiryViewController.h"
#import "ShowingDetailViewController.h"
#import "OpenHouseViewController.h"
#import "CustomEventViewController.h"
#import <MessageUI/MessageUI.h>

@interface ActivityLogViewController : UIViewController <
        UITableViewDelegate,
        UITableViewDataSource,
        NSFetchedResultsControllerDelegate,
        UIActionSheetDelegate,
        InquiryViewControllerDelegate,
        ShowingDetailViewControllerDelegate,
        OpenHouseViewControllerDelegate,
        CustomEventViewControllerDelegate,
        MFMailComposeViewControllerDelegate > {
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *addNewButton;
@property (nonatomic, strong) Listing *listing;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableDictionary *sections;
@property (strong, nonatomic) NSArray *sortedDays;
@property (strong, nonatomic) NSDateFormatter *sectionDateFormatter;
@property (strong, nonatomic) NSDateFormatter *cellDateFormatter;
@property (weak, nonatomic) IBOutlet UILabel *listingLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingButton;

-(void) showWelcomeMessage;
-(IBAction)ActionSheetButton;
- (IBAction)sendMessageButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;
- (IBAction)settingsButtonPressed:(id)sender;

@end
