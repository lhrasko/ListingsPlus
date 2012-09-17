//
//  ListingEditViewController.m
//  Agent Assist
//
//  Created by Lubos Hrasko on 2012-09-04.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "ListingEditViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ListingEditViewController ()

@end

@implementation ListingEditViewController {}


@synthesize listing;
@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize textListingName;
@synthesize segmentedButton;

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
    if (listing == nil) {
        textListingName.text = nil;
        self.title = @"New Listing";
        [textListingName becomeFirstResponder];

    } else {
        textListingName.text = listing.name;
        self.title = @"Edit Listing";

        
        // Load our image normally.
        UIImage *image = [UIImage imageNamed:@"button_red.png"];
    
        // And create the stretchy version.
        float w = image.size.width / 2, h = image.size.height / 2; UIImage *stretch = [image stretchableImageWithLeftCapWidth:w topCapHeight:h];
        
        // Now we'll create a button as per usual.
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(30.0f, 260.0f, 260.0f, 52.0f);
        [button setBackgroundImage:stretch forState:UIControlStateNormal];
        [button setTitle:@"Delete Listing" forState:UIControlStateNormal];
        [self.view addSubview:button];
        
    }
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grouptableview.png"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// ----------------
// Action
// ----------------



- (IBAction)CancelButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)SaveButtonPressed:(id)sender {
    
    if (listing == nil){
        listing = (Listing *)[NSEntityDescription insertNewObjectForEntityForName:@"Listing" inManagedObjectContext:managedObjectContext];
    }

    listing.name = textListingName.text;
    [managedObjectContext save:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
