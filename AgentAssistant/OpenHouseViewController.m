//
//  OpenHouseViewController.m
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-09-02.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "OpenHouseViewController.h"
#import "NoteViewController.h"

@interface OpenHouseViewController ()

@end

@implementation OpenHouseViewController

@synthesize listing;
@synthesize editOpenHouse;
@synthesize tableView1Data;


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
    
    self.tableView1Data = [NSMutableArray array];

    // ----------------------------;
    // Table View Section -> tableViewSection1;
    // ----------------------------;
    
    NSMutableDictionary *tableViewSection1Data = [NSMutableDictionary dictionary];
    [tableViewSection1Data setObject:@"Date and Time" forKey:@"headerText"];
    [tableViewSection1Data setObject:@"" forKey:@"footerText"];
    [tableViewSection1Data setObject:[NSMutableArray array] forKey:@"cells"];
    [self.tableView1Data addObject:tableViewSection1Data];
    
    // ----------------------------;
    // Cell -> tableViewCell1;
    // ----------------------------;
    
    NSMutableDictionary *tableViewCell1Data = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] ;
    tableViewCell1.textLabel.text = @"Date";
    tableViewCell1.detailTextLabel.text = @"January 14, 2013";
    tableViewCell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [tableViewCell1Data setObject:tableViewCell1 forKey:@"cell"];
    [tableViewCell1Data setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCell1Data setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    [tableViewCell1Data setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCell1Data setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewSection1Data objectForKey:@"cells"] addObject:tableViewCell1Data];
    [tableViewCell1Data setObject:@"didTap_tableViewCell1:" forKey:@"actionSelector"];
    
    // ----------------------------;
    // Cell -> tableViewCell2;
    // ----------------------------;
    
    NSMutableDictionary *tableViewCell2Data = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] ;
    tableViewCell2.textLabel.text = @"Start Time";
    tableViewCell2.detailTextLabel.text = @"2:00 PM";
    tableViewCell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [tableViewCell2Data setObject:tableViewCell2 forKey:@"cell"];
    [tableViewCell2Data setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCell2Data setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    [tableViewCell2Data setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCell2Data setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewSection1Data objectForKey:@"cells"] addObject:tableViewCell2Data];
    [tableViewCell2Data setObject:@"didTap_tableViewCell2:" forKey:@"actionSelector"];
    
    // ----------------------------;
    // Cell -> tableViewCell3;
    // ----------------------------;
    
    NSMutableDictionary *tableViewCell3Data = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCell3 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] ;
    tableViewCell3.textLabel.text = @"End Time";
    tableViewCell3.detailTextLabel.text = @"4:00 PM";
    tableViewCell3.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [tableViewCell3Data setObject:tableViewCell3 forKey:@"cell"];
    [tableViewCell3Data setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCell3Data setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    [tableViewCell3Data setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCell3Data setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewSection1Data objectForKey:@"cells"] addObject:tableViewCell3Data];
    [tableViewCell3Data setObject:@"didTap_tableViewCell3:" forKey:@"actionSelector"];
    
    // ----------------------------;
    // Table View Section -> tableViewSection2;
    // ----------------------------;
    
    NSMutableDictionary *tableViewSection2Data = [NSMutableDictionary dictionary];
    [tableViewSection2Data setObject:@"Optional" forKey:@"headerText"];
    [tableViewSection2Data setObject:@"" forKey:@"footerText"];
    [tableViewSection2Data setObject:[NSMutableArray array] forKey:@"cells"];
    [self.tableView1Data addObject:tableViewSection2Data];
    
    // ----------------------------;
    // Custom Cell -> tableViewCell4;
    // ----------------------------;
    
    NSMutableDictionary *tableViewCell4Data = [NSMutableDictionary dictionary];
    UIView *tableViewCell4CustomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 59)] ;
    tableViewCell4CustomView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UITableViewCell *tableViewCell4 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] ;
    tableViewCell4.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [tableViewCell4Data setObject:tableViewCell4 forKey:@"cell"];
    [tableViewCell4Data setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCell4Data setObject:[NSNumber numberWithFloat:60] forKey:@"height"];
    [tableViewCell4Data setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewSection2Data objectForKey:@"cells"] addObject:tableViewCell4Data];
    
    // ----------------------------;
    // UIStepper -> stepper1;
    // ----------------------------;
    
    UIStepper *stepper1 = [[UIStepper alloc] initWithFrame:CGRectMake(136, 16, 0, 0)];
    [tableViewCell4CustomView addSubview:stepper1];
    stepper1.alpha = 1.0;
    stepper1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    stepper1.value = 0;
    stepper1.maximumValue = 100;
    stepper1.minimumValue = 0;
    
    
    // ----------------------------;
    // UILabel -> label1;
    // ----------------------------;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 59)];
    [tableViewCell4CustomView addSubview:label1];
    label1.alpha = 1.0;
    label1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    label1.text = @"Visitors";
    label1.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    label1.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.shadowOffset = CGSizeMake(0, -1);
    label1.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
    
    // ----------------------------;
    // UILabel -> label2;
    // ----------------------------;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 70, 59)];
    [tableViewCell4CustomView addSubview:label2];
    label2.alpha = 1.0;
    label2.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    label2.text = @"4";
    label2.textColor = [UIColor colorWithRed:0.0 green:0.25 blue:0.5 alpha:1.0];
    label2.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    label2.textAlignment = NSTextAlignmentRight;
    label2.shadowOffset = CGSizeMake(0, -1);
    label2.font = [UIFont fontWithName:@".HelveticaNeueUI" size:17.0];
    
    tableViewCell4CustomView.frame = tableViewCell4.contentView.bounds;
    [tableViewCell4.contentView addSubview:tableViewCell4CustomView];
    
    // ----------------------------;
    // Cell -> tableViewCell5;
    // ----------------------------;
    
    NSMutableDictionary *tableViewCell5Data = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCell5 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] ;
    tableViewCell5.textLabel.text = @"Note";
    tableViewCell5.detailTextLabel.text = @"Subtitle";
    tableViewCell5.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [tableViewCell5Data setObject:tableViewCell5 forKey:@"cell"];
    [tableViewCell5Data setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCell5Data setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    [tableViewCell5Data setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCell5Data setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewSection2Data objectForKey:@"cells"] addObject:tableViewCell5Data];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// ----------------
