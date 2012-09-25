//
//  OpenHouseViewController.m
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-08-30.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "OpenHouseViewController.h"
#import "NoteViewController.h"
#import "OpenHouse.h"
#import "Listing.h"
#import <QuartzCore/QuartzCore.h>
#import "DCRoundSwitch.h"
#import "SourceTableViewController.h"
#import "Contact.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AudioToolbox/AudioToolbox.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface OpenHouseViewController ()

@end

@implementation OpenHouseViewController {}


@synthesize listing;
@synthesize tableView1Data;
@synthesize tableView;
@synthesize openHouseEntity;
@synthesize fetchedResultsController;
@synthesize textView;
@synthesize saveButton;

@synthesize managedObjectContext;


#define kDatePickerTag 100
#define kStartTimePickerTag 101
#define kEndTimePickerTag 102

#define TAG_TEXTFIELD_CONTACT_NAME  1
#define TAG_TEXTFIELD_CONTACT_COMPANY 2
#define TAG_TEXTFIELD_CONTACT_PHONE 3
#define TAG_TEXTFIELD_CONTACT_EMAIL 4

#define TAG_CELL_DATE 10
#define TAG_CELL_STARTTIME 12
#define TAG_CELL_ENDTIME 14
#define TAG_CELL_VISITOR_COUNT 20
#define TAG_CELL_NOTES 3
#define TAG_CELL_FEEDBACK 4
#define TAG_CELL_CALENDAR_REMINDER 55
#define TAG_CELL_CONTACT_SELECT  101
#define TAG_CELL_CONTACT_ADD 102



