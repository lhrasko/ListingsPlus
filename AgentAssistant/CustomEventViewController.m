//
//  ShowingDetailViewController.m
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-08-30.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "CustomEventViewController.h"
#import "NoteViewController.h"
#import "CustomEvent.h"
#import "Listing.h"
#import <QuartzCore/QuartzCore.h>
#import "DCRoundSwitch.h"
#import "SourceTableViewController.h"
#import "Contact.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface CustomEventViewController ()

@end

@implementation CustomEventViewController {}


@synthesize listing;
@synthesize tableView1Data;
@synthesize tableView;
@synthesize customEntity;
@synthesize actifText;
@synthesize fetchedResultsController;
@synthesize textView;
@synthesize saveButton;
@synthesize textBoxToolbar;
@synthesize listingLabel;
@synthesize managedObjectContext;


#define kDatePickerTag 100
#define TAG_TEXTFIELD_CONTACT_NAME  1
#define TAG_TEXTFIELD_CONTACT_COMPANY 2
#define TAG_TEXTFIELD_CONTACT_PHONE 3
#define TAG_TEXTFIELD_CONTACT_EMAIL 4

#define TAG_CELL_DATE 2
#define TAG_CELL_NOTES 3
#define TAG_CELL_FEEDBACK 4
#define TAG_CELL_CONTACT_SELECT  101
#define TAG_CELL_CONTACT_ADD 102


- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    
    UIDatePicker *pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    
    //Configure picker...
    [pickerView setDatePickerMode:UIDatePickerModeDateAndTime];
    [pickerView setMinuteInterval:15];
    [pickerView setTag: kDatePickerTag];
    [pickerView setDate:customEntity.date];
    
    //Add picker to action sheet
    [actionSheet addSubview:pickerView];
    
    //Gets an array af all of the subviews of our actionSheet
    NSArray *subviews = [actionSheet subviews];
    
    [[subviews objectAtIndex:1] setFrame:CGRectMake(20, 235, 280, 46)];
    [[subviews objectAtIndex:2] setFrame:CGRectMake(20, 295, 280, 46)];
    
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        
        //Gets our picker
        UIDatePicker *ourDatePicker = (UIDatePicker *) [actionSheet viewWithTag:kDatePickerTag];
        NSDate *selectedDate = [ourDatePicker date];
        
        customEntity.date = selectedDate;
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
    
    UIEdgeInsets inset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.contentInset = inset;
    
    
    if (customEntity == nil)
    {
        self.title = @"New Custom Event";

        customEntity = (CustomEvent *)[NSEntityDescription insertNewObjectForEntityForName:@"Custom" inManagedObjectContext:managedObjectContext];
        customEntity.listing = listing;
        customEntity.createdDate = [NSDate date];
        customEntity.date = [NSDate date];
        
        [listing addActivityLogsObject:customEntity];
        [managedObjectContext save:nil];
    }
    else
        self.title = @"Edit Custom Event";
    
    
    self.tableView1Data = [NSMutableArray array];
    
    CGRect frame = self.textBoxToolbar.frame;
    frame.origin.y = self.view.frame.size.height + 50;
    self.textBoxToolbar.frame = frame;

    
    
    // ----------------------------;
    // Table View Section -> Custom Name
    // ----------------------------;
    
    NSMutableDictionary *tableViewSectionLabelData = [NSMutableDictionary dictionary];
    [tableViewSectionLabelData setObject:@"" forKey:@"headerText"];
    [tableViewSectionLabelData setObject:@"" forKey:@"footerText"];
    [tableViewSectionLabelData setObject:[NSMutableArray array] forKey:@"cells"];
    [self.tableView1Data addObject:tableViewSectionLabelData];
    
    // ----------------------------;
    // Cell -> Label;
    // ----------------------------;
    
    
    NSMutableDictionary *tableViewCellLabelData = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCellLabel = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
    tableViewCellLabel.textLabel.text = @"Name";
    tableViewCellLabel.selectionStyle = UITableViewCellSelectionStyleNone;
    tableViewCellLabel.tag = 0;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0,10,200,35)];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.placeholder = @"Enter event name";
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Hide" style:UIBarButtonItemStyleDone target:self action:@selector(hideKeyboardButtonPressed:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space, doneButton, nil]];

    textField.inputAccessoryView = toolBar;

    [textField addTarget:self action:@selector(textFieldEditingEnded:) forControlEvents:UIControlEventEditingDidEnd];
    tableViewCellLabel.accessoryView = textField;
      
    [tableViewCellLabelData setObject:tableViewCellLabel forKey:@"cell"];
    [tableViewCellLabelData setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCellLabelData setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    
    [tableViewCellLabelData setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCellLabelData setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewSectionLabelData objectForKey:@"cells"] addObject:tableViewCellLabelData];
    
    
    // ----------------------------;
    // Table View Section -> Source
    // ----------------------------;
    
    NSMutableDictionary *tableViewSectionSourceData = [NSMutableDictionary dictionary];
    [tableViewSectionSourceData setObject:@"" forKey:@"headerText"];
    [tableViewSectionSourceData setObject:@"" forKey:@"footerText"];
    [tableViewSectionSourceData setObject:[NSMutableArray array] forKey:@"cells"];
    [self.tableView1Data addObject:tableViewSectionSourceData];
    
    
    
    // ----------------------------;
    // Cell -> Date & Time;
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
    // Cell -> Source;
    // ----------------------------;
    
    NSMutableDictionary *tableViewCellSourceData = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCellSource = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    tableViewCellSource.textLabel.text = @"Source";
    tableViewCellSource.selectionStyle = UITableViewCellSelectionStyleNone;
    tableViewCellSource.tag = 1;
    tableViewCellSource.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //DCRoundSwitch *switchView = [[DCRoundSwitch alloc] initWithFrame:CGRectMake(0,10,75,28)];
    //switchView.onText = @"YES";
    //switchView.offText = @"NO";
    //switchView.on = YES;
    
    //switchView.leftLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    //switchView.rightLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    //tableViewCellSource.accessoryView = switchView;
    
    [tableViewCellSourceData setObject:tableViewCellSource forKey:@"cell"];
    [tableViewCellSourceData setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCellSourceData setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    
    [tableViewCellSourceData setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCellSourceData setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewSectionSourceData objectForKey:@"cells"] addObject:tableViewCellSourceData];
    
    
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
    [[tableViewSectionSourceData objectForKey:@"cells"] addObject:tableViewCellContactNameData];
    
    
    
    // ----------------------------;
    // Table View Section -> Additional Info;
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
    //self.navigationItem.hidesBackButton = customEntity.hasChanges;
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
    
    if (cellToCheck.tag == 0)
    {
        UITextField *textField = (UITextField *) cellToCheck.accessoryView;
        textField.text = customEntity.name;
    }
    
    if (cellToCheck.tag == 1) // source cells
    {
        cellToCheck.detailTextLabel.text = customEntity.source;
    }
    if (cellToCheck.tag == TAG_CELL_DATE) // date cell
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEE, MMM d h:mm a"];
        cellToCheck.detailTextLabel.text = [formatter stringFromDate: customEntity.date];
    }
    
    if (cellToCheck.tag == TAG_CELL_NOTES)
        cellToCheck.detailTextLabel.text = customEntity.note;
    
    if (cellToCheck.tag == TAG_CELL_FEEDBACK)
        cellToCheck.detailTextLabel.text = customEntity.feedback;
    
    
    if (cellToCheck.tag == TAG_CELL_CONTACT_SELECT)
    {
        
        if (customEntity.contacts.count == 0)
            cellToCheck.detailTextLabel.text = nil;
        
        if (customEntity.contacts.count == 1)
        {
            Contact *contact = [[[customEntity.contacts allObjects] mutableCopy] objectAtIndex:0];
            cellToCheck.detailTextLabel.text = contact.compositeName;
        }
        
        if (customEntity.contacts.count > 1)
        {
            NSString *numOfContacts = [[NSNumber numberWithInt:customEntity.contacts.count] stringValue];
            cellToCheck.detailTextLabel.text = [numOfContacts stringByAppendingString:@" Contacts"];
        }
        
        //UITextField *textField = (UITextField *) cellToCheck.accessoryView;
        //textField.text = Other.contact.company;
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
    if (section == 0)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,tableView.frame.size.width,25)];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, -20, 240, 25)];
        
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.text = listing.name;
        
        headerLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        headerLabel.shadowColor = [UIColor colorWithWhite:1 alpha:1]; // or [UIColor whiteColor];
        headerLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        headerLabel.backgroundColor = [UIColor clearColor];
        
        [headerView addSubview:headerLabel];
        
        return headerView;
    }
    else
    {
        
        NSDictionary *sectionData = [self.tableView1Data objectAtIndex:section];
        if ([[sectionData objectForKey:@"customHeaderView"] boolValue]) {;
            return [sectionData objectForKey:@"headerView"];
        } else {;
            return nil;
        };
    }
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
    if (section == 0)
        return 25;
    else
    {
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
    
    if (cellToCheck.tag == 0)
    {
        cellToCheck.editing = YES;
        
    }
    
    // checkmark formating to select only the currently selected on
    if (cellToCheck.tag == 1)
    {
        [self performSegueWithIdentifier:@"segueSource" sender:self];
        //[self performSegueWithIdentifier:@"segueSource" sender:self];
    }
    
    if (cellToCheck.tag == 2)
    {
        [self showCalendarAction];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if (cellToCheck.tag == TAG_CELL_FEEDBACK)
    {
        notesTag = TAG_CELL_FEEDBACK;
        popupTextView = [[YIPopupTextView alloc] initWithPlaceHolder:@"Enter shared feedback and notes for clients here." maxCount:1000];
        popupTextView.delegate = self;
        popupTextView.showCloseButton = NO;
        popupTextView.caretShiftGestureEnabled = YES;   // default = NO
        popupTextView.text = customEntity.feedback;
        self.navigationItem.title = [customEntity.label stringByAppendingString:@" Feedback"];
        [popupTextView showInView:self.view.superview];
    }
    if (cellToCheck.tag == TAG_CELL_NOTES)
    {
        notesTag = TAG_CELL_NOTES;
        popupTextView = [[YIPopupTextView alloc] initWithPlaceHolder:@"Enter private REALTOR\u2122 notes and comments here." maxCount:1000];
        popupTextView.delegate = self;
        popupTextView.showCloseButton = NO;
        popupTextView.caretShiftGestureEnabled = YES;   // default = NO
        popupTextView.text = customEntity.note;
        self.navigationItem.title = [customEntity.label stringByAppendingString:@" Notes"];
        [popupTextView showInView:self.view.superview];
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
        sourceViewController.activityLog = customEntity;
        sourceViewController.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"segueContacts"]) {
        
        ContactsViewController *contactsViewController = (ContactsViewController *) segue.destinationViewController;
        contactsViewController.activityLog = customEntity;
    }
    
    
}



