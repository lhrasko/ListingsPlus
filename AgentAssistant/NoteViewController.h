//
//  NoteViewController.h
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-09-03.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@class NoteViewController;

@protocol NoteViewControllerDelegate <NSObject>
- (void)NoteViewControllerDidCancel:(NoteViewController *)controller;
- (void)NoteViewControllerDidSave:(NoteViewController *)controller tag:(int)tag text:(NSString *)text;
@end



@interface NoteViewController : UIViewController

@property (nonatomic, weak) id <NoteViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *viewController;
@property (nonatomic, strong) ActivityLogModel *activityLog;
@property int tag;

@property (weak, nonatomic) IBOutlet UITextView *textNote;

@end