int ActionSheetType;

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    
    UIDatePicker *pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    
    //Configure picker...
    if (ActionSheetType == kDatePickerTag)
    {
        [pickerView setDatePickerMode:UIDatePickerModeDateAndTime];
        [pickerView setDate:openHouseEntity.date];
        [pickerView setTag:kDatePickerTag];
    }
    
    if (ActionSheetType == kStartTimePickerTag)
    {
        [pickerView setDatePickerMode:UIDatePickerModeTime];
        [pickerView setMinuteInterval:15];
        [pickerView setTag:kDatePickerTag];
        [pickerView setDate:openHouseEntity.date];
    }
    
    if (ActionSheetType == kEndTimePickerTag)
    {
        [pickerView setDatePickerMode:UIDatePickerModeTime];
        [pickerView setMinuteInterval:15];
        [pickerView setTag:kDatePickerTag];
        [pickerView setDate:openHouseEntity.endTime];
    }
    
    
    //Add picker to action sheet
    [actionSheet addSubview:pickerView];
    
    //Gets an array af all of the subviews of our actionSheet
    NSArray *subviews = [actionSheet subviews];
    
    [[subviews objectAtIndex:1] setFrame:CGRectMake(20, 235, 280, 46)];
    [[subviews objectAtIndex:2] setFrame:CGRectMake(20, 295, 280, 46)];
    
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        
        UIDatePicker *ourDatePicker = (UIDatePicker *) [actionSheet viewWithTag:kDatePickerTag];
        NSDate *selectedDate = [ourDatePicker date];
        
        if (ActionSheetType == kDatePickerTag)
        {
            NSDateComponents *startDateComps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:selectedDate];
            NSDateComponents *endDateComps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:selectedDate];

            NSDateComponents *startTimeComps = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:openHouseEntity.date];
            NSDateComponents *endTimeComps = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:openHouseEntity.endTime];

            [startDateComps setHour:startTimeComps.hour];
            [startDateComps setMinute:startTimeComps.minute];
            [endDateComps setHour:endTimeComps.hour];
            [endDateComps setMinute:endTimeComps.minute];
       
            NSDate *startTimeDate = [[NSCalendar currentCalendar] dateFromComponents:startDateComps];
            NSDate *endTimeDate = [[NSCalendar currentCalendar] dateFromComponents:endDateComps];
            
            openHouseEntity.date = startTimeDate;
            openHouseEntity.endTime = endTimeDate;

        
        }
        else
        {
            if (ActionSheetType == kStartTimePickerTag)
            {
                NSDateComponents *dateComps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:openHouseEntity.date];
                NSDateComponents *timeComps = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:selectedDate];
                [dateComps setHour:timeComps.hour];
                [dateComps setMinute:timeComps.minute];
            
                NSDate *startTimeDate = [[NSCalendar currentCalendar] dateFromComponents:dateComps];
                openHouseEntity.date = startTimeDate;
            }
            if (ActionSheetType == kEndTimePickerTag)
            {
                NSDateComponents *dateComps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:openHouseEntity.date];
                NSDateComponents *timeComps = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:selectedDate];
                [dateComps setHour:timeComps.hour];
                [dateComps setMinute:timeComps.minute];
                
                NSDate *startTimeDate = [[NSCalendar currentCalendar] dateFromComponents:dateComps];
                openHouseEntity.endTime = startTimeDate;
            }
  
        }
        
        
        [tableView reloadData];
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
    
    
    // Register notification when the keyboard will be show
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // Register notification when the keyboard will be hide
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.prompt = listing.name;

    UIEdgeInsets inset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.contentInset = inset;
    

        
    if (openHouseEntity == nil)
    {
        openHouseEntity = (OpenHouse *)[NSEntityDescription insertNewObjectForEntityForName:@"OpenHouse" inManagedObjectContext:managedObjectContext];
        openHouseEntity.listing = listing;
        openHouseEntity.createdDate = [NSDate date];
        
        
        // setup the defalt date to be today 2pm
        // with an end date of today 4pm
        NSDate *todaysDate = [NSDate date];
        NSDateComponents *startComps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:todaysDate];
        [startComps setHour:14];
        [startComps setMinute:0];
        NSDate *startTime = [[NSCalendar currentCalendar] dateFromComponents:startComps];
        openHouseEntity.date = startTime;
        
        NSDateComponents *endComps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit ) fromDate:todaysDate];
        [endComps setHour:16];
        [endComps setMinute:0];
        NSDate *endTime = [[NSCalendar currentCalendar] dateFromComponents:endComps];
        openHouseEntity.endTime = endTime;
        
        
        [listing addActivityLogsObject:openHouseEntity];
    }
    else
    {
        // make sure calendar event still exists
        EKEventStore *store = [[EKEventStore alloc] init];
        if (openHouseEntity.calendarEventIdentifier != nil)
        {
            EKEvent *event = [store eventWithIdentifier:openHouseEntity.calendarEventIdentifier];
            if (event == nil)
                openHouseEntity.calendarEventIdentifier = nil;
        }
        
    }

    
    self.title = @"Open House";
    
    
    self.tableView1Data = [NSMutableArray array];
    
    // ----------------------------;
    // Table View Section -> Source
    // ----------------------------;
    
    NSMutableDictionary *tableViewSectionSourceData = [NSMutableDictionary dictionary];
    [tableViewSectionSourceData setObject:@"" forKey:@"headerText"];
    [tableViewSectionSourceData setObject:@"" forKey:@"footerText"];
    [tableViewSectionSourceData setObject:[NSMutableArray array] forKey:@"cells"];
    [self.tableView1Data addObject:tableViewSectionSourceData];
    
    
    
    // ----------------------------;
    // Cell -> Date;
    // ----------------------------;
    
    NSMutableDictionary *tableViewCellDateTimeData = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCellDataTime = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    tableViewCellDataTime.textLabel.text = @"Date";
    tableViewCellDataTime.tag = TAG_CELL_DATE;
    
    tableViewCellDataTime.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [tableViewCellDateTimeData setObject:tableViewCellDataTime forKey:@"cell"];
    [tableViewCellDateTimeData setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCellDateTimeData setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    [tableViewCellDateTimeData setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCellDateTimeData setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewSectionSourceData objectForKey:@"cells"] addObject:tableViewCellDateTimeData];
  
    
    // ----------------------------;
    // Cell -> Start Time;
    // ----------------------------;
    
    NSMutableDictionary *tableViewCellStartTimeData = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCellStartTime = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    tableViewCellStartTime.textLabel.text = @"Start Time";
    tableViewCellStartTime.tag = TAG_CELL_STARTTIME;
    
    tableViewCellStartTime.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [tableViewCellStartTimeData setObject:tableViewCellStartTime forKey:@"cell"];
    [tableViewCellStartTimeData setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCellStartTimeData setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    [tableViewCellStartTimeData setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCellStartTimeData setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewSectionSourceData objectForKey:@"cells"] addObject:tableViewCellStartTimeData];

    // ----------------------------;
    // Cell -> End Time;
    // ----------------------------;
    
    NSMutableDictionary *tableViewCellEndTimeData = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCellEndTime = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    tableViewCellEndTime.textLabel.text = @"End Time";
    tableViewCellEndTime.tag = TAG_CELL_ENDTIME;
    
    tableViewCellEndTime.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [tableViewCellEndTimeData setObject:tableViewCellEndTime forKey:@"cell"];
    [tableViewCellEndTimeData setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCellEndTimeData setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    [tableViewCellEndTimeData setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCellEndTimeData setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewSectionSourceData objectForKey:@"cells"] addObject:tableViewCellEndTimeData];
    
    
    
    // ----------------------------;
    // Table View Section -> Visitors
    // ----------------------------;
    
    NSMutableDictionary *tableViewPeopleSourceData = [NSMutableDictionary dictionary];
    [tableViewPeopleSourceData setObject:@"" forKey:@"headerText"];
    [tableViewPeopleSourceData setObject:@"" forKey:@"footerText"];
    [tableViewPeopleSourceData setObject:[NSMutableArray array] forKey:@"cells"];
    [self.tableView1Data addObject:tableViewPeopleSourceData];

    
    // ----------------------------;
    // Cell -> Visitor Count;
    // ----------------------------;
    
    NSMutableDictionary *tableViewCellVisitorsData = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCellVisitors = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    tableViewCellVisitors.textLabel.text = @"Visitor Count";
    tableViewCellVisitors.tag = TAG_CELL_VISITOR_COUNT;
    tableViewCellVisitors.accessoryType = UITableViewCellAccessoryNone;
    tableViewCellVisitors.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectMake(160,10,70,30)];
    [stepper setValue: openHouseEntity.visitors.doubleValue];
    [tableViewCellVisitors addSubview:stepper];
    [stepper addTarget:self action:@selector(stepperValueDidChanged:) forControlEvents:UIControlEventValueChanged];

    
    [tableViewCellVisitorsData setObject:tableViewCellVisitors forKey:@"cell"];
    [tableViewCellVisitorsData setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCellVisitorsData setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    [tableViewCellVisitorsData setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCellVisitorsData setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewPeopleSourceData objectForKey:@"cells"] addObject:tableViewCellVisitorsData];

    
    
    // ----------------------------;
    // Cell -> Select Contact;
    // ----------------------------;
    
    NSMutableDictionary *tableViewCellContactNameData = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCellContactName = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    tableViewCellContactName.textLabel.text = @"Contacts";
    tableViewCellContactName.selectionStyle = UITableViewCellSelectionStyleNone;
    tableViewCellContactName.tag = TAG_CELL_CONTACT_SELECT;
    tableViewCellContactName.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [tableViewCellContactNameData setObject:tableViewCellContactName forKey:@"cell"];
    [tableViewCellContactNameData setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCellContactNameData setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    [tableViewCellContactNameData setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCellContactNameData setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewPeopleSourceData objectForKey:@"cells"] addObject:tableViewCellContactNameData];
    
    
    
    // ----------------------------;
    // Table View Section -> Comments;
    // ----------------------------;
    
    NSMutableDictionary *tableViewSection3Data = [NSMutableDictionary dictionary];
    [tableViewSection3Data setObject:@"" forKey:@"headerText"];
    [tableViewSection3Data setObject:@"" forKey:@"footerText"];
    [tableViewSection3Data setObject:[NSMutableArray array] forKey:@"cells"];
    [self.tableView1Data addObject:tableViewSection3Data];
    
    
    
    // ----------------------------;
    // Cell -> Feedback;
    // ----------------------------;
    
    NSMutableDictionary *tableViewCell6Data = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCell6 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    tableViewCell6.textLabel.text = @"Feedback";
    tableViewCell6.tag = TAG_CELL_FEEDBACK;
    
    tableViewCell6.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [tableViewCell6Data setObject:tableViewCell6 forKey:@"cell"];
    [tableViewCell6Data setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCell6Data setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    [tableViewCell6Data setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCell6Data setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewSection3Data objectForKey:@"cells"] addObject:tableViewCell6Data];
    
    // ----------------------------;
    // Cell -> Notes;
    // ----------------------------;
    
    NSMutableDictionary *tableViewCell7Data = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCell7 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    tableViewCell7.textLabel.text = @"Notes";
    tableViewCell7.tag = TAG_CELL_NOTES;
    
    tableViewCell7.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [tableViewCell7Data setObject:tableViewCell7 forKey:@"cell"];
    [tableViewCell7Data setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCell7Data setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    [tableViewCell7Data setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCell7Data setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewSection3Data objectForKey:@"cells"] addObject:tableViewCell7Data];
    
}



