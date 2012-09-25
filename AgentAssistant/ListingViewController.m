//
//  ShowingDetailViewController.m
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-08-30.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "ListingViewController.h"
#import "NoteViewController.h"
#import "Listing.h"
#import <QuartzCore/QuartzCore.h>
#import "DCRoundSwitch.h"
#import "Contact.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface ListingViewController ()

@end

@implementation ListingViewController {}


@synthesize listing;
@synthesize tableView1Data;
@synthesize tableView;
@synthesize actifText;
@synthesize fetchedResultsController;
@synthesize textView;
@synthesize saveButton;
@synthesize textBoxToolbar;

@synthesize managedObjectContext;


#define kDatePickerTag 100
#define TAG_TEXTFIELD_CONTACT_NAME  1
#define TAG_TEXTFIELD_CONTACT_COMPANY 2
#define TAG_TEXTFIELD_CONTACT_PHONE 3
#define TAG_TEXTFIELD_CONTACT_EMAIL 4

#define TAG_CELL_NAME 2
#define TAG_CELL_ADDRESS 3
#define TAG_CELL_MLS 4
#define TAG_CELL_NOTE 5
#define TAG_CELL_TAX_VALUE 6
#define TAG_CELL_DOOR_CODE 7
#define TAG_CELL_ALARM_CODE 8
#define TAG_CELL_CONTACT_SELECT  101
#define TAG_CELL_CONTACT_ADD 102


- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    
    UIDatePicker *pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    
    //Configure picker...
    [pickerView setDatePickerMode:UIDatePickerModeDateAndTime];
    [pickerView setMinuteInterval:15];
    [pickerView setTag: kDatePickerTag];
    
    //Add picker to action sheet
    [actionSheet addSubview:pickerView];
    
    //Gets an array af all of the subviews of our actionSheet
    NSArray *subviews = [actionSheet subviews];
    
    [[subviews objectAtIndex:1] setFrame:CGRectMake(20, 235, 280, 46)];
    [[subviews objectAtIndex:2] setFrame:CGRectMake(20, 295, 280, 46)];
    
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
    
    
    if (listing == nil)
    {
        listing = (Listing *)[NSEntityDescription insertNewObjectForEntityForName:@"Listing" inManagedObjectContext:managedObjectContext];
        listing.createdDate = [NSDate date];
        
        [managedObjectContext save:nil];
    }
    
    self.title = @"Listing";
    
    
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
    // Cell -> Name;
    // ----------------------------;
    
    
    NSMutableDictionary *tableViewCellLabelData = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCellLabel = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    tableViewCellLabel.textLabel.text = @"Name";
    tableViewCellLabel.selectionStyle = UITableViewCellSelectionStyleNone;
    tableViewCellLabel.tag = TAG_CELL_NAME;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0,10,200,35)];
    textField.textAlignment = NSTextAlignmentRight;
    textField.textColor = tableViewCellLabel.detailTextLabel.textColor;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textField.placeholder = @"Name of Listing";
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Hide" style:UIBarButtonItemStyleDone target:self action:@selector(hideKeyboardButtonPressed:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space, doneButton, nil]];
    
    textField.inputAccessoryView = toolBar;
    
    [textField addTarget:self action:@selector(textFieldNameEditingEnded:) forControlEvents:UIControlEventEditingDidEnd];
    tableViewCellLabel.accessoryView = textField;
    
    [tableViewCellLabelData setObject:tableViewCellLabel forKey:@"cell"];
    [tableViewCellLabelData setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCellLabelData setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    
    [tableViewCellLabelData setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCellLabelData setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewSectionLabelData objectForKey:@"cells"] addObject:tableViewCellLabelData];
    
    
    
    // ----------------------------;
    // Cell -> Address;
    // ----------------------------;
    
    NSMutableDictionary *tableViewCellAddressData = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCellAddress = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    tableViewCellAddress.textLabel.text = @"Address";
    tableViewCellAddress.selectionStyle = UITableViewCellSelectionStyleNone;
    tableViewCellAddress.tag = TAG_CELL_ADDRESS;
    
    UITextField *textFieldAddress = [[UITextField alloc] initWithFrame:CGRectMake(0,10,200,35)];
    textFieldAddress.textAlignment = NSTextAlignmentRight;
    textFieldAddress.textColor = tableViewCellLabel.detailTextLabel.textColor;
    textFieldAddress.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textFieldAddress.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textFieldAddress.placeholder = @"Mailing Address";
    
    textFieldAddress.inputAccessoryView = toolBar;
    
    [textFieldAddress addTarget:self action:@selector(textFieldAddressEditingEnded:) forControlEvents:UIControlEventEditingDidEnd];
    tableViewCellAddress.accessoryView = textFieldAddress;
    
    [tableViewCellAddressData setObject:tableViewCellAddress forKey:@"cell"];
    [tableViewCellAddressData setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCellAddressData setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    
    [tableViewCellAddressData setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCellAddressData setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewSectionLabelData objectForKey:@"cells"] addObject:tableViewCellAddressData];

    
    
    // ----------------------------;
    // Cell -> MLS;
    // ----------------------------;
    
    NSMutableDictionary *tableViewCellMLSData = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCellMLS = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    tableViewCellMLS.textLabel.text = @"MLS Number";
    tableViewCellMLS.selectionStyle = UITableViewCellSelectionStyleNone;
    tableViewCellMLS.tag = TAG_CELL_MLS;
    
    UITextField *textFieldMLS = [[UITextField alloc] initWithFrame:CGRectMake(0,10,150,35)];
    textFieldMLS.textAlignment = NSTextAlignmentRight;
    textFieldMLS.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textFieldMLS.textColor = tableViewCellLabel.detailTextLabel.textColor;
    textFieldMLS.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    textFieldMLS.placeholder = @"MLS number";
    
    textFieldMLS.inputAccessoryView = toolBar;
    
    [textFieldMLS addTarget:self action:@selector(textFieldMLSEditingEnded:) forControlEvents:UIControlEventEditingDidEnd];
    tableViewCellMLS.accessoryView = textFieldMLS;
    
    [tableViewCellMLSData setObject:tableViewCellMLS forKey:@"cell"];
    [tableViewCellMLSData setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCellMLSData setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    
    [tableViewCellMLSData setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCellMLSData setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewSectionLabelData objectForKey:@"cells"] addObject:tableViewCellMLSData];
    
   
    // ----------------------------;
    // Table View Section -> Contacts;
    // ----------------------------;
    
    NSMutableDictionary *tableViewSection2Data = [NSMutableDictionary dictionary];
    [tableViewSection2Data setObject:@"" forKey:@"headerText"];
    [tableViewSection2Data setObject:@"" forKey:@"footerText"];
    [tableViewSection2Data setObject:[NSMutableArray array] forKey:@"cells"];
    [self.tableView1Data addObject:tableViewSection2Data];
    
    
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
    [[tableViewSection2Data objectForKey:@"cells"] addObject:tableViewCellContactNameData];
    
    
    
    // ----------------------------;
    // Table View Section -> Reference Fields;
    // ----------------------------;
    
    NSMutableDictionary *tableViewSection3Data = [NSMutableDictionary dictionary];
    [tableViewSection3Data setObject:@"" forKey:@"headerText"];
    [tableViewSection3Data setObject:@"" forKey:@"footerText"];
    [tableViewSection3Data setObject:[NSMutableArray array] forKey:@"cells"];
    [self.tableView1Data addObject:tableViewSection3Data];
    
    
    // ----------------------------;
    // Cell -> Tax;
    // ----------------------------;
    
    NSMutableDictionary *tableViewCellTaxData = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCellTax = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    tableViewCellTax.textLabel.text = @"Tax Value";
    tableViewCellTax.selectionStyle = UITableViewCellSelectionStyleNone;
    tableViewCellTax.tag = TAG_CELL_TAX_VALUE;
    
    UITextField *textFieldTax = [[UITextField alloc] initWithFrame:CGRectMake(0,10,150,35)];
    textFieldTax.textAlignment = NSTextAlignmentRight;
    textFieldTax.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textFieldTax.textColor = tableViewCellLabel.detailTextLabel.textColor;
    textFieldTax.placeholder = @"Assessed Amount";
    textFieldTax.keyboardType = UIKeyboardTypeNumberPad;    
    
    textFieldTax.inputAccessoryView = toolBar;
    
    [textFieldTax addTarget:self action:@selector(textFieldTaxEditingEnded:) forControlEvents:UIControlEventEditingDidEnd];
    tableViewCellTax.accessoryView = textFieldTax;
    
    [tableViewCellTaxData setObject:tableViewCellTax forKey:@"cell"];
    [tableViewCellTaxData setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCellTaxData setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    
    [tableViewCellTaxData setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCellTaxData setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewSection3Data objectForKey:@"cells"] addObject:tableViewCellTaxData];

    
    // ----------------------------;
    // Cell -> Door Code;
    // ----------------------------;
    
    NSMutableDictionary *tableViewCellDoorCodeData = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCellDoorCode = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    tableViewCellDoorCode.textLabel.text = @"Door Code";
    tableViewCellDoorCode.selectionStyle = UITableViewCellSelectionStyleNone;
    tableViewCellDoorCode.tag = TAG_CELL_DOOR_CODE;
    
    UITextField *textFieldDoorCode = [[UITextField alloc] initWithFrame:CGRectMake(0,10,150,35)];
    textFieldDoorCode.textAlignment = NSTextAlignmentRight;
    textFieldDoorCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textFieldDoorCode.textColor = tableViewCellLabel.detailTextLabel.textColor;
    textFieldDoorCode.placeholder = @"Access Code";
    textFieldDoorCode.keyboardType = UIKeyboardTypeNumberPad;

    
    textFieldDoorCode.inputAccessoryView = toolBar;
    
    [textFieldDoorCode addTarget:self action:@selector(textFieldDoorCodeEditingEnded:) forControlEvents:UIControlEventEditingDidEnd];
    tableViewCellDoorCode.accessoryView = textFieldDoorCode;
    
    [tableViewCellDoorCodeData setObject:tableViewCellDoorCode forKey:@"cell"];
    [tableViewCellDoorCodeData setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCellDoorCodeData setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    
    [tableViewCellDoorCodeData setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCellDoorCodeData setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewSection3Data objectForKey:@"cells"] addObject:tableViewCellDoorCodeData];

    
    
    // ----------------------------;
    // Cell -> Alarm Code;
    // ----------------------------;
    
    NSMutableDictionary *tableViewCellAlarmCodeData = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCellAlarmCode = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    tableViewCellAlarmCode.textLabel.text = @"Alarm Code";
    tableViewCellAlarmCode.selectionStyle = UITableViewCellSelectionStyleNone;
    tableViewCellAlarmCode.tag = TAG_CELL_ALARM_CODE;
    
    UITextField *textFieldAlarmCode = [[UITextField alloc] initWithFrame:CGRectMake(0,10,150,35)];
    textFieldAlarmCode.textAlignment = NSTextAlignmentRight;
    textFieldAlarmCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textFieldAlarmCode.textColor = tableViewCellLabel.detailTextLabel.textColor;
    textFieldAlarmCode.placeholder = @"Security Code";
    textFieldAlarmCode.keyboardType = UIKeyboardTypeNumberPad;

    textFieldAlarmCode.inputAccessoryView = toolBar;
    
    [textFieldAlarmCode addTarget:self action:@selector(textFieldAlarmCodeEditingEnded:) forControlEvents:UIControlEventEditingDidEnd];
    tableViewCellAlarmCode.accessoryView = textFieldAlarmCode;
    
    [tableViewCellAlarmCodeData setObject:tableViewCellAlarmCode forKey:@"cell"];
    [tableViewCellAlarmCodeData setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCellAlarmCodeData setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    
    [tableViewCellAlarmCodeData setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCellAlarmCodeData setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewSection3Data objectForKey:@"cells"] addObject:tableViewCellAlarmCodeData];

    
    // ----------------------------;
    // Table View Section -> Reference Fields;
    // ----------------------------;
    
    NSMutableDictionary *tableViewSectionNotesData = [NSMutableDictionary dictionary];
    [tableViewSectionNotesData setObject:@"" forKey:@"headerText"];
    [tableViewSectionNotesData setObject:@"" forKey:@"footerText"];
    [tableViewSectionNotesData setObject:[NSMutableArray array] forKey:@"cells"];
    [self.tableView1Data addObject:tableViewSectionNotesData];

    
    
    // ----------------------------;
    // Cell -> Notes;
    // ----------------------------;
    
    NSMutableDictionary *tableViewCell7Data = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCell7 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    tableViewCell7.textLabel.text = @"Notes";
    tableViewCell7.tag = TAG_CELL_NOTE;
    
    tableViewCell7.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [tableViewCell7Data setObject:tableViewCell7 forKey:@"cell"];
    [tableViewCell7Data setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCell7Data setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    [tableViewCell7Data setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCell7Data setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewSectionNotesData objectForKey:@"cells"] addObject:tableViewCell7Data];
    
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
    
    if (cellToCheck.tag == TAG_CELL_NAME)
    {
        UITextField *textField = (UITextField *) cellToCheck.accessoryView;
        textField.text = listing.name;
    }
   
    if (cellToCheck.tag == TAG_CELL_MLS)
    {
        UITextField *textField = (UITextField *) cellToCheck.accessoryView;
        textField.text = listing.mlsNumber;
    }

    if (cellToCheck.tag == TAG_CELL_TAX_VALUE)
    {
        UITextField *textField = (UITextField *) cellToCheck.accessoryView;
        textField.text = [listing.taxValue stringValue];
    }
    
    if (cellToCheck.tag == TAG_CELL_DOOR_CODE)
    {
        UITextField *textField = (UITextField *) cellToCheck.accessoryView;
        textField.text = listing.doorCode;
    }

    if (cellToCheck.tag == TAG_CELL_ALARM_CODE)
    {
        UITextField *textField = (UITextField *) cellToCheck.accessoryView;
        textField.text = listing.alarmCode;
    }
    
    if (cellToCheck.tag == TAG_CELL_ADDRESS)
    {
        UITextField *textField = (UITextField *) cellToCheck.accessoryView;
        textField.text = listing.address;
    }

    
    if (cellToCheck.tag == TAG_CELL_NOTE)
        cellToCheck.detailTextLabel.text = listing.note;
    
    
    if (cellToCheck.tag == TAG_CELL_CONTACT_SELECT)
    {
        
        if (listing.contacts.count == 0)
            cellToCheck.detailTextLabel.text = nil;
        
        if (listing.contacts.count == 1)
        {
            Contact *contact = [[[listing.contacts allObjects] mutableCopy] objectAtIndex:0];
            cellToCheck.detailTextLabel.text = contact.compositeName;
        }
        
        if (listing.contacts.count > 1)
        {
            NSString *numOfContacts = [[NSNumber numberWithInt:listing.contacts.count] stringValue];
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
    if (cellToCheck.tag == TAG_CELL_NOTE)
    {
        notesTag = TAG_CELL_NOTE;
        popupTextView = [[YIPopupTextView alloc] initWithPlaceHolder:@"Enter private REALTOR\u2122 notes and comments here." maxCount:1000];
        popupTextView.delegate = self;
        popupTextView.showCloseButton = NO;
        popupTextView.caretShiftGestureEnabled = YES;   // default = NO
        popupTextView.text = listing.note;
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
    
    if ([segue.identifier isEqualToString:@"segueContacts"]) {
        
        ContactsViewController *contactsViewController = (ContactsViewController *) segue.destinationViewController;
        contactsViewController.listing = listing;
    }
    
    
}


-(void) keyboardWillShow:(NSNotification *)note
{
   
}

-(void) keyboardWillHide:(NSNotification *)note
{
    
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


- (IBAction)hideKeyboardButtonPressed:(id)sender {
    [self.view endEditing:YES];
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
        listing.modifiedDate = [NSDate date];
        
        [managedObjectContext save:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate ListingViewControllerDidSave:self];
    }
}

- (BOOL)textFieldNameEditingEnded:(UITextField *)textField {
    listing.name = textField.text;
    return YES;
}

- (BOOL)textFieldAddressEditingEnded:(UITextField *)textField {
    listing.address = textField.text;
    return YES;
}

- (BOOL)textFieldMLSEditingEnded:(UITextField *)textField {
    listing.mlsNumber = textField.text;
    return YES;
}

- (BOOL)textFieldTaxEditingEnded:(UITextField *)textField {
    listing.taxValue = [NSDecimalNumber decimalNumberWithString:textField.text];;
    return YES;
}

- (BOOL)textFieldDoorCodeEditingEnded:(UITextField *)textField {
    listing.doorCode = textField.text;
    return YES;
}

- (BOOL)textFieldAlarmCodeEditingEnded:(UITextField *)textField {
    listing.alarmCode = textField.text;
    return YES;
}



- (IBAction)deleteButtonPressed:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Delete"
                                                    message:@"Are you sure you want to permanently delete this listing and all associated events? This can not be undone."
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
        [managedObjectContext deleteObject:listing];
        [managedObjectContext save:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate ListingViewControllerDidSave:self];
    }
    
}


// ------------------
// MODAL CALLBACKS
// ------------------

#pragma mark - SourceTableViewControllerDelegate


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
    if (notesTag == TAG_CELL_NOTE)
        listing.note = text;
    
    
    self.navigationItem.title = @"Listing";
    [tableView reloadData];
}

- (void)popupTextView:(YIPopupTextView *)textView didDismissWithText:(NSString *)text
{
    NSLog(@"did dismiss");
}



@end
