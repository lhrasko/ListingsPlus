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



-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0 && activityLog.contacts.count > 0)
        return @"Linked People";
    
    if (section == 1 && activityLog.contacts.count == 0)
        return @"Link People to this Event" ;
    
    
    if (section == 1 && activityLog.contacts.count > 0)
        return @"More Options" ;
    
    return nil;
    
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
        cell.textLabel.text = @"Choose from Address Book";
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
    if (indexPath.section == 0)
    {
        NSMutableArray *contacts = [[activityLog.contacts allObjects] mutableCopy];
        Contact *contact = [contacts objectAtIndex:indexPath.row];
        
        ABPersonViewController *personController = [[ABPersonViewController alloc] initWithNibName:@"ABPersonViewController" bundle:nil];

        personController.personViewDelegate = self;
        
        ABAddressBookRef ab = ABAddressBookCreate();
        ABRecordRef person = ABAddressBookGetPersonWithRecordID(ab,contact.uniqueId.integerValue);
        personController.displayedPerson = person; // Assume person is already defined.
        personController.allowsEditing = true;
        personController.allowsActions = true;
        personController.modalPresentationStyle = UIModalTransitionStylePartialCurl;
        
        UINavigationController *newNavigationController = [[UINavigationController alloc] initWithRootViewController:personController];
        newNavigationController.navigationItem.backBarButtonItem.title = @"Cancel";
        newNavigationController.navigationBar.topItem.title = @"Edit Contact";
        newNavigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel",nil) style:UIBarButtonItemStyleDone target:self action:@selector(personViewDidClose)];

        [self presentModalViewController:newNavigationController animated:YES];
    }
}



- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissModalViewControllerAnimated:YES];
}


- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    // a contact was picked
    
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
        ABAddressBookRef addressBook = ABAddressBookCreate();
        
        // get local source, if not get default source
        ABRecordRef sourceToUse = localSource();
        if (!sourceToUse)
            sourceToUse = ABAddressBookCopyDefaultSource(addressBook);
        
        ABRecordRef group = getGroup(sourceToUse);
        
        CFErrorRef err = nil;
        if (person && group)
        {
            ABGroupAddMember(group, person, &err);
            if (!err)
            {
                ABAddressBookSave(addressBook, &err);
            }
        }
        if (err)
        {
            
            CFRelease(err);
        }
        
        CFRELEASE_AND_NIL(addressBook);
        CFRELEASE_AND_NIL(sourceToUse);
        CFRELEASE_AND_NIL(group);
        
        [tableView reloadData];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}


- (void)personViewDidClose{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)doneButtonClicked:(id)sender {
    [self.delegate ContactsViewControllerDidCancel:self];
}



ABRecordRef getGroup (ABRecordRef sourceRef)
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef groups = ABAddressBookCopyArrayOfAllGroupsInSource(addressBook, sourceRef);
    CFIndex groupCount = CFArrayGetCount(groups);
    ABRecordRef groupRef = NULL;
    for (CFIndex i = 0 ; i < groupCount; i++)
    {
        ABRecordRef currentGroup = CFArrayGetValueAtIndex(groups, i);
        CFTypeRef groupName = ABRecordCopyValue(currentGroup, kABGroupNameProperty);
                
        CFComparisonResult	r = CFStringCompare((CFStringRef)@"Real Estate Contacts", groupName, 0);
        CFRELEASE_AND_NIL(groupName);
                
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
		ABRecordSetValue(groupRef, kABGroupNameProperty, @"Real Estate Contacts", &err);
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
            
    CFRELEASE_AND_NIL(addressBook);
    CFRELEASE_AND_NIL(groups);
            
    return groupRef;
}



#define CFRELEASE_AND_NIL(x) CFRelease(x); x=nil;
ABRecordRef sourceWithType (ABSourceType mySourceType)
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef sources = ABAddressBookCopyArrayOfAllSources(addressBook);
    CFIndex sourceCount = CFArrayGetCount(sources);
    ABRecordRef resultSource = NULL;
    for (CFIndex i = 0 ; i < sourceCount; i++) {
        ABRecordRef currentSource = CFArrayGetValueAtIndex(sources, i);
        CFTypeRef sourceType = ABRecordCopyValue(currentSource, kABSourceTypeProperty);
        
        BOOL isMatch = mySourceType == [(__bridge NSNumber *)sourceType intValue];
        CFRELEASE_AND_NIL(sourceType);
        
        if (isMatch) {
            resultSource = currentSource;
            break;
        }
    }
    
    CFRELEASE_AND_NIL(addressBook);
    CFRELEASE_AND_NIL(sources);
    
    return resultSource;
}
         

ABRecordRef localSource()
{
    return sourceWithType(kABSourceTypeLocal);
}

ABRecordRef exchangeSource()
{
    return sourceWithType(kABSourceTypeExchange);
}

ABRecordRef mobileMeSource()
{
    return sourceWithType(kABSourceTypeMobileMe);
}




@end
