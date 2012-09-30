//
//  ViewController.m
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-08-29.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "ListingsViewController.h"
#import "ActivityLogViewController.h"
#import "ListingViewController.h"
#import "Listing.h"
#import "Showing.h"
#import "Inquiry.h"
#import "OpenHouse.h"
#import "AddNewTableViewCell.h"
#import "AppDelegate.h"
#import "Appirater.h"

@interface ListingsViewController ()

@end

@implementation ListingsViewController { NSMutableArray *listings; }


@synthesize tableView;
@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize  imageLogo;

bool isFirstLoad = YES;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Listings" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


AppDelegate *appDelegate;



-(void)viewWillAppear:(BOOL)animated
{
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Listing" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];

    listings = [[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];

    if (listings.count == 0)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(75,30,60, 60)];
        imgView.tag = 997;
        imgView.alpha = 1;
        UIImage* image = [UIImage imageNamed:@"ListingsPlus_Icon@2x.png"];
        [imgView setImage:image];
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 50, 120, 25)];
        UILabel *headerLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 110, 290, 125)];
        
        
        headerLabel.textAlignment = NSTextAlignmentLeft;
        headerLabel.text = @"LISTINGS+";
        
        headerLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        headerLabel.shadowColor = [UIColor colorWithWhite:1 alpha:1]; // or [UIColor whiteColor];
        headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
        headerLabel.backgroundColor = [UIColor clearColor];
        
        headerLabel2.textAlignment = NSTextAlignmentLeft;
        headerLabel2.text = @"Quickly record an inquiry, schedule a showing and track the success of your open house.\n\nWith Listings+ you can easily log any event, capture contacts, document feedback, schedule calendar appointments -- and keep your clients updated every step of the way!";
        
        headerLabel2.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        headerLabel2.shadowColor = [UIColor colorWithWhite:1 alpha:1]; // or [UIColor whiteColor];
        headerLabel2.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        headerLabel2.numberOfLines = 7;
        headerLabel2.backgroundColor = [UIColor clearColor];
        
        self.tableView.bounces = NO;
        
        headerLabel.tag = 998;
        headerLabel2.tag = 999;
        
        [self.view addSubview:headerLabel];
        [self.view addSubview:headerLabel2];
        [self.view addSubview:imgView];
        
        UIEdgeInsets inset = UIEdgeInsetsMake(tableView.frame.size.height, 0, 0, 0);
        self.tableView.contentInset = inset;
        self.title = @"Welcome";
        

      }
    else
    {
        UIView *v = [self.view viewWithTag:997];
        UIView *h1 = [self.view viewWithTag:998];
        UIView *h2 = [self.view viewWithTag:999];

        v.hidden = YES;
        h1.hidden = YES;
        h2.hidden = YES;
        
        [self.view bringSubviewToFront:v];
        [v removeFromSuperview];
        [h1 removeFromSuperview];
        [h2 removeFromSuperview];
        
        self.tableView.bounces = YES;

        
        UIEdgeInsets inset = UIEdgeInsetsMake(10, 0, 0, 0);
        self.tableView.contentInset = inset;
        self.title = @"Listings+";

    }

    if (isFirstLoad == NO)
        [self.tableView reloadData];
    else
        isFirstLoad = NO;
        
}


-(void)viewDidAppear:(BOOL)animated
{
    
    // fix settings button
    //settingBarButton.title = @"\u2699"; UIFont *f1 = [UIFont fontWithName:@"Helvetica" size:24.0]; NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:f1, UITextAttributeFont, nil]; [settingBarButton setTitleTextAttributes:dict forState:UIControlStateNormal];
           
}





- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}






// Customize the number of rows in the table view - FOR ADD NEW ROW
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if (section == 1)
        return 1;
    
    return listings.count;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0 && listings.count == 0)
    {
        
        UIEdgeInsets inset = UIEdgeInsetsMake(tableView.frame.size.height / 2 + 50, 0, 0, 0);
        self.tableView.contentInset = inset;
    }
    return nil;

  }




-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0 && listings.count > 0)
        return @"Listings";
    
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
        cell.textLabel.textColor = [UIColor colorWithRed:0.19607843 green:0.30980392 blue:0.52156863 alpha:1];

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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.tag =0;
        return cell;
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}



- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0)
        [self performSegueWithIdentifier:@"segueActivityLog" sender:self];
    else
    {
        tagEdit = 0;
        [self performSegueWithIdentifier:@"segueListing" sender:self];
    }
}


int accessoryButtonRow;
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    tagEdit = 1;
    accessoryButtonRow = indexPath.row;
    [self performSegueWithIdentifier:@"segueListing" sender:self];
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
    if ([segue.identifier isEqualToString:@"segueListing"]) {
        ListingViewController *destViewController = segue.destinationViewController;
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



- (IBAction)addListingButtonPressed:(id)sender {
    tagEdit = 0;
    [self performSegueWithIdentifier:@"segueListing" sender:self];
}


- (IBAction)rateAppButtonPressed:(id)sender {
    [Appirater rateApp];
}


@end