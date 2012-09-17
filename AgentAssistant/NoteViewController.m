//
//  NoteViewController.m
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-09-03.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "NoteViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SSTextView.h"
#import "YIPopupTextView.h"

@interface NoteViewController ()

@end

@implementation NoteViewController

@synthesize textNote;
@synthesize activityLog;
@synthesize tag;
@synthesize viewController;

YIPopupTextView* popupTextView;


#define TAG_NOTES 3
#define TAG_FEEDBACK 4


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
    
    
    popupTextView = [[YIPopupTextView alloc] initWithPlaceHolder:@"Enter feedback for clients here" maxCount:1000];
    popupTextView.delegate = self;
    popupTextView.caretShiftGestureEnabled = YES;   // default = NO
    popupTextView.showCloseButton = NO;
  
    
    if (tag == TAG_NOTES)
    {
        self.title = @"Note";
        popupTextView.text = activityLog.note;
        popupTextView.placeholder = @"Enter REALTOR\u2122 notes and comments here.";

    }
    if (tag == TAG_FEEDBACK)
    {
        self.title = @"Feedback";
        popupTextView.text = activityLog.feedback;
        popupTextView.placeholder = @"Enter feedback to share with clients here.";
    }
    
    [popupTextView showInView:self.view];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)doneButtonPressed:(id)sender {
    if (tag == TAG_NOTES)
        activityLog.note = popupTextView.text;
    
    if (tag == TAG_FEEDBACK)
        activityLog.feedback = popupTextView.text;

    [self.navigationController popViewControllerAnimated:YES];
}


@end
