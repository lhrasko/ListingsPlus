//
//  ViewController.m
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-08-29.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "ListingsViewController.h"
#import "ListingDetailViewController.h"
#import "ListingEditViewController.h"
#import "Listing.h"
#import "Showing.h"
#import "Inquiry.h"
#import "OpenHouse.h"

@interface ListingsViewController ()

@end

@implementation ListingsViewController {
    NSMutableArray *listings;
}

@synthesize tableView;
@synthesize fetchedResultsController;
@synthesize managedObjectContext;


- (void)viewDidLoad
{
    [super viewDidLoad];
 
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(EditTable:)];
    [self.navigationItem setLeftBarButtonItem:addButton];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



-(void)viewDidAppear:(BOOL)animated
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Listing" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];

    
    listings = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



// Determine whether a given row is eligible for reordering or not.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


// Process the row move. This means updating the data model to correct the item indices.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath {
    NSString *item = [listings objectAtIndex:fromIndexPath.row];
    [listings removeObject:item];
    [listings insertObject:item atIndex:toIndexPath.row];
}


// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [listings removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        Listing *newListing = [Listing new];
        newListing.name = @"New Listing";
        [listings insertObject:newListing atIndex:[listings count]];
        [tableView reloadData];
    }
}


// Customize the number of rows in the table view - FOR ADD NEW ROW
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = [listings count];
    if(self.editing) count++;
    return count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ListingCell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [UITableViewCell alloc];
    }
    int count = 0;
    if(self.editing && indexPath.row != 0)
        count = 1;
    // Set up the cell...
    if(indexPath.row == ([listings count]) && self.editing)
    {
        cell.textLabel.text = @"Add New Listing";
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    
    Listing *listing = [listings objectAtIndex:indexPath.row];
    cell.textLabel.text = listing.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // No editing style if not editing or the index path is nil.
    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    // Determine the editing style based on whether the cell is a placeholder for adding content or already
    // existing content. Existing content can be deleted.
    if (self.editing && indexPath.row == ([listings count])) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}


- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editing == NO) {
        [self performSegueWithIdentifier:@"segueActivityLog" sender:self];
    }
    else {
        tagEdit = 1;
        [self performSegueWithIdentifier:@"segueEditNewListing" sender:self];
    }

}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueActivityLog"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ListingDetailViewController *destViewController = segue.destinationViewController;
        destViewController.managedObjectContext = self.managedObjectContext;
        Listing *listing = [listings objectAtIndex:indexPath.row];
        destViewController.listing = listing;
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if ([segue.identifier isEqualToString:@"segueEditNewListing"]) {
        ListingEditViewController *destViewController = segue.destinationViewController;
        destViewController.managedObjectContext = self.managedObjectContext;
        
        if (tagEdit == 1)
        {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            Listing *listing = [listings objectAtIndex:indexPath.row];
            destViewController.listing = listing;
            [self EditTable:self];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        
    }
}




// ----------------
// Action
// ----------------

int tagEdit;

// called by the 'Edit' or 'Done' button to toggle edit on and off
- (IBAction)AddListingButtonClick:(id)sender {
    tagEdit = 0;
    [self performSegueWithIdentifier:@"segueEditNewListing" sender:self];
}


- (IBAction) EditTable:(id)sender{
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [tableView setEditing:NO animated:NO];
        [tableView reloadData];
        [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [tableView setEditing:YES animated:YES];
        [tableView reloadData];
        [self.navigationItem.leftBarButtonItem setTitle:@"Done"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}



@end