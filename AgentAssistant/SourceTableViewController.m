//
//  SourceTableViewController.m
//  Agent Assist
//
//  Created by Lubos Hrasko on 2012-09-06.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "SourceTableViewController.h"

@interface SourceTableViewController ()

@end

@implementation SourceTableViewController

@synthesize tableView1Data;
@synthesize tableView;
@synthesize activityLog;
@synthesize delegate;

NSString *selectedSource;
NSString *checkValued;
NSArray *sourcesArray;


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
    
    sourcesArray = [NSArray arrayWithObjects:@"Real Estate Agent", @"Existing Customer", @"Sign Call", @"Online Classifieds", @"Web Site", @"Open House", @"Neighborhood Notice", @"Newspaper", @"Magazine", nil];
    checkValued = activityLog.source;
    
    self.tableView1Data = [NSMutableArray array];
    
    
    // ----------------------------;
    // Table View Section -> Source
    // ----------------------------;
    
    NSMutableDictionary *tableViewSectionSourceData = [NSMutableDictionary dictionary];
    [tableViewSectionSourceData setObject:@"Source" forKey:@"headerText"];
    [tableViewSectionSourceData setObject:@"" forKey:@"footerText"];
    [tableViewSectionSourceData setObject:[NSMutableArray array] forKey:@"cells"];
    [self.tableView1Data addObject:tableViewSectionSourceData];

    
    // ----------------------------;
    // Table View Section > Source > Cells
    // ----------------------------;
    
    for (NSString *source in sourcesArray)
    {
        NSMutableDictionary *tableViewCellData = [NSMutableDictionary dictionary];
        UITableViewCell *tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        tableViewCell.textLabel.text = source;
        tableViewCell.tag = 1;
        
        [tableViewCellData setObject:tableViewCell forKey:@"cell"];
        [tableViewCellData setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
        [tableViewCellData setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
        [tableViewCellData setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
        [tableViewCellData setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
        [[tableViewSectionSourceData objectForKey:@"cells"] addObject:tableViewCellData];
    }
    

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sectionData = [self.tableView1Data objectAtIndex:section];
    return [[sectionData objectForKey:@"cells"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sectionData = [self.tableView1Data objectAtIndex:indexPath.section];
    NSDictionary *cellData =  [[sectionData objectForKey:@"cells"] objectAtIndex:indexPath.row];
    
    UITableViewCell *cellToCheck = [cellData objectForKey:@"cell"];
    
    if ([cellToCheck.textLabel.text isEqualToString:checkValued])
    {
        cellToCheck.accessoryType = UITableViewCellAccessoryCheckmark;
        selectedSource = cellToCheck.textLabel.text;
        cellToCheck.textLabel.textColor = [UIColor colorWithRed:0.19607843 green:0.30980392 blue:0.52156863 alpha:1];
    }
    else
    {
        cellToCheck.accessoryType = UITableViewCellAccessoryNone;
        cellToCheck.textLabel.textColor = [UIColor blackColor];
    }
    
    activityLog.source = selectedSource;
	[self.delegate SourceTableViewControllerDidSave:self source:selectedSource];
    
    return cellToCheck;
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
    NSDictionary *sectionData = [self.tableView1Data objectAtIndex:indexPath.section];
    NSDictionary *cellData =  [[sectionData objectForKey:@"cells"] objectAtIndex:indexPath.row];
    
    UITableViewCell *cellToCheck = [cellData objectForKey:@"cell"];
    
    checkValued = cellToCheck.textLabel.text;
    [self.tableView reloadData];
}


- (IBAction)cancelButtonPressed:(id)sender {
   	[self.delegate SourceTableViewControllerDidCancel:self];}


@end
