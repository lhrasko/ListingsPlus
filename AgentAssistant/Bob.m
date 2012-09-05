//
//  OpenHouseViewController.m
//  Interface
//
//  Generated by Interface 2
//  http://lesscode.co.nz/interface
//

#import "Bob.h"
//#import "DatePickerViewController.h"
//#import "TimePickerViewController.h"

//#import "GradientView.h"
//#import "MKMapView+ZoomLevel.h"

@implementation Bob
@synthesize tableView1Data;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ----------------------------;
    // View Controller Root View;
    // ----------------------------;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // ----------------------------;
    // UINavigationBar -> navigationBar1;
    // ----------------------------;
    
    UINavigationBar *navigationBar1 = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    navigationBar1.delegate = (id<UINavigationBarDelegate>)self;
    UINavigationItem *navigationBar1BackItem = [[UINavigationItem alloc] initWithTitle:nil];
    UINavigationItem *navigationBar1TopItem = [[UINavigationItem alloc] initWithTitle:nil] ;
    NSArray *navigationBar1Items = [NSArray arrayWithObjects:navigationBar1BackItem, navigationBar1TopItem, nil];
    [navigationBar1 setItems:navigationBar1Items animated:NO];
    [contentView addSubview:navigationBar1];
    navigationBar1.alpha = 1.0;
    navigationBar1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    navigationBar1.barStyle = UIBarStyleDefault;
    navigationBar1.topItem.title = @"New Open House";
    [navigationBar1 setTitleVerticalPositionAdjustment:0.0 forBarMetrics:UIBarMetricsDefault];
    
    // ----------------------------;
    // Navigation Bar Left Button -> cancelButton;
    // ----------------------------;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:nil] ;
    cancelButton.target = self;
    cancelButton.action = @selector(CancelButtonPressed:forEvent:);
    
    self.navigationItem.leftBarButtonItem  = cancelButton;
    self.navigationItem.hidesBackButton = YES;
 
    
    // ----------------------------;
    // Navigation Bar Right Button -> saveButton;
    // ----------------------------;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:nil action:nil] ;
    saveButton.target = self;
    saveButton.action = @selector(SaveButtonPressed:forEvent:);
    
    self.navigationItem.rightBarButtonItem  = saveButton;
    
    
    // ----------------------------;
    // UITabBar -> tabBar1;
    // ----------------------------;
    
    UITabBar *tabBar1 = [[UITabBar alloc] initWithFrame:CGRectMake(0, 411, 320, 49)];
    tabBar1.tag = 1;
    tabBar1.delegate = (id<UITabBarDelegate>)self;
    [contentView addSubview:tabBar1];
    tabBar1.alpha = 1.0;
    tabBar1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
    // ----------------------------;
    // Tab Bar Item -> tabBarItem1;
    // ----------------------------;
    
    UITabBarItem *tabBarItem1 = [[UITabBarItem alloc] initWithTitle:@"Tab Item" image:[UIImage imageNamed:@"OpenHouseViewController_Image_1.png"] tag:1] ;
    
    
    // ----------------------------;
    // Tab Bar Item -> tabBarItem2;
    // ----------------------------;
    
    UITabBarItem *tabBarItem2 = [[UITabBarItem alloc] initWithTitle:@"Tab Item" image:[UIImage imageNamed:@"OpenHouseViewController_Image_2.png"] tag:2] ;
    
    
    // ----------------------------;
    // Tab Bar Item -> tabBarItem3;
    // ----------------------------;
    
    UITabBarItem *tabBarItem3 = [[UITabBarItem alloc] initWithTitle:@"Tab Item" image:[UIImage imageNamed:@"OpenHouseViewController_Image_3.png"] tag:3] ;
    
    tabBar1.items = [NSArray arrayWithObjects:tabBarItem1, tabBarItem2, tabBarItem3, nil];
    
    // ----------------------------;
    // UITableView -> tableView1;
    // ----------------------------;
    
    UITableView *tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 367) style:UITableViewStyleGrouped];
    tableView1.tag = 1;
    tableView1.delegate = (id<UITableViewDelegate>)self;
    tableView1.dataSource = (id<UITableViewDataSource>)self;
    self.tableView1Data = [NSMutableArray array];
    [contentView addSubview:tableView1];
    tableView1.alpha = 1.0;
    tableView1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView1.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    tableView1.separatorColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.18];
    
    
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
    label1.text = @"People";
    label1.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    label1.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    label1.textAlignment = UITextAlignmentLeft;
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
    label2.textAlignment = UITextAlignmentRight;
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
    
    contentView.frame = self.view.bounds;
    [self.view addSubview:contentView];
}

- (void)viewDidUnload {
    self.tableView1Data = nil;
    [super viewDidUnload];
}

- (void)dealloc {
    self.tableView1Data = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
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


// ----------------
// Navigation Bar
// ----------------

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    [self CancelButtonPressed:nil forEvent:nil];
    return NO;
}

// ----------------
// Action
// ----------------



- (void)CancelButtonPressed:(id)sender forEvent:(UIEvent *)event {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)SaveButtonPressed:(id)sender forEvent:(UIEvent *)event {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didTap_tableViewCell1:(UIView *)cell {
    //DatePickerViewController *controller = [[DatePickerViewController alloc] init];
    //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    //[navigationController setNavigationBarHidden:YES animated:NO];
    //navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    //[self presentModalViewController:navigationController animated:YES];
}
- (void)didTap_tableViewCell2:(UIView *)cell {
    //TimePickerViewController *controller = [[TimePickerViewController alloc] init];
    //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    //[navigationController setNavigationBarHidden:YES animated:NO];
    //navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    //[self presentModalViewController:navigationController animated:YES];
}
- (void)didTap_tableViewCell3:(UIView *)cell {
    //TimePickerViewController *controller = [[TimePickerViewController alloc] init];
    //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    //[navigationController setNavigationBarHidden:YES animated:NO];
    //navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    //[self presentModalViewController:navigationController animated:YES];
}




@end