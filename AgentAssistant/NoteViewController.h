//
//  NoteViewController.h
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-09-03.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface NoteViewController : UIViewController

@property (nonatomic, strong) ActivityLogModel *activityLog;
@property (weak, nonatomic) IBOutlet UITextField *textNote;
@property int tag;


- (IBAction)DoneButtonPressed:(id)sender;

- (IBAction)CancelButtonPressed:(id)sender;
@end
