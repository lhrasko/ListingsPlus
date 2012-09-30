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
#import "Inquiry.h"
#import "Listing.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

@synthesize delegate;
@synthesize activityLog;
@synthesize listing;
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
    self.navigationItem.title = @"Contacts";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



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
        if (activityLog != nil)
            return activityLog.contacts.count;
        else
            return listing.contacts.count;
}



-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (activityLog != nil)
    {
        if (section == 0 && activityLog.contacts.count > 0)
            return @"Added Contacts";
    
        if (section == 1 && activityLog.contacts.count == 0)
            return @"Add Contacts";
        
        if (section == 1 && activityLog.contacts.count > 0)
            return @"Add More" ;
    }
    else
    {
        if (section == 0 && listing.contacts.count > 0)
            return @"Added Contacts";
        
        if (section == 1 && listing.contacts.count == 0)
            return @"Add Contacts";
        
        if (section == 1 && listing.contacts.count > 0)
            return @"Add More" ;
    }
    
    return nil;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    if (indexPath.section == 0)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        NSMutableArray *contacts;
        if (activityLog != nil)
            contacts = [[activityLog.contacts allObjects] mutableCopy];
        else
            contacts = [[listing.contacts allObjects] mutableCopy];
        
        Contact *contact = [contacts objectAtIndex:indexPath.row];
        
        cell.textLabel.text = contact.compositeName;
        cell.textLabel.textColor = [UIColor colorWithRed:0.19607843 green:0.30980392 blue:0.52156863 alpha:1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }

    
    if(indexPath.section == 1 && indexPath.row == 1)
    {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [UITableViewCell alloc];
        }
        cell.textLabel.text = @"Add New Contact";
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [button addTarget:self action:@selector(buttonTapped:event:) forControlEvents:  UIControlEventTouchUpInside];
        cell.accessoryView = button;
        cell.textLabel.textColor = [UIColor blackColor];
        
        return cell;
    }

    
    // Set up the cell...
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [UITableViewCell alloc];
        }
        cell.textLabel.text = @"Add from Address Book";
        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [button addTarget:self action:@selector(buttonTapped:event:) forControlEvents:  UIControlEventTouchUpInside];
        cell.accessoryView = button;
        cell.textLabel.textColor = [UIColor blackColor];

        return cell;
    }
    
    return nil;
}


-(void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
}


// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    if (indexPath.section == 0)
        return YES;
    else
        return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (activityLog != nil)
        {
            NSMutableArray *contacts = [[activityLog.contacts allObjects] mutableCopy];
            Contact *contact = [contacts objectAtIndex:indexPath.row];
            [activityLog removeContactsObject:contact];
        }
        else
        {
            NSMutableArray *contacts = [[listing.contacts allObjects] mutableCopy];
            Contact *contact = [contacts objectAtIndex:indexPath.row];
            [listing removeContactsObject:contact];
        }
        
        [self.tableView reloadData];
    }
}




- (void)buttonTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    
    if (indexPath != nil)
    {
        [self tableView: self.tableView didSelectRowAtIndexPath: indexPath];
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
            picker.peoplePickerDelegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
        if (indexPath.row == 1)
        {
            ABNewPersonViewController *view = [[ABNewPersonViewController alloc] init];
            view.newPersonViewDelegate = self;
            
            UINavigationController *newNavigationController = [[UINavigationController alloc] initWithRootViewController:view];
            [self presentViewController:newNavigationController animated:YES completion:nil];
        }
    }
    if (indexPath.section == 0)
    {
        NSMutableArray *contacts;
        if (activityLog != nil)
            contacts = [[activityLog.contacts allObjects] mutableCopy];
        else
            contacts = [[listing.contacts allObjects] mutableCopy];

        Contact *contact = [contacts objectAtIndex:indexPath.row];
        
        ABPersonViewController *personController = [[ABPersonViewController alloc] initWithNibName:@"ABPersonViewController" bundle:nil];

        personController.personViewDelegate = self;
        
        ABAddressBookRef ab = ABAddressBookCreateWithOptions(nil, nil);
        ABRecordRef person = ABAddressBookGetPersonWithRecordID(ab,contact.uniqueId.integerValue);
        personController.displayedPerson = person; // Assume person is already defined.
        personController.allowsEditing = true;
        personController.allowsActions = true;
        personController.modalPresentationStyle = UIModalTransitionStylePartialCurl;
        
        [self.navigationController pushViewController:personController animated:YES];
    }
}



- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    // a contact was picked
    
    Contact *contactEntity = (Contact *)[NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:appDelegate.managedObjectContext];
    
    contactEntity.compositeName = (__bridge NSString *)(ABRecordCopyCompositeName(person));
    contactEntity.firstName =  (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    contactEntity.lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty); //kABUIDProperty
    contactEntity.uniqueId = [NSNumber numberWithInteger: ABRecordGetRecordID(person)];
    
    if (activityLog != nil)
    {
        contactEntity.activityLog = activityLog;
        [activityLog addContactsObject:contactEntity];
    }
    else
        [listing addContactsObject:contactEntity];
    
    [tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}



- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}



- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#define CFRELEASE_AND_NIL(x) CFRelease(x); x=nil;

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
{
    if (person != nil)
    {
        // a new contact was added
        Contact *contactEntity = (Contact *)[NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:appDelegate.managedObjectContext];
        contactEntity.activityLog = activityLog;
    
        contactEntity.compositeName = (__bridge NSString *)(ABRecordCopyCompositeName(person));
        contactEntity.firstName =  (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        contactEntity.lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty); //kABUIDProperty
        contactEntity.uniqueId = [NSNumber numberWithInteger: ABRecordGetRecordID(person)];
    
        // add new person to event log
        [activityLog addContactsObject:contactEntity];
        
        
        // save new person to 'Real Estate Contacts' group in the local source
        ABAddressBookRef abAddressBookRef = ABAddressBookCreateWithOptions(nil, nil);
    
        // have to 're-get' the person for some reason, otherwise it won't be added to the group
        ABRecordRef abPersonRef = ABAddressBookGetPersonWithRecordID(abAddressBookRef,ABRecordGetRecordID(person));
        
        // get local source, if not get default source
        ABRecordRef abSourceRef = sourceWithType(kABSourceTypeLocal, abAddressBookRef);
        
        if (!abSourceRef)
            abSourceRef = ABAddressBookCopyDefaultSource(abAddressBookRef);
        
        ABRecordRef abGroupRef = getGroup(@"Real Estate Contacts", abSourceRef, abAddressBookRef);
        
        CFErrorRef err = nil;
        if (abPersonRef && abGroupRef)
        {
            //-- add the person to the group
            ABGroupAddMember(abGroupRef, abPersonRef, &err);
            
            //-- save the address book again
            ABAddressBookSave(abAddressBookRef, &err);
        }
        if (err)
        {
            
            CFRelease(err);
        }
               
        if ( abAddressBookRef != NULL )
            CFRelease(abAddressBookRef);
        
        [tableView reloadData];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


BOOL viewPushed;

 - (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
    return YES;
}


- (void)personViewDidClose{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)doneButtonClicked:(id)sender {
    [self.delegate ContactsViewControllerDidCancel:self];
}



ABRecordRef getGroup (NSString *groupName, ABRecordRef sourceRef, ABAddressBookRef addressBook)
{
    CFArrayRef groups = ABAddressBookCopyArrayOfAllGroupsInSource(addressBook, sourceRef);
    CFIndex groupCount = CFArrayGetCount(groups);
    ABRecordRef groupRef = NULL;
    
    for (CFIndex i = 0 ; i < groupCount; i++)
    {
        ABRecordRef currentGroup = CFArrayGetValueAtIndex(groups, i);
        CFTypeRef currentGroupName = ABRecordCopyValue(currentGroup, kABGroupNameProperty);
                
        CFComparisonResult	r = CFStringCompare((CFStringRef) groupName, currentGroupName, 0);
        CFRELEASE_AND_NIL(currentGroupName);
                
        if (r == kCFCompareEqualTo)
        {
            groupRef = currentGroup;
            break;
        }
    }
    
    CFErrorRef err = nil;
	if (!groupRef)
	{
		groupRef = ABGroupCreateInSource(sourceRef);
        ABRecordSetValue(groupRef, kABGroupNameProperty,(__bridge CFTypeRef)(groupName), &err);

		if (!err)
		{
			ABAddressBookAddRecord(addressBook, groupRef, &err);
		}
		if (!err)
		{
			ABAddressBookSave(addressBook, &err);
		}
	}
	if (err)
	{
		CFRelease(err);
	}
            
    return groupRef;
}



ABRecordRef sourceWithType (ABSourceType mySourceType, ABAddressBookRef addressBook)
{
    CFArrayRef sources = ABAddressBookCopyArrayOfAllSources(addressBook);
    CFIndex sourceCount = CFArrayGetCount(sources);
    ABRecordRef resultSource = NULL;
    
    for (CFIndex i = 0 ; i < sourceCount; i++)
    {
        ABRecordRef currentSource = CFArrayGetValueAtIndex(sources, i);
        CFTypeRef sourceType = ABRecordCopyValue(currentSource, kABSourceTypeProperty);
        
        BOOL isMatch = mySourceType == [(__bridge NSNumber *)sourceType intValue];
        CFRELEASE_AND_NIL(sourceType);
        
        if (isMatch) {
            resultSource = currentSource;
            break;
        }
    }
    
    CFRELEASE_AND_NIL(sources);
    
    return resultSource;
}
         

@end
