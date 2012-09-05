//
//  ShowingDetailViewController.m
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-08-30.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "ShowingDetailViewController.h"
#import "NoteViewController.h"
#import "Showing.h"
#import "DataModel.h"

@interface ShowingDetailViewController ()
@end

@implementation ShowingDetailViewController{
    ShowingModel *showing;}

@synthesize listing;
@synthesize editShowing;
@synthesize tableView1Data;
@synthesize tableView;
@synthesize managedObjectContext;


#define kDatePickerTag 100


-(IBAction) showCalendarAction {
    UIActionSheet *asheet = [[UIActionSheet alloc] initWithTitle:@"Pick the date you want to see." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Select", nil];
    [asheet showInView:[self.view superview]]; //note: in most cases this would be just self.view, but because I was doing this in a tabBar Application, I use the superview.
    [asheet setFrame:CGRectMake(0, 117, 320, 383)];
}


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
    
    [[subviews objectAtIndex:1] setFrame:CGRectMake(20, 224, 280, 46)];
    [[subviews objectAtIndex:2] setFrame:CGRectMake(20, 280, 280, 46)];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        
        //Gets our picker
        UIDatePicker *ourDatePicker = (UIDatePicker *) [actionSheet viewWithTag:kDatePickerTag];
        NSDate *selectedDate = [ourDatePicker date];
        
        showing.date = selectedDate;
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
    
    showing = [ShowingModel new];

    
    if (editShowing != nil)
    {
        showing.source = editShowing.source;
        showing.date = editShowing.date;
        showing.note = editShowing.note;
        showing.feedback = editShowing.note;
        self.title = @"Edit Showing";
    }
    else
    {
        showing.date = [NSDate date];
        showing.source = @"Buyer";
    }
    
    NSArray *sourcesArray = [NSArray arrayWithObjects:@"Agent", @"Buyer", @"Website", nil];

    
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
        tableViewCell.detailTextLabel.text = @"Subtitle";
        tableViewCell.tag = 1;
        
        [tableViewCellData setObject:tableViewCell forKey:@"cell"];
        [tableViewCellData setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
        [tableViewCellData setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
        [tableViewCellData setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
        [tableViewCellData setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
        [[tableViewSectionSourceData objectForKey:@"cells"] addObject:tableViewCellData];
    }
    
    
    
    // ----------------------------;
    // Table View Section -> Optional;
    // ----------------------------;
    
    NSMutableDictionary *tableViewSection2Data = [NSMutableDictionary dictionary];
    [tableViewSection2Data setObject:@"Optional" forKey:@"headerText"];
    //[tableViewSection2Data setObject:@"'Feedback' is displayed on customer reports. 'Notes' remain confidential." forKey:@"footerText"];
    //[tableViewSection2Data setObject:@"65" forKey:@"customFooterViewHeight"];
    //[tableViewSection2Data setObject:@"YES" forKey:@"customFooterView"];
    [tableViewSection2Data setObject:[NSMutableArray array] forKey:@"cells"];
    [self.tableView1Data addObject:tableViewSection2Data];
    
    // ----------------------------;
    // Cell -> Date & Time;
    // ----------------------------;
    
    NSMutableDictionary *tableViewCell5Data = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCell5 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    tableViewCell5.textLabel.text = @"Date & Time";
    tableViewCell5.tag = 2;
    
    tableViewCell5.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [tableViewCell5Data setObject:tableViewCell5 forKey:@"cell"];
    [tableViewCell5Data setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCell5Data setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    [tableViewCell5Data setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCell5Data setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewSection2Data objectForKey:@"cells"] addObject:tableViewCell5Data];
    
    // ----------------------------;
    // Cell -> Feedback;
    // ----------------------------;
    
    NSMutableDictionary *tableViewCell6Data = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCell6 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    tableViewCell6.textLabel.text = @"Feedback";
    tableViewCell6.tag = 4;
    
    tableViewCell6.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [tableViewCell6Data setObject:tableViewCell6 forKey:@"cell"];
    [tableViewCell6Data setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCell6Data setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    [tableViewCell6Data setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCell6Data setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewSection2Data objectForKey:@"cells"] addObject:tableViewCell6Data];
  
    // ----------------------------;
    // Cell -> Notes;
    // ----------------------------;
    
    NSMutableDictionary *tableViewCell7Data = [NSMutableDictionary dictionary];
    UITableViewCell *tableViewCell7 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    tableViewCell7.textLabel.text = @"Private Notes";
    tableViewCell7.tag = 3;
    
    tableViewCell7.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [tableViewCell7Data setObject:tableViewCell7 forKey:@"cell"];
    [tableViewCell7Data setObject:[NSNumber numberWithInteger:UITableViewCellEditingStyleDelete] forKey:@"editingStyle"];
    [tableViewCell7Data setObject:[NSNumber numberWithInteger:0] forKey:@"indentationLevel"];
    [tableViewCell7Data setObject:[NSNumber numberWithFloat:44] forKey:@"height"];
    [tableViewCell7Data setObject:[NSNumber numberWithBool:YES] forKey:@"showReorderControl"];
    [[tableViewSection2Data objectForKey:@"cells"] addObject:tableViewCell7Data];
    
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
    
  
    if (cellToCheck.tag == 1){
        
        if ([cellToCheck.textLabel.text isEqualToString:[showing valueForKey:@"source"]]) {
            cellToCheck.accessoryType = UITableViewCellAccessoryCheckmark; }
        else {
            cellToCheck.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    if (cellToCheck.tag == 2)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        cellToCheck.detailTextLabel.text = [formatter stringFromDate: showing.date];
    }
    if (cellToCheck.tag == 3)
    {
        cellToCheck.detailTextLabel.text = showing.note;
    }
    if (cellToCheck.tag == 4)
    {
        cellToCheck.detailTextLabel.text = showing.feedback;
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

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        NSDictionary *sectionData = [self.tableView1Data objectAtIndex:indexPath.section];
        NSDictionary *cellData =  [[sectionData objectForKey:@"cells"] objectAtIndex:indexPath.row];
    
        UITableViewCell *cellToCheck = [cellData objectForKey:@"cell"];

        // checkmark formating to select only the currently selected on
        if (cellToCheck.tag == 1)
        {
            showing.source = cellToCheck.textLabel.text;
            [self.tableView reloadData];
        }
    
        if (cellToCheck.tag == 2)
        {
            [self showCalendarAction];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        if (cellToCheck.tag == 3)
        {
            notesTag = 1;
            [self performSegueWithIdentifier:@"segueNotes" sender:self];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        if (cellToCheck.tag == 4)
        {
            notesTag = 2;
            [self performSegueWithIdentifier:@"segueNotes" sender:self];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    
        NSString *actionSelector = [cellData objectForKey:@"actionSelector"];
        if (actionSelector) {;
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            [self performSelector:NSSelectorFromString(actionSelector) withObject:cell];
        };
}



int notesTag;


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueNotes"]) {
        NoteViewController *destViewController = segue.destinationViewController;
        destViewController.tag = notesTag;
        destViewController.activityLog = showing;
    }
}






// ----------------
// Action
// ----------------


- (IBAction)CancelButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)SaveButtonPressed:(id)sender {
    if (editShowing != nil)
    {
        editShowing.date = showing.date;
        editShowing.note = showing.note;
        editShowing.source = showing.source;
        editShowing.ModifiedDate = [NSDate date];
    }
    else
    {
        Showing *showingEntity = (Showing *)[NSEntityDescription insertNewObjectForEntityForName:@"Showing" inManagedObjectContext:managedObjectContext];
        showingEntity.date = showing.date;
        showingEntity.note = showing.note;
        showingEntity.feedback = showing.feedback;
        showingEntity.source = showing.source;
        showingEntity.createdDate = [NSDate date];
        showingEntity.listing = listing;

        [listing.activityLogs addObject:showingEntity];
    }
    
    [managedObjectContext save:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) dateDetailButtonPressed {
    UIActionSheet *asheet = [[UIActionSheet alloc] initWithTitle:@"Pick the date you want to see." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Select", nil];
    [asheet showInView:self.view]; //note: in most cases this would be just self.view, but because I was doing this in a tabBar Application, I use the superview.
    [asheet setFrame:CGRectMake(0, 80, 320, 400)];
}


- (void)didTap_tableViewCell1:(UIView *)cell {
    
}

@end
