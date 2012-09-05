//
//  InquiryViewController.h
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-08-30.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"
#import "Inquiry.h"

@interface InquiryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate> {
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property (nonatomic, strong) Listing *listing;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Inquiry *editInquiry;

@property (nonatomic, retain) NSMutableArray *tableView1Data;

-(IBAction)SaveButtonPressed:(id)sender;
-(IBAction)CancelButtonPressed;


@end
