//
//  OpenHouseViewController.h
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-08-30.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenHouse.h"
#import "Listing.h"


@interface OpenHouseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, strong) Listing *listing;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) OpenHouse *editOpenHouse;

@property (nonatomic, retain) NSMutableArray *tableView1Data;

-(IBAction)SaveButtonPressed:(id)sender;
-(IBAction)dateDetailButtonPressed;
-(IBAction)CancelButtonPressed:(id)sender;


@end