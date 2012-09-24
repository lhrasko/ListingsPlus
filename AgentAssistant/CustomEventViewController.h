//
//  CustomEventViewController.h
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-08-30.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"
#import "CustomEvent.h"
#import "SourceTableViewController.h"
#import "ContactsViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "YIPopupTextView.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@class CustomEventViewController;

@protocol CustomEventViewControllerDelegate <NSObject>
- (void)CustomEventViewControllerDidCancel:(CustomEventViewController *)controller;
- (void)CustomEventViewControllerDidSave:(CustomEventViewController *)controller;
@end


@interface CustomEventViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate, SourceTableViewControllerDelegate, ContactsViewControllerDelegate, YIPopupTextViewDelegate, EKEventEditViewDelegate, UIAlertViewDelegate > {
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}


@property (nonatomic, weak) id <CustomEventViewControllerDelegate> delegate;


@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (nonatomic, strong) Listing *listing;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *textBoxToolbar;
@property (nonatomic, strong) CustomEvent *customEntity;

@property (nonatomic, retain) NSMutableArray *tableView1Data;
@property UITextField *actifText;

- (IBAction)actionButtonPressed:(id)sender;
- (IBAction)hideKeyboardButtonPressed:(id)sender;
- (IBAction)SaveButtonPressed:(id)sender;

@end
