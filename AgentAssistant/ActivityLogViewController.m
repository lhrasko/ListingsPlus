//
//  ListingDetailViewController.m
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-08-29.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "ActivityLogViewController.h"
#import "ShowingDetailViewController.h"
#import "OpenHouseViewController.h"
#import "CustomEventViewController.h"
#import "InquiryViewController.h"
#import "Inquiry.h"
#import "Listing.h"
#import "OpenHouse.h"
#import "Showing.h"
#import "Contact.h"
#import <MessageUI/MessageUI.h>

@interface ActivityLogViewController ()

@end

@implementation ActivityLogViewController



@synthesize listing;
@synthesize tableView;

@synthesize sections;
@synthesize sortedDays;
@synthesize sectionDateFormatter;
@synthesize cellDateFormatter;

@synthesize managedObjectContext;

NSUInteger sortedEventCount;

-(IBAction)ActionSheetButton {
    
    UIActionSheet *actionsheetDate = [[UIActionSheet alloc]
                                  initWithTitle:@"Add New..."
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Inquiry",@"Showing",@"Open House", @"Custom Event", nil];
    
    [actionsheetDate showInView:self.view];
}

- (IBAction)sendMessageButtonPressed:(id)sender {
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    NSMutableString *subject = [[NSMutableString alloc] initWithString: @"Listing Activity Report for "];
    [subject appendString:listing.name];
    
    [picker setSubject:subject];
    
    
    // Set up the recipients.
    for (Contact *contact in listing.contacts) {
        NSArray *toRecipients = [NSArray arrayWithObjects:contact.compositeName,nil];
        [picker setToRecipients:toRecipients];
    }
    
    
    NSMutableString *emailBody = [[NSMutableString alloc] initWithString: @"Attached is the latest update detailing the activity on your listing: <br/>"];
    NSMutableDictionary *events = [self sortEventsWeek];

    NSArray *allKeys = [events allKeys];
    NSArray *ascSortedEvents = [allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSArray *sortedEvents = [[ascSortedEvents reverseObjectEnumerator] allObjects];

    
    [emailBody appendString:@"<h4>STATISTICS</h4>"];
    
    [emailBody appendString:@"<table border='1' style='margin-top: 10px; margin-bottom: 10px;'><tr style='font-size:xx-small'><th>Week</th><th align='center'>Inquries</th><th align='center'>Showings</th><th align='center'>Open Houses</th><th align='center'>Open House Visitors</th><tr>"];

    
    for (NSDate *weekKey in sortedEvents)
    {
        
        NSMutableDictionary *labelsForWeek = [events objectForKey:weekKey];

        [emailBody appendString:@"<tr><td align='center'>"];
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateStyle:NSDateFormatterShortStyle];
        [df setTimeStyle:NSDateFormatterNoStyle];

        [emailBody appendString:[df stringFromDate:weekKey]];
        [emailBody appendString:@"</td><td align='center'>"];
        
        NSNumber *showings = [labelsForWeek objectForKey:@"Showing"];
        NSNumber *inquiries = [labelsForWeek objectForKey:@"Inquiry"];
        NSNumber *openhouse = [labelsForWeek objectForKey:@"Open House"];
        NSNumber *openhousevisitors = [labelsForWeek objectForKey:@"OpenHouseVisitors"];
        
        if (inquiries != nil)
            [emailBody appendString:[inquiries stringValue]];
        else
            [emailBody appendString:@"0"];
        [emailBody appendString:@"</td><td align='center'>"];
        
        if (showings != nil)
            [emailBody appendString:[showings stringValue]];
        else
            [emailBody appendString:@"0"];
        [emailBody appendString:@"</td><td align='center'>"];

        if (openhouse != nil)
            [emailBody appendString:[openhouse stringValue]];
        else
            [emailBody appendString:@"0"];
        [emailBody appendString:@"</td><td align='center'>"];

        if (openhousevisitors != nil)
            [emailBody appendString:[openhousevisitors stringValue]];
        else
            [emailBody appendString:@"0"];

                
        [emailBody appendString:@"</td></tr>"];
                
              

    }
    
    [emailBody appendString:@"</table>"];
    
    
    [emailBody appendString:@"<h4>FEEDBACK</h4>"];

    
    for (NSDate *weekKey in sortedEvents)
    {
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateStyle:NSDateFormatterShortStyle];
        [df setTimeStyle:NSDateFormatterNoStyle];
        
        NSMutableDictionary *labelsForWeek = [events objectForKey:weekKey];
    
        bool weeklyFeedbackShownFlag = NO;
        for (ActivityLog *log in [labelsForWeek objectForKey:@"logs"] ) {
        
            if (log.feedback.length > 0)
            {
                if (!weeklyFeedbackShownFlag)
                {
                    
                    [emailBody appendString:@"<span>Week of "];
                    [emailBody appendString:[df stringFromDate:weekKey]];
                    [emailBody appendString:@"</span><br/>"];
                    [emailBody appendString:@"<ul>"];
                    weeklyFeedbackShownFlag = YES;
                }
            
                [emailBody appendString:@"<li>"];
                [emailBody appendString:log.feedback];
                [emailBody appendString:@"</li>"];
            }
        }
    
        if (weeklyFeedbackShownFlag)
            [emailBody appendString:@"</ul>"];
    }
    

    

    
    // Attach an image to the email.
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"ipodnano" ofType:@"png"];
    //NSData *myData = [NSData dataWithContentsOfFile:path];
    //[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"ipodnano"];
    
    // Fill out the email body text.
    [picker setMessageBody:emailBody isHTML:YES];
    
    // Present the mail composition interface.
    [self presentModalViewController:picker animated:YES];
}



