//
//  ListingEditViewController.h
//  Agent Assist
//
//  Created by Lubos Hrasko on 2012-09-04.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"

@interface ListingEditViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property (nonatomic, strong) Listing *listing;

- (IBAction)CancelButtonPressed:(id)sender;
- (IBAction)SaveButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textListingName;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedButton;
@end
