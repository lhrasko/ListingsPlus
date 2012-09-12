//
//  ContactListTableViewController.m
//  Realtor Assist
//
//  Created by Lubos Hrasko on 2012-09-08.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "ContactListTableViewController.h"
#import "ABContact.h"
#import "ABContactsHelper.h"

@interface ContactListTableViewController ()

@end

@implementation ContactListTableViewController {
    NSMutableArray *cont;
}

@synthesize sections;
@synthesize sortedLetters;

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
  
    // create the array to hold the buttons, which then gets added to the toolbar
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    
    // create a standard "done" button
    UIBarButtonItem* bi = [[UIBarButtonItem alloc]
          initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(refresh:)];
    bi.style = UIBarButtonItemStyleBordered;
    [buttons addObject:bi];

    // create a spacer
    bi = [[UIBarButtonItem alloc]
          initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [buttons addObject:bi];

    // create a standard "add" button
    bi = [[UIBarButtonItem alloc]
                           initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:NULL];
    bi.style = UIBarButtonItemStyleBordered;
    [buttons addObject:bi];

       
    self.navigationItem.rightBarButtonItems = buttons;
    
    
    ABContactsHelper *helper = [ABContactsHelper alloc];
  
    
    //ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, nil);
    //CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    //CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(kCFAllocatorDefault,CFArrayGetCount(people),people);
    //CFArraySortValues(peopleMutable,CFRangeMake(0, CFArrayGetCount(peopleMutable)),(CFComparatorFunction) ABPersonComparePeopleByName,(void*) ABPersonGetSortOrdering());
    
    
    // break up the contacts into sections
    sections = [NSMutableDictionary dictionary];
    
    for (ABContact *contact in ABContactsHelper.contacts)
    {
        // Get the letter abbreviating this contact
        NSString *letterRepresentingThisContact = [contact.compositeName substringToIndex:1];
        
        // If we don't yet have an array to hold the events for this day, create one
        NSMutableArray *contactForThisLetter = [sections objectForKey:letterRepresentingThisContact];
        if (contactForThisLetter == nil) {
            contactForThisLetter = [NSMutableArray array];
            
            @try
            {
            // Use the letter as dictionary key to later retrieve the contact list for this letter
            [sections setObject:contactForThisLetter forKey:letterRepresentingThisContact];
            }
            @catch (NSException * e)
            {
                NSLog(@"Exception: %@", e);
            }
        }
        
        // Add the contact to the list for this letter
        [contactForThisLetter addObject:contact];
    }

    // Create a sorted list of contacts
    NSArray *unsortedLetters = [sections allKeys];
    
    sortedLetters = [unsortedLetters sortedArrayUsingSelector:@selector(compare:)];  //ascending
    
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
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *letter = [sortedLetters objectAtIndex:section];
    NSArray *contactsForLetter = [sections objectForKey:letter];
    return [contactsForLetter count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDate *letter = [sortedLetters objectAtIndex:indexPath.section];
    NSMutableArray *contactsForThisLetter = [sections objectForKey:letter];
    
    ABContact *contact = [contactsForThisLetter objectAtIndex:indexPath.row];
    cell.textLabel.text = contact.compositeName;
    return cell;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return sortedLetters;
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return nil;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sortedLetters objectAtIndex:section];
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
    
    static NSString *CellIdentifier = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
