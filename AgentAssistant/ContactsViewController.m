//
//  ContactsViewController.m
//  Realtor Assist
//
//  Created by Lubos Hrasko on 2012-09-11.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "ContactsViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Contact.h"
#import "AppDelegate.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

@synthesize delegate;
@synthesize activityLog;
@synthesize tableView;

AppDelegate *appDelegate;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (section == 1)
        return 2;
    else
        return activityLog.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    // Set up the cell...
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [UITableViewCell alloc];
        }
        cell.textLabel.text = @"Select from Address Book";
        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [button addTarget:self action:@selector(buttonTapped:event:) forControlEvents:  UIControlEventTouchUpInside];
        cell.accessoryView = button;
        cell.textLabel.textColor = [UIColor blackColor];

        return cell;
    }
    
    if(indexPath.section == 1 && indexPath.row == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [UITableViewCell alloc];
        }
        cell.textLabel.text = @"Create New Contact";
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [button addTarget:self action:@selector(buttonTapped:event:) forControlEvents:  UIControlEventTouchUpInside];
        //and created the event handling procedure - (void)buttonTapped:(id)sender event:(id)event { }
        cell.accessoryView = button;
        cell.textLabel.textColor = [UIColor blackColor];

        return cell;
    }
    
    if (indexPath.section == 0)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        NSMutableArray *contacts = [[activityLog.contacts allObjects] mutableCopy];
        Contact *contact = [contacts objectAtIndex:indexPath.row];
        
        cell.textLabel.text = contact.compositeName;
        cell.textLabel.textColor = [UIColor colorWithRed:0.19607843 green:0.30980392 blue:0.52156863 alpha:1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }


}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
            picker.peoplePickerDelegate = self;
            [self presentModalViewController:picker animated:YES];
        }
        if (indexPath.row == 1)
        {
            ABNewPersonViewController *view = [[ABNewPersonViewController alloc] init];
            view.newPersonViewDelegate = self;
            UINavigationController *newNavigationController = [[UINavigationController alloc] initWithRootViewController:view];
            [self presentModalViewController:newNavigationController animated:YES];
        }

    }
    
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}



- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissModalViewControllerAnimated:YES];
}


- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    // a new contact was picked
    
    Contact *contactEntity = (Contact *)[NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:appDelegate.managedObjectContext];
    contactEntity.activityLog = activityLog;
    
    contactEntity.compositeName = (__bridge NSString *)(ABRecordCopyCompositeName(person));
    contactEntity.firstName =  (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    contactEntity.lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty); //kABUIDProperty
    contactEntity.uniqueId = [NSNumber numberWithInteger: ABRecordGetRecordID(person)];

    [activityLog addContactsObject:contactEntity];
    
    [tableView reloadData];
    [self dismissModalViewControllerAnimated:YES];
    
    return NO;
}




- (IBAction)doneButtonClicked:(id)sender {
    [self.delegate ContactsViewControllerDidCancel:self];
}


@end