// The mail compose view controller delegate method

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
}
    



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"segueInquiry" sender:self];
    } else if (buttonIndex == 1) {
        [self performSegueWithIdentifier:@"segueShowing" sender:self];
    } else if (buttonIndex == 2) {
        [self performSegueWithIdentifier:@"segueOpenHouse" sender:self];
    } else if (buttonIndex == 3) {
        [self performSegueWithIdentifier:@"segueCustomEvent" sender:self];
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
    [self sortEvents];
    
    self.sectionDateFormatter = [[NSDateFormatter alloc] init];
    [self.sectionDateFormatter setDateStyle:NSDateFormatterLongStyle];
    [self.sectionDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.cellDateFormatter = [[NSDateFormatter alloc] init];
    [self.cellDateFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.cellDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    
    self.navigationItem.title = listing.name;
    
    [self showWelcomeMessage];
}


- (void) showWelcomeMessage
{
    
    if (self.sections.count == 0)
    {
        UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 100)];
        
        message.text = @"Use the '+' button above to add an event to this listing.";
        message.backgroundColor = [UIColor clearColor];
        message.textAlignment = NSTextAlignmentCenter;
        message.numberOfLines = 3;
        message.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        message.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        message.shadowColor = [UIColor colorWithWhite:1 alpha:1]; // or [UIColor whiteColor];
        
        message.shadowOffset = CGSizeMake(0,1);
        
        //Add picker to action sheet
        [tableView addSubview:message];
    }

    
}

