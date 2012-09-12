//
//  ContactsViewController.h
//  Realtor Assist
//
//  Created by Lubos Hrasko on 2012-09-11.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "ActivityLog.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@class ContactsViewController;

@protocol ContactsViewControllerDelegate <NSObject>
- (void)ContactsViewControllerDidCancel:(ContactsViewController *)controller;
- (void)ContactsViewControllerDidSave:(ContactsViewController *)controller source:(NSString *)source;
@end

@interface ContactsViewController : UITableViewController <ABPeoplePickerNavigationControllerDelegate, ABNewPersonViewControllerDelegate>

@property (nonatomic, weak) id <ContactsViewControllerDelegate> delegate;
@property (nonatomic, retain) ActivityLog *activityLog;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
