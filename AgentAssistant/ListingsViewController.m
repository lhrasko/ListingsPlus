//
//  ViewController.m
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-08-29.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "ListingsViewController.h"
#import "ActivityLogViewController.h"
#import "ListingEditViewController.h"
#import "Listing.h"
#import "Showing.h"
#import "Inquiry.h"
#import "OpenHouse.h"
#import "AddNewTableViewCell.h"
#import "AppDelegate.h"

@interface ListingsViewController ()

@end

@implementation ListingsViewController {
    NSMutableArray *listings;
}

@synthesize tableView;
@synthesize fetchedResultsController;

bool hasLoaded = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


AppDelegate *appDelegate;


-(void)viewDidAppear:(BOOL)animated
{
    
    // fix settings button
    //settingBarButton.title = @"\u2699"; UIFont *f1 = [UIFont fontWithName:@"Helvetica" size:24.0]; NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:f1, UITextAttributeFont, nil]; [settingBarButton setTitleTextAttributes:dict forState:UIControlStateNormal];

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Listing" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];

    listings = [[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    hasLoaded = YES;
    [self.tableView reloadData];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}






// Customize the number of rows in the table view - FOR ADD NEW ROW
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if (hasLoaded)
    {
    if (section == 1)
        return 1;
    
    return listings.count;
    }
    else
        return 0;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0 && listings.count > 0)
        return @"Current Listings";
    
    if (section == 1 && listings.count == 0)
        return @"Get Started";
    
    return nil;
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Set up the cell...
    if(indexPath.section == 1)
    {
        static NSString *CellIdentifier = @"AddRowCell";
        
        UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [UITableViewCell alloc];
        }
        cell.textLabel.text = @"Add New Listing";

        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [button addTarget:self action:@selector(buttonTapped:event:) forControlEvents:  UIControlEventTouchUpInside];
        //and created the event handling procedure - (void)buttonTapped:(id)sender event:(id)event { }
        cell.accessoryView = button;
       
        return cell;
    }
    else
    {
    
        static NSString *CellIdentifier = @"ListingCell";
    
        UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [UITableViewCell alloc];
        }

        Listing *listing = [listings objectAtIndex:indexPath.row];
        cell.textLabel.text = listing.name;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.tag =0;
        return cell;
    }
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (hasLoaded)
        return 2;
    else
        return 0;
}



- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0)
        [self performSegueWithIdentifier:@"segueActivityLog" sender:self];
    else
    {
        tagEdit = 0;
        [self performSegueWithIdentifier:@"segueEditNewListing" sender:self];
    }
}


int accessoryButtonRow;
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    tagEdit = 1;
    accessoryButtonRow = indexPath.row;
    [self performSegueWithIdentifier:@"segueEditNewListing" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        
    if ([segue.identifier isEqualToString:@"segueActivityLog"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ActivityLogViewController *destViewController = segue.destinationViewController;
        destViewController.managedObjectContext = appDelegate.managedObjectContext;
        Listing *listing = [listings objectAtIndex:indexPath.row];
        destViewController.listing = listing;
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if ([segue.identifier isEqualToString:@"segueEditNewListing"]) {
        ListingEditViewController *destViewController = segue.destinationViewController;
        destViewController.managedObjectContext = appDelegate.managedObjectContext;
        
        if (tagEdit == 1)
        {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            Listing *listing = [listings objectAtIndex:accessoryButtonRow];
            destViewController.listing = listing;
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        
    }
}




int tagEdit;



@end