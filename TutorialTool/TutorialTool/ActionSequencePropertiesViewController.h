//
//  ActionSequencePropertiesViewController.h
//  TutorialTool
//
//  Created by User on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define DEFAULT_FRAME_HEIGHT    114

@class MainWindow;

@interface ActionSequencePropertiesViewController : NSViewController <NSComboBoxDelegate> {
    MainWindow *mainWindow;
    
    NSMutableDictionary *currentSequenceData;
    int currentSequenceIndex;
    int currentStoryIndex;
    
    IBOutlet NSView *viewMainProperties;
    IBOutlet NSView *viewPropertyTotalTime;
    
    //Control for each property
    IBOutlet NSTextField *txtStartAfetrTime;
    IBOutlet NSTextField *txtRepeat;
    IBOutlet NSTextField *txtEaseRate;
    IBOutlet NSTextField *txtEasePeriod;
    IBOutlet NSTextField *txtTotalTimeToRun;
    IBOutlet NSPopUpButton *popupButtonObjTarget;
}

@property (retain, nonatomic) IBOutlet NSPopUpButton *popupButtonObjTarget;
@property (retain, nonatomic) IBOutlet NSTextField *txtStartAfetrTime;
@property (nonatomic) int currentSequenceIndex;
@property (nonatomic) int currentStoryIndex;

- (id)initWithMainWindow:(MainWindow *)_mainWindow;

- (void)resetValue;
- (void)bindActionSequenceData:(NSMutableDictionary *)_sequenceAction withSeqenceIndex:(int)_sequenceIndex withStoryIndex:(int)_storyIndex;

- (void)fillObjectNameIntoPopupButtonWithStoryIndex:(int)_storyIndex;

- (void)updateActionSequenceDataFromGUI;
- (void)updateTotalTimeToRunSequence;
- (NSMutableDictionary *)getDefaultDataConfigs;

- (IBAction)changeTargetName:(id)sender;

@end
