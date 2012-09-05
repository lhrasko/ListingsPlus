//
//  ShowingDetailViewController.h
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-08-30.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"
#import "Inquiry.h"

@interface ShowingDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property (nonatomic, strong) Listing *listing;

@property (nonatomic, retain) NSMutableArray *tableView1Data;

-(IBAction)SaveButtonPressed:(id)sender;
-(IBAction)dateDetailButtonPressed;
-(IBAction)CancelButtonPressed;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Inquiry *editShowing;


@end