// Table View
// ----------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 1) {;
        return self.tableView1Data.count;
    };
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1) {;
        NSDictionary *sectionData = [self.tableView1Data objectAtIndex:section];
        return [[sectionData objectForKey:@"cells"] count];
    };
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {;
        NSDictionary *sectionData = [self.tableView1Data objectAtIndex:indexPath.section];
        NSDictionary *cellData =  [[sectionData objectForKey:@"cells"] objectAtIndex:indexPath.row];
        return [cellData objectForKey:@"cell"];
    };
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] ;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 1) {;
        NSDictionary *sectionData = [self.tableView1Data objectAtIndex:section];
        return [sectionData objectForKey:@"headerText"];
    };
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (tableView.tag == 1) {;
        NSDictionary *sectionData = [self.tableView1Data objectAtIndex:section];
        return [sectionData objectForKey:@"footerText"];
    };
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {;
        NSDictionary *sectionData = [self.tableView1Data objectAtIndex:indexPath.section];
        NSDictionary *cellData =  [[sectionData objectForKey:@"cells"] objectAtIndex:indexPath.row];
        return [[cellData objectForKey:@"height"] floatValue];
    };
    
    return tableView.rowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 1) {;
        NSDictionary *sectionData = [self.tableView1Data objectAtIndex:section];
        if ([[sectionData objectForKey:@"customHeaderView"] boolValue]) {;
            return [sectionData objectForKey:@"headerView"];
        } else {;
            return nil;
        };
    };
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView.tag == 1) {;
        NSDictionary *sectionData = [self.tableView1Data objectAtIndex:section];
        if ([[sectionData objectForKey:@"customFooterView"] boolValue]) {;
            return [sectionData objectForKey:@"footerView"];
        } else {;
            return nil;
        };
    };
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 1) {;
        NSDictionary *sectionData = [self.tableView1Data objectAtIndex:section];
        if ([[sectionData objectForKey:@"customHeaderView"] boolValue]) {;
            return [[sectionData objectForKey:@"customHeaderViewHeight"] floatValue];
        } else {;
            if (![[sectionData objectForKey:@"headerText"] isEqualToString:@""]) {;
                return 32;
            } else {;
                return 0;
            };
        };
    };
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView.tag == 1) {;
        NSDictionary *sectionData = [self.tableView1Data objectAtIndex:section];
        if ([[sectionData objectForKey:@"customFooterView"] boolValue]) {;
            return [[sectionData objectForKey:@"customFooterViewHeight"] floatValue];
        } else {;
            if (![[sectionData objectForKey:@"footerText"] isEqualToString:@""]) {;
                return 32;
            } else {;
                return 0;
            };
        };
    };
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {;
        NSDictionary *sectionData = [self.tableView1Data objectAtIndex:indexPath.section];
        NSDictionary *cellData =  [[sectionData objectForKey:@"cells"] objectAtIndex:indexPath.row];
        return [[cellData objectForKey:@"indentationLevel"] integerValue];
    };
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {;
        NSDictionary *sectionData = [self.tableView1Data objectAtIndex:indexPath.section];
        NSDictionary *cellData =  [[sectionData objectForKey:@"cells"] objectAtIndex:indexPath.row];
        NSString *actionSelector = [cellData objectForKey:@"actionSelector"];
        if (actionSelector) {;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [self performSelector:NSSelectorFromString(actionSelector) withObject:cell];
        };
    };
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}






- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueNotes"]) {
        NoteViewController *destViewController = segue.destinationViewController;
        //destViewController.activityLog = open;
    }
}




// ----------------
// Action
// ----------------

- (void)CancelButtonPressed:(id)sender  {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)SaveButtonPressed:(id)sender {
    OpenHouse *log1 = [OpenHouse new];
    log1.CreatedDate = [NSDate date];
    log1.date = [NSDate date];
    [listing.activityLogs  addObject:log1];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
