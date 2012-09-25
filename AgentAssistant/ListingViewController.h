//
//  CustomEventViewController.h
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-08-30.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"
#import "ContactsViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "YIPopupTextView.h"

@class ListingViewController;

@protocol ListingViewControllerDelegate <NSObject>
- (void)ListingViewControllerDidCancel:(ListingViewController *)controller;
- (void)ListingViewControllerDidSave:(ListingViewController *)controller;
@end


@interface ListingViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate, ContactsViewControllerDelegate, YIPopupTextViewDelegate, UIAlertViewDelegate > {
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}


@property (nonatomic, weak) id <ListingViewControllerDelegate> delegate;


@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (nonatomic, strong) Listing *listing;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *textBoxToolbar;

@property (nonatomic, retain) NSMutableArray *tableView1Data;
@property UITextField *actifText;

- (IBAction)hideKeyboardButtonPressed:(id)sender;
- (IBAction)SaveButtonPressed:(id)sender;

@end
