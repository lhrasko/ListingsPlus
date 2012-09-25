//
//  SourceTableViewController.h
//  Agent Assist
//
//  Created by Lubos Hrasko on 2012-09-06.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityLog.h"

@class SourceTableViewController;

@protocol SourceTableViewControllerDelegate <NSObject>
- (void)SourceTableViewControllerDidCancel:(SourceTableViewController *)controller;
- (void)SourceTableViewControllerDidSave:(SourceTableViewController *)controller source:(NSString *)source;
@end


@interface SourceTableViewController : UITableViewController


@property (nonatomic, weak) id <SourceTableViewControllerDelegate> delegate;

@property (nonatomic, retain) ActivityLog *activityLog;

@property (nonatomic, retain) NSMutableArray *tableView1Data;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)cancelButtonPressed:(id)sender;

@end
