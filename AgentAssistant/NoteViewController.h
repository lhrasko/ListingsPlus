//
//  NoteViewController.h
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-09-03.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "YIPopupTextView.h"

@class NoteViewController;

@interface NoteViewController : UIViewController <YIPopupTextViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *viewController;
@property (nonatomic, strong) ActivityLogModel *activityLog;
@property int tag;

@property (weak, nonatomic) IBOutlet SSTextView *textNote;
- (IBAction)doneButtonPressed:(id)sender;

@end
