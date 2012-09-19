//
//  showingViewController.h
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-08-30.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"
#import "Showing.h"
#import "NoteViewController.h"
#import "SourceTableViewController.h"
#import "ContactsViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "YIPopupTextView.h"


@class ShowingDetailViewController;

@protocol ShowingDetailViewControllerDelegate <NSObject>
- (void)ShowingDetailViewControllerDidCancel:(ShowingDetailViewController *)controller;
- (void)ShowingDetailViewControllerDidSave:(ShowingDetailViewController *)controller;
@end


@interface ShowingDetailViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate, SourceTableViewControllerDelegate, ContactsViewControllerDelegate, YIPopupTextViewDelegate > {
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}


@property (nonatomic, weak) id <ShowingDetailViewControllerDelegate> delegate;


@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (nonatomic, strong) Listing *listing;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Showing *showingEntity;

@property (nonatomic, retain) NSMutableArray *tableView1Data;
@property UITextField *actifText;

-(IBAction)SaveButtonPressed:(id)sender;

@end