- (void)sortEvents
{
    
    // break up the dates into sections
    self.sections = [NSMutableDictionary dictionary];
    sortedEventCount = listing.activityLogs.count;
    
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



- (NSMutableDictionary*)sortEventsWeek
{
    
    // break up the weeks into sections
    NSMutableDictionary *weeks  = [NSMutableDictionary dictionary];
    
    for (ActivityLog *log in listing.activityLogs)
    {
        // Reduce event start date to date components (year, month, day)
        NSDate *weekRepresentingThisLog = [self dateAtBeginningOfWeekForDate:log.date];
        
        // If we don't yet have an array to hold the events for this day, create one
        NSMutableDictionary *logsDuringThisWeek = [weeks objectForKey:weekRepresentingThisLog];
        if (logsDuringThisWeek == nil) {
            logsDuringThisWeek = [NSMutableDictionary dictionary];
            
            // Use the reduced date as dictionary key to later retrieve the event list this day
            [weeks setObject:logsDuringThisWeek forKey:weekRepresentingThisLog];
        }
        NSMutableArray *weeksLogs = [logsDuringThisWeek objectForKey:@"logs"];
        if (weeksLogs == nil) {
            weeksLogs = [NSMutableArray array];
            [logsDuringThisWeek setObject:weeksLogs forKey:@"logs"];
        }
        [weeksLogs addObject:log];
        
        NSString *key = log.label;
        NSNumber *labelsDuringThisWeek = [logsDuringThisWeek objectForKey:key];
        if (labelsDuringThisWeek == nil)
        {
            labelsDuringThisWeek = [[NSNumber alloc] initWithInt:1];
            [logsDuringThisWeek setObject:labelsDuringThisWeek forKey:key];
        }
        else
        {
            int value = [labelsDuringThisWeek intValue];
            labelsDuringThisWeek = [NSNumber numberWithInt:value + 1];
            [logsDuringThisWeek setObject:labelsDuringThisWeek forKey:key];
        }
        
        
        if ([log isKindOfClass:[OpenHouse class]])
        {
            NSNumber *openHouseVisitorsDuringThisWeek = [logsDuringThisWeek objectForKey:@"OpenHouseVisitors"];
            NSNumber *visitors = ((OpenHouse*)log).visitors;
            if (openHouseVisitorsDuringThisWeek == nil)
            {
                openHouseVisitorsDuringThisWeek = visitors;
                [logsDuringThisWeek setObject:openHouseVisitorsDuringThisWeek forKey:@"OpenHouseVisitors"];
            }
            else
            {
                int value = [openHouseVisitorsDuringThisWeek intValue];
                openHouseVisitorsDuringThisWeek = [NSNumber numberWithInt:value + [visitors integerValue]];
                [logsDuringThisWeek setObject:openHouseVisitorsDuringThisWeek forKey:@"OpenHouseVisitors"];
            }
        }
    }
    
    return weeks;
}



- (NSDate *)dateAtBeginningOfWeekForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSWeekCalendarUnit fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfWeek = [calendar dateFromComponents:dateComps];
    return beginningOfWeek;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [self showWelcomeMessage];
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
    
    cell.textLabel.text = log.label;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.detailTextLabel.text = [self.cellDateFormatter stringFromDate:log.date];
    
    if ([log isKindOfClass:[Inquiry class]])
        cell.imageView.image = [UIImage imageNamed:@"Inquiry.png"];

    if ([log isKindOfClass:[Showing class]])
        cell.imageView.image = [UIImage imageNamed:@"Showing.png"];

    if ([log isKindOfClass:[CustomEvent class]])
        cell.imageView.image = [UIImage imageNamed:@"Other.png"];

    
    if ([log isKindOfClass:[OpenHouse class]])
    {
        OpenHouse *openHouse = (OpenHouse *) log;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm a"];
        
        cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:@" - "];
        cell.imageView.image = [UIImage imageNamed:@"OpenHouse.png"];

        NSString *endTime = [formatter stringFromDate:openHouse.endTime];
        cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:endTime];
        
        if ([openHouse.visitors intValue] > 0)
        {
            cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:@", "];
            cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:[openHouse.visitors stringValue]];
            cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:@" Visitor"];
            if ([openHouse.visitors intValue] > 1)
                cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:@"s"];
        }
            
    }
    
    if (log.contacts.count == 1)
    {
        Contact *contact = [[[log.contacts allObjects] mutableCopy] objectAtIndex:0];
        NSString *contactName = contact.compositeName;
        
        cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:@", "];
        cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:contactName];
    }
    if (log.contacts.count > 1)
    {
        NSString *numOfContacts = [[NSNumber numberWithInt:log.contacts.count] stringValue];
        cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:@", "];
        cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:numOfContacts];
        cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:@" Contacts"];
    }

    
    
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
    if ( [log isKindOfClass:[CustomEvent class]] ) {
        [self performSegueWithIdentifier:@"segueCustomEvent" sender:log];
    }

}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
    // remove all subviews before we move on
    if ([tableView subviews]){
        for (UIView *subview in [tableView subviews]) {
            [subview removeFromSuperview];
        }
    }
    
    if ([segue.identifier isEqualToString:@"segueShowing"]) {
        ShowingDetailViewController *destViewController = segue.destinationViewController;
        destViewController.managedObjectContext = self.managedObjectContext;
        destViewController.listing = listing;
        destViewController.delegate = self;

        if (sender != self) {
            destViewController.showingEntity = sender;
        }
    } else if ([segue.identifier isEqualToString:@"segueOpenHouse"]) {
        OpenHouseViewController * destViewController = segue.destinationViewController;
        destViewController.managedObjectContext = self.managedObjectContext;
        destViewController.listing = listing;
        destViewController.delegate = self;

        if (sender != self) {
            destViewController.openHouseEntity = sender;
        }
    } else if ([segue.identifier isEqualToString:@"segueInquiry"]) {
        InquiryViewController * destViewController = segue.destinationViewController;
        destViewController.managedObjectContext = self.managedObjectContext;
        destViewController.listing = listing;
        destViewController.delegate = self;

        if (sender != self) {
            destViewController.inquiryEntity = sender;
        }
    } else if ([segue.identifier isEqualToString:@"segueCustomEvent"]) {
        CustomEventViewController * destViewController = segue.destinationViewController;
        destViewController.managedObjectContext = self.managedObjectContext;
        destViewController.listing = listing;
        destViewController.delegate = self;
        
        if (sender != self) {
            destViewController.customEntity = sender;
        }

    }
}


// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    if (indexPath.section != sections.count)
        return YES;
    else
        return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
        NSMutableArray *logsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
        ActivityLog *log = [logsOnThisDay objectAtIndex:indexPath.row];
        [listing removeActivityLogsObject:log];

        [managedObjectContext save:nil];
        
        [self sortEvents];
        [self.tableView reloadData];
    }
}



// ------------------
// MODAL CALLBACKS
// ------------------

#pragma mark - SourceTableViewControllerDelegate

- (void)InquiryViewControllerDidCancel:(SourceTableViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)InquiryViewControllerDidSave:(SourceTableViewController *)controller
{
    if (listing.activityLogs.count != sortedEventCount)
        [self sortEvents];

    [tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)ShowingDetailViewControllerDidSave:(SourceTableViewController *)controller
{
    if (listing.activityLogs.count != sortedEventCount)
        [self sortEvents];
    
    [tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)OpenHouseViewControllerDidSave:(SourceTableViewController *)controller
{
    if (listing.activityLogs.count != sortedEventCount)
        [self sortEvents];
    
    [tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)CustomEventViewControllerDidSave:(CustomEventViewController *)controller
{
    if (listing.activityLogs.count != sortedEventCount)
        [self sortEvents];
    
    [tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
