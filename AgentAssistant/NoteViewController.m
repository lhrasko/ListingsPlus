//
//  NoteViewController.m
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-09-03.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "NoteViewController.h"

@interface NoteViewController ()

@end

@implementation NoteViewController

@synthesize textNote;
@synthesize activityLog;
@synthesize tag;

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
    [textNote setBorderStyle:UITextBorderStyleRoundedRect];
 
    if (tag == 1)
    {
        textNote.text = activityLog.note;
    }
    if (tag == 2)
    {
        textNote.text = activityLog.feedback;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




// ----------------
// Action
// ----------------


- (void)CancelButtonPressed:(id)sender  {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)DoneButtonPressed:(id)sender {
    
    if (tag ==1)
    {
    activityLog.note = textNote.text;
    }
    if (tag == 2)
    {
        activityLog.feedback = textNote.text;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
