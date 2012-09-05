//
//  ListingEditViewController.m
//  Agent Assist
//
//  Created by Lubos Hrasko on 2012-09-04.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "ListingEditViewController.h"

@interface ListingEditViewController ()

@end

@implementation ListingEditViewController {}


@synthesize listing;
@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize textListingName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (listing == nil) {
        textListingName.text = nil;
        self.title = @"New Listing";
    } else {
        textListingName.text = listing.name;
        self.title = @"Edit Listing";

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// ----------------
// Action
// ----------------



- (IBAction)CancelButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)SaveButtonPressed:(id)sender {
    
    if (listing == nil){
        listing = (Listing *)[NSEntityDescription insertNewObjectForEntityForName:@"Listing" inManagedObjectContext:managedObjectContext];
    }

    listing.name = textListingName.text;
    [managedObjectContext save:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