-(void) keyboardWillShow:(NSNotification *)note
{
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:0.3];
    
    //CGRect frame = self.textBoxToolbar.frame;
    //frame.origin.y = self.view.frame.size.height - 215.0;
    //self.textBoxToolbar.frame = frame;
    
    //[UIView commitAnimations];
    
    // Get the keyboard size
    //CGRect keyboardBounds;
    //[[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    // Detect orientation
    //UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    //CGRect frame = tableView.frame;
    
    // Start animation
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationBeginsFromCurrentState:YES];
    //[UIView setAnimationDuration:0.3f];
    
    // Reduce size of the Table view
    //if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    //    frame.size.height -= keyboardBounds.size.height;
    //else
    //    frame.size.height -= keyboardBounds.size.width;
    
    // Apply new size of table view
    //self.tableView.frame = frame;
    
    // Scroll the table view to see the TextField just above the keyboard
    //if (self.actifText)
    //{
    //    CGRect textFieldRect = [self.tableView convertRect:self.actifText.bounds fromView:self.actifText];
    //    [self.tableView scrollRectToVisible:textFieldRect animated:NO];
    //}
    
    //[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = self.textBoxToolbar.frame;
    frame.origin.y = self.view.frame.size.height;
    self.textBoxToolbar.frame = frame;
    
    [UIView commitAnimations];
}



// ----------------
// Action
// ----------------


-(IBAction) showCalendarAction {
    UIActionSheet *asheet = [[UIActionSheet alloc] initWithTitle:@"Pick the date you want to see." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Select", nil];
    [asheet setTag:1];
    [asheet showInView:[self.view superview]]; //note: in most cases this would be just self.view, but because I was doing this in a tabBar Application, I use the superview.
    [asheet setFrame:CGRectMake(0, 117, 320, 383)];
}



- (IBAction)actionButtonPressed:(id)sender {
    
    EKEventStore *store = [[EKEventStore alloc] init];
    EKEvent *event;
    
    
    if (customEntity.calendarEventIdentifier != nil)
        event = [store eventWithIdentifier:customEntity.calendarEventIdentifier];
    else
    {
        event = [EKEvent eventWithEventStore:store];
        event.startDate = customEntity.date;
        event.endDate   = [customEntity.date dateByAddingTimeInterval:1800];
        event.title = customEntity.label;
        event.location = listing.name;
        event.availability = EKEventAvailabilityBusy;
        
        EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:-3600];
        event.alarms = [NSArray arrayWithObject:alarm];
        
        if (customEntity.note != nil)
            event.notes = [customEntity.note stringByAppendingString:@"\nEntry created by ListingAgent."];
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

- (IBAction)hideKeyboardButtonPressed:(id)sender {
    [self.view endEditing:YES];
}



- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    if (action == EKEventEditViewActionSaved)
        customEntity.calendarEventIdentifier = controller.event.eventIdentifier;
    
    if (action == EKEventEditViewActionDeleted)
        customEntity.calendarEventIdentifier = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [tableView reloadData];
    
}


- (IBAction)SaveButtonPressed:(id)sender {
    
    if (notesTag > 0)
    {
        [popupTextView dismiss];
        notesTag = 0;
        //self.navigationItem.hidesBackButton = customEntity.hasChanges;
        
    }
    else
    {
        customEntity.modifiedDate = [NSDate date];
        
        [managedObjectContext save:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate CustomEventViewControllerDidSave:self];
    }
}

- (BOOL)textFieldEditingEnded:(UITextField *)textField {
    customEntity.name = textField.text;
    return YES;
}

- (IBAction)deleteButtonPressed:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Delete"
                                                    message:@"Are you sure you want to delete this custom event?"
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
        [listing removeActivityLogsObject:customEntity];
        [managedObjectContext save:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate CustomEventViewControllerDidSave:self];
    }
    
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
    customEntity.source = source;
    [tableView reloadData];
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
    NSLog(@"will dismiss");
    if (notesTag == TAG_CELL_NOTES)
        customEntity.note = text;
    
    if (notesTag == TAG_CELL_FEEDBACK)
        customEntity.feedback = text;
    
    self.navigationItem.title = @"Custom Event";
    [tableView reloadData];
}

- (void)popupTextView:(YIPopupTextView *)textView didDismissWithText:(NSString *)text
{
    NSLog(@"did dismiss");
}



@end
