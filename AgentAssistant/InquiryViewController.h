//
//  InquiryViewController.h
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-08-30.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"
#import "Inquiry.h"
#import "NoteViewController.h"
#import "SourceTableViewController.h"
#import "ContactsViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "YIPopupTextView.h"


@class InquiryViewController;

@protocol InquiryViewControllerDelegate <NSObject>
- (void)InquiryViewControllerDidSave:(InquiryViewController *)controller;
@end


@interface InquiryViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate, SourceTableViewControllerDelegate, ContactsViewControllerDelegate, YIPopupTextViewDelegate, UIAlertViewDelegate > {
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}


@property (nonatomic, weak) id <InquiryViewControllerDelegate> delegate;


@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *listingLabel;

@property (nonatomic, strong) Listing *listing;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Inquiry *inquiryEntity;

@property (nonatomic, retain) NSMutableArray *tableView1Data;
@property UITextField *actifText;

-(IBAction)SaveButtonPressed:(id)sender;

@end
