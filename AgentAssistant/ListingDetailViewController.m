//
//  ListingDetailViewController.m
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-08-29.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "ListingDetailViewController.h"
#import "ShowingDetailViewController.h"
#import "OpenHouseViewController.h"
#import "InquiryViewController.h"
#import "Inquiry.h"
#import "Listing.h"
#import "OpenHouse.h"
#import "Showing.h"

@interface ListingDetailViewController ()

@end

@implementation ListingDetailViewController



@synthesize listing;
@synthesize tableView;

@synthesize sections;
@synthesize sortedDays;
@synthesize sectionDateFormatter;
@synthesize cellDateFormatter;

@synthesize managedObjectContext;


-(IBAction)ActionSheetButton {
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Add New..."
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Inquiry",@"Showing",@"Open House", nil];
    
    [actionsheet showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"segueInquiry" sender:self];
    } else if (buttonIndex == 1) {
        [self performSegueWithIdentifier:@"segueShowing" sender:self];
    } else if (buttonIndex == 2) {
        [self performSegueWithIdentifier:@"segueOpenHouse" sender:self];
    }
    
}

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

    
    self.sectionDateFormatter = [[NSDateFormatter alloc] init];
    [self.sectionDateFormatter setDateStyle:NSDateFormatterLongStyle];
    [self.sectionDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.cellDateFormatter = [[NSDateFormatter alloc] init];
    [self.cellDateFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.cellDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    
    self.navigationItem.title = listing.name;
    
}


- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewDidAppear:(BOOL)animated
{
    
    // break up the dates into sections
    self.sections = [NSMutableDictionary dictionary];
        
    for (ActivityLog *log in listing.activityLogs)
    {
        // Reduce event start date to date components (year, month, day)
        NSDate *dateRepresentingThisLog = [self dateAtBeginningOfDayForDate:log.date];
        
        // If we don't yet have an array to hold the events for this day, create one
        NSMutableArray *logsOnThisDay = [self.sections objectForKey:dateRepresentingThisLog];
        if (logsOnThisDay == nil) {
            logsOnThisDay = [NSMutableArray array];
            
            // Use the reduced date as dictionary key to later retrieve the event list this day
            [self.sections setObject:logsOnThisDay forKey:dateRepresentingThisLog];
        }
        
        // Add the event to the list for this day
        [logsOnThisDay addObject:log];
    }
    
    // Create a sorted list of days
    NSArray *unsortedDays = [self.sections allKeys];
    
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: NO];
    self.sortedDays = [unsortedDays sortedArrayUsingDescriptors: [NSArray arrayWithObject:sortOrder]]; //descending
    //self.sortedDays = [unsortedDays sortedArrayUsingSelector:@selector(compare:)];  //ascending
    
    // sort each day's activity by time
    for (NSDate *dateRepresentingThisDay in self.sortedDays)
    {
        NSMutableArray *logsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];

        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:TRUE];
        [logsOnThisDay sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    }
    
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    return [eventsOnThisDay count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    return [self.sectionDateFormatter stringFromDate:dateRepresentingThisDay];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"ActivityCell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
    NSMutableArray *logsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    
    ActivityLog *log = [logsOnThisDay objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellStyleSubtitle;
    cell.textLabel.text = log.label;
    cell.detailTextLabel.text = [self.cellDateFormatter stringFromDate:log.date];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
    NSArray *logsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    ActivityLog *log = [logsOnThisDay objectAtIndex:indexPath.row];
    
    if ( [log isKindOfClass:[Inquiry class]] ) {
        [self performSegueWithIdentifier:@"segueInquiry" sender:log];
    }
    if ( [log isKindOfClass:[Showing class]] ) {
        [self performSegueWithIdentifier:@"segueShowing" sender:log];
    }
    if ( [log isKindOfClass:[OpenHouse class]] ) {
        [self performSegueWithIdentifier:@"segueOpenHouse" sender:log];
    }

}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueShowing"]) {
        ShowingDetailViewController *destViewController = segue.destinationViewController;
        destViewController.managedObjectContext = self.managedObjectContext;
        destViewController.listing = listing;
        if (sender != self) {
            destViewController.editShowing = sender;
        }
    } else if ([segue.identifier isEqualToString:@"segueOpenHouse"]) {
        OpenHouseViewController * destViewController = segue.destinationViewController;
        destViewController.listing = listing;
        if (sender != self) {
            destViewController.editOpenHouse = sender;
        }
    } else if ([segue.identifier isEqualToString:@"segueInquiry"]) {
        InquiryViewController * destViewController = segue.destinationViewController;
        destViewController.managedObjectContext = self.managedObjectContext;
        destViewController.listing = listing;
        if (sender != self) {
            destViewController.editInquiry = sender;
        }
    }
}





@end
