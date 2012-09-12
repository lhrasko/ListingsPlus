//
//  NoteViewController.m
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-09-03.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "NoteViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface NoteViewController ()

@end

@implementation NoteViewController

@synthesize textNote;
@synthesize activityLog;
@synthesize tag;
@synthesize delegate;
@synthesize viewController;

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
    [textNote.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [textNote.layer setBorderColor: [[UIColor grayColor] CGColor]];
   
    [textNote.layer setBorderWidth: 1.0];
    [textNote.layer setCornerRadius:5.0f];
    [textNote.layer setShadowColor: [[UIColor darkGrayColor] CGColor]];
    [textNote.layer setShadowOffset:CGSizeMake(1,1)];
    [textNote.layer setMasksToBounds:YES];

    if (tag == 1)
    {
        self.title = @"Note";
        textNote.text = activityLog.note;
    }
    if (tag == 2)
    {
        self.title = @"Feedback";
        textNote.text = activityLog.feedback;
    }
    
    [textNote becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




// ----------------
// Action
// ----------------


- (IBAction)cancelButtonPressed:(id)sender {
   	[self.delegate NoteViewControllerDidCancel:self];}


- (IBAction)doneButtonPressed:(id)sender {
    
	[self.delegate NoteViewControllerDidSave:self tag:self.tag text:textNote.text];
}



@end
