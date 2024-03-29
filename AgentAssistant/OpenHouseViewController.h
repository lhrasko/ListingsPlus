//
//  OpenhouseViewController.h
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-08-30.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"
#import "OpenHouse.h"
#import "NoteViewController.h"
#import "SourceTableViewController.h"
#import "ContactsViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "YIPopupTextView.h"
#import <EventKitUI/EventKitUI.h>


@class OpenHouseViewController;

@protocol OpenHouseViewControllerDelegate <NSObject>
- (void)OpenHouseViewControllerDidSave:(OpenHouseViewController *)controller;
@end


@interface OpenHouseViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate, SourceTableViewControllerDelegate, ContactsViewControllerDelegate, YIPopupTextViewDelegate, EKEventEditViewDelegate, UIAlertViewDelegate> {
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}


@property (nonatomic, weak) id <OpenHouseViewControllerDelegate> delegate;


@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (nonatomic, strong) Listing *listing;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) OpenHouse *openHouseEntity;
- (IBAction)actionButtonPressed:(id)sender;

@property (nonatomic, retain) NSMutableArray *tableView1Data;
@property (weak, nonatomic) IBOutlet UILabel *listingLabel;

-(IBAction)SaveButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;

@end