-(void)sourceSelect:(UISegmentedControl*)sender
{
    UIColor *tintcolor = [UIColor blueColor];
    UIColor *notselectedColor = [UIColor lightGrayColor];
    
    if (sender.selectedSegmentIndex == 0) {
        [[sender.subviews objectAtIndex:0] setTintColor:notselectedColor];
        [[sender.subviews objectAtIndex:1] setTintColor:tintcolor];
    } else {
        [[sender.subviews objectAtIndex:0] setTintColor:tintcolor];
        [[sender.subviews objectAtIndex:1] setTintColor:notselectedColor];
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tableView reloadData];
    //self.navigationItem.hidesBackButton = openHouseEntity.hasChanges;
}




- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [tableView reloadData];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [managedObjectContext save:nil];
    [super viewDidDisappear:animated];
}



// ----------------
// Table View
// ----------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableView1Data.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sectionData = [self.tableView1Data objectAtIndex:section];
    return [[sectionData objectForKey:@"cells"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sectionData = [self.tableView1Data objectAtIndex:indexPath.section];
    NSDictionary *cellData =  [[sectionData objectForKey:@"cells"] objectAtIndex:indexPath.row];
    
    UITableViewCell *cellToCheck = [cellData objectForKey:@"cell"];
    
    
    if (cellToCheck.tag == 1) // source cells
    {
        cellToCheck.detailTextLabel.text = openHouseEntity.source;
    }
    if (cellToCheck.tag == TAG_CELL_DATE) // date cell
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEEE, MMMM d"];
        cellToCheck.detailTextLabel.text = [formatter stringFromDate: openHouseEntity.date];
    }
    if (cellToCheck.tag == TAG_CELL_STARTTIME)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm a"];
        cellToCheck.detailTextLabel.text = [formatter stringFromDate: openHouseEntity.date];
    }
    if (cellToCheck.tag == TAG_CELL_ENDTIME)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm a"];
        cellToCheck.detailTextLabel.text = [formatter stringFromDate: openHouseEntity.endTime];
    }
    if (cellToCheck.tag == TAG_CELL_NOTES)
        cellToCheck.detailTextLabel.text = openHouseEntity.note;
    
    if (cellToCheck.tag == TAG_CELL_FEEDBACK)
        cellToCheck.detailTextLabel.text = openHouseEntity.feedback;
 
    if (cellToCheck.tag == TAG_CELL_VISITOR_COUNT)
    {
        cellToCheck.detailTextLabel.text = [openHouseEntity.visitors stringValue];
    }
    
    if (cellToCheck.tag == TAG_CELL_CONTACT_SELECT)
    {
        
        if (openHouseEntity.contacts.count == 0)
            cellToCheck.detailTextLabel.text = nil;
        
        if (openHouseEntity.contacts.count == 1)
        {
            Contact *contact = [[[openHouseEntity.contacts allObjects] mutableCopy] objectAtIndex:0];
            cellToCheck.detailTextLabel.text = contact.compositeName;
        }
        
        if (openHouseEntity.contacts.count > 1)
        {
            NSString *numOfContacts = [[NSNumber numberWithInt:openHouseEntity.contacts.count] stringValue];
            cellToCheck.detailTextLabel.text = [numOfContacts stringByAppendingString:@" Contacts"];
        }
        
    }
    
    return cellToCheck;
}





- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *sectionData = [self.tableView1Data objectAtIndex:section];
    return [sectionData objectForKey:@"headerText"];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSDictionary *sectionData = [self.tableView1Data objectAtIndex:section];
    return [sectionData objectForKey:@"footerText"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sectionData = [self.tableView1Data objectAtIndex:indexPath.section];
    NSDictionary *cellData =  [[sectionData objectForKey:@"cells"] objectAtIndex:indexPath.row];
    return [[cellData objectForKey:@"height"] floatValue];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *sectionData = [self.tableView1Data objectAtIndex:section];
    if ([[sectionData objectForKey:@"customHeaderView"] boolValue]) {;
        return [sectionData objectForKey:@"headerView"];
    } else {;
        return nil;
    };
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSDictionary *sectionData = [self.tableView1Data objectAtIndex:section];
    if ([[sectionData objectForKey:@"customFooterView"] boolValue]) {;
        return [sectionData objectForKey:@"footerView"];
    } else {;
        return nil;
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
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
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sectionData = [self.tableView1Data objectAtIndex:indexPath.section];
    NSDictionary *cellData =  [[sectionData objectForKey:@"cells"] objectAtIndex:indexPath.row];
    return [[cellData objectForKey:@"indentationLevel"] integerValue];
}


YIPopupTextView* popupTextView;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sectionData = [self.tableView1Data objectAtIndex:indexPath.section];
    NSDictionary *cellData =  [[sectionData objectForKey:@"cells"] objectAtIndex:indexPath.row];
    
    UITableViewCell *cellToCheck = [cellData objectForKey:@"cell"];
    
    // checkmark formating to select only the currently selected on
    if (cellToCheck.tag == 1)
    {
        [self performSegueWithIdentifier:@"segueSource" sender:self];
        //[self performSegueWithIdentifier:@"segueSource" sender:self];
    }
    
    if (cellToCheck.tag == TAG_CELL_DATE)
    {
        [self showCalendarAction];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }

    if (cellToCheck.tag == TAG_CELL_STARTTIME)
    {
        [self showStartTimeAction];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
 
    if (cellToCheck.tag == TAG_CELL_ENDTIME)
    {
        [self showEndTimeAction];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if (cellToCheck.tag == TAG_CELL_FEEDBACK)
    {
        notesTag = TAG_CELL_FEEDBACK;
        popupTextView = [[YIPopupTextView alloc] initWithPlaceHolder:@"Enter shared feedback and notes for clients here." maxCount:1000];
        popupTextView.delegate = self;
        popupTextView.showCloseButton = NO;
        popupTextView.caretShiftGestureEnabled = YES;   // default = NO
        popupTextView.text = openHouseEntity.feedback;
        self.navigationItem.title = [openHouseEntity.label stringByAppendingString:@" Feedback"];
        [popupTextView showInView:[self.view superview]];
    }
    if (cellToCheck.tag == TAG_CELL_NOTES)
    {
        notesTag = TAG_CELL_NOTES;
        popupTextView = [[YIPopupTextView alloc] initWithPlaceHolder:@"Enter private REALTOR\u2122 notes and comments here." maxCount:1000];
        popupTextView.delegate = self;
        popupTextView.showCloseButton = NO;
        popupTextView.caretShiftGestureEnabled = YES;   // default = NO
        popupTextView.text = openHouseEntity.note;
        self.navigationItem.title = [openHouseEntity.label stringByAppendingString:@" Notes"];
        [popupTextView showInView:[self.view superview]];
    }
    
    if (cellToCheck.tag == TAG_CELL_CONTACT_SELECT)
    {
        [self performSegueWithIdentifier:@"segueContacts" sender:self];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if (cellToCheck.tag == 100)
    {
        UITextField *textField = (UITextField *)cellToCheck.accessoryView;
        [textField becomeFirstResponder];
    }
    
}

int notesTag;



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"segueSource"]) {
        
        SourceTableViewController *sourceViewController = (SourceTableViewController *) segue.destinationViewController;
        sourceViewController.activityLog = openHouseEntity;
        sourceViewController.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"segueContacts"]) {
        
        ContactsViewController *contactsViewController = (ContactsViewController *) segue.destinationViewController;
        contactsViewController.activityLog = openHouseEntity;
    }
    
    
}





-(void) keyboardWillShow:(NSNotification *)note
{
    // Get the keyboard size
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = tableView.frame;
    
    // Start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // Reduce size of the Table view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        frame.size.height -= keyboardBounds.size.height;
    else
        frame.size.height -= keyboardBounds.size.width;
    
    // Apply new size of table view
    self.tableView.frame = frame;
    
    [UIView commitAnimations];
}


-(void) keyboardWillHide:(NSNotification *)note
{
    // Get the keyboard size
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = self.tableView.frame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // Reduce size of the Table view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        frame.size.height += keyboardBounds.size.height;
    else
        frame.size.height += keyboardBounds.size.width;
    
    // Apply new size of table view
    self.tableView.frame = frame;
    
    [UIView commitAnimations];
}



// ----------------
// Action
// ----------------


-(IBAction) showCalendarAction {
    UIActionSheet *asheet = [[UIActionSheet alloc] initWithTitle:@"Pick the date you want to see." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Select", nil];
    ActionSheetType = kDatePickerTag;
    [asheet showInView:[self.view superview]]; //note: in most cases this would be just self.view, but because I was doing this in a tabBar Application, I use the superview.
    [asheet setFrame:CGRectMake(0, 117, 320, 383)];
}

-(IBAction) showStartTimeAction {
    UIActionSheet *asheet = [[UIActionSheet alloc] initWithTitle:@"Pick the time you want to see." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Select", nil];
    ActionSheetType = kStartTimePickerTag;
    [asheet showInView:[self.view superview]]; //note: in most cases this would be just self.view, but because I was doing this in a tabBar Application, I use the superview.
    [asheet setFrame:CGRectMake(0, 117, 320, 383)];
}

-(IBAction) showEndTimeAction {
    UIActionSheet *asheet = [[UIActionSheet alloc] initWithTitle:@"Pick the time you want to see." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Select", nil];
    ActionSheetType = kEndTimePickerTag;
    [asheet showInView:[self.view superview]]; //note: in most cases this would be just self.view, but because I was doing this in a tabBar Application, I use the superview.
    [asheet setFrame:CGRectMake(0, 117, 320, 383)];
}


- (IBAction)SaveButtonPressed:(id)sender {
    
    if (notesTag > 0)
    {
        [popupTextView dismiss];
        notesTag = 0;
        //self.navigationItem.hidesBackButton = openHouseEntity.hasChanges;
        
    }
    else
    {
        openHouseEntity.modifiedDate = [NSDate date];
        [managedObjectContext save:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate OpenHouseViewControllerDidSave:self];
    }
}

- (IBAction)deleteButtonPressed:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Delete"
                                                    message:@"Are you sure you want to delete this open house?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Delete", nil];
    [alert show];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Delete"])
    {
        [listing removeActivityLogsObject:openHouseEntity];
        [managedObjectContext save:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate OpenHouseViewControllerDidSave:self];
    }
    
}




- (IBAction)stepperValueDidChanged:(UIStepper *)sender {
    UITableViewCell *cell = (UITableViewCell *)[sender superview];

    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    [cell setSelected:YES animated:YES];
    
    openHouseEntity.visitors = [NSNumber numberWithLong:sender.value];

    [NSTimer scheduledTimerWithTimeInterval: 0.2 target: self
            selector: @selector(deselectVisitorHighlight:) userInfo: cell repeats: NO];

}


-(void) deselectVisitorHighlight:(NSTimer*) t
{
    UITableViewCell *cell = (UITableViewCell *) t.userInfo;
    cell.detailTextLabel.text = [openHouseEntity.visitors stringValue];
    
    [cell setSelected:NO animated:YES];

    [NSTimer scheduledTimerWithTimeInterval: 0.2 target: self
                                   selector: @selector(disableVisitorRowSelection:) userInfo: cell repeats: NO];
    
}


-(void) disableVisitorRowSelection:(NSTimer*) t
{
    UITableViewCell *cell = (UITableViewCell *) t.userInfo;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}




// ------------------
// MODAL CALLBACKS
// ------------------

#pragma mark - SourceTableViewControllerDelegate

- (void)SourceTableViewControllerDidCancel:(SourceTableViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)SourceTableViewControllerDidSave:(SourceTableViewController *)controller source:(NSString *)source
{
    openHouseEntity.source = source;
    [tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)NoteViewControllerDidCancel:(NoteViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)ContactsViewControllerDidCancel:(ContactsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)ContactsViewControllerDidSave:(ContactsViewController *)controller source:(NSString *)source
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)NoteViewControllerDidSave:(SourceTableViewController *)controller tag:(int)tag text:(NSString *)text
{
    if (tag == 1)
        openHouseEntity.note = text;
    else
        openHouseEntity.feedback = text;
    
    NSDictionary *sectionData = [self.tableView1Data objectAtIndex:2];
    NSDictionary *cellData =  [[sectionData objectForKey:@"cells"] objectAtIndex:0];
    UITableViewCell *cell = [cellData objectForKey:@"cell"];
    cell.detailTextLabel.text = text;
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier

{
    return NO;
}






#pragma mark YIPopupTextViewDelegate

- (void)popupTextView:(YIPopupTextView *)textView willDismissWithText:(NSString *)text
{
    if (notesTag == TAG_CELL_NOTES)
        openHouseEntity.note = text;
    
    if (notesTag == TAG_CELL_FEEDBACK)
        openHouseEntity.feedback = text;
    
    self.navigationItem.title = @"Open House";
    [tableView reloadData];
}

- (void)popupTextView:(YIPopupTextView *)textView didDismissWithText:(NSString *)text
{
}


- (IBAction)actionButtonPressed:(id)sender {

    
    EKEventStore *store = [[EKEventStore alloc] init];
    EKEvent *event;
    
    
    if (openHouseEntity.calendarEventIdentifier != nil)
        event = [store eventWithIdentifier:openHouseEntity.calendarEventIdentifier];
    else
    {
        event = [EKEvent eventWithEventStore:store];
        event.startDate = openHouseEntity.date;
        event.endDate   = openHouseEntity.endTime;
        event.title = openHouseEntity.label;
        event.location = listing.name;
        event.availability = EKEventAvailabilityBusy;
        
        EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:-3600];
        event.alarms = [NSArray arrayWithObject:alarm];
        
        if (openHouseEntity.note != nil)
            event.notes = [openHouseEntity.note stringByAppendingString:@"\nEntry created by ListingAgent."];
        else
            event.notes = @"Entry created by ListingAgent.";
    }
    
    
    void (^presentEventEditor)(void) = ^{
        EKEventEditViewController *controller = [[EKEventEditViewController alloc] init];
        controller.eventStore = store;
        controller.event = event;
        controller.editViewDelegate = self;
        
        [self presentViewController:controller animated:YES completion:nil];
    };
    
    EKAuthorizationStatus authStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    if (authStatus == EKAuthorizationStatusAuthorized) {
        presentEventEditor();
    } else if (authStatus == EKAuthorizationStatusNotDetermined) {
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (granted) presentEventEditor();
        }];
    }

}



- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    if (action == EKEventEditViewActionSaved)
        openHouseEntity.calendarEventIdentifier = controller.event.eventIdentifier;
    
    if (action == EKEventEditViewActionDeleted)
        openHouseEntity.calendarEventIdentifier = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [tableView reloadData];
    
}




@end
