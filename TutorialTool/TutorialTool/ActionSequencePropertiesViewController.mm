//
//  ActionSequencePropertiesViewController.m
//  TutorialTool
//
//  Created by User on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActionSequencePropertiesViewController.h"
#import "TutorialToolDefine.h"
#import "ToolUtil.h"
#import "MainWindow.h"
#import "TutorialData.h"

@interface ActionSequencePropertiesViewController ()

@end

@implementation ActionSequencePropertiesViewController

@synthesize popupButtonObjTarget;
@synthesize txtStartAfetrTime;
@synthesize currentSequenceIndex;
@synthesize currentStoryIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(id)initWithMainWindow:(MainWindow *)_mainWindow {
    self = [super initWithNibName:@"ActionSequencePropertiesViewController" bundle:nil];
    
    if(self) {
        mainWindow = _mainWindow;
        currentSequenceIndex = -1;
        currentStoryIndex = -1;
        
        [self awakeFromNib];
    }
    
    return self;
}

-(void)awakeFromNib {        
    //show default view
    [self showDefaultView];
    //[self showTotalTimeToRunProperties];
}

////////////////////////////////////////////////////////////////////////////////////////////
// functions

-(void)resetValue {
    currentStoryIndex = -1;
    currentSequenceIndex = -1;
    currentSequenceData = nil;
}

-(void)showTotalTimeToRunProperties {    
    NSRect totalTimeframe = NSMakeRect(0, 0, viewPropertyTotalTime.frame.size.width, viewPropertyTotalTime.frame.size.height);
    [viewPropertyTotalTime setFrame:totalTimeframe];
    
    NSRect newMainViewFrame = NSMakeRect(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height + totalTimeframe.size.height);
    [self.view setFrame:newMainViewFrame];
    
    [self.view addSubview:viewPropertyTotalTime];
}

-(void)showDefaultView {
    NSRect oldFrame = self.view.frame;
    [viewPropertyTotalTime removeFromSuperview];
    
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + (oldFrame.size.height - DEFAULT_FRAME_HEIGHT - viewPropertyTotalTime.frame.size.height), self.view.frame.size.width, DEFAULT_FRAME_HEIGHT)];
}

-(void)bindActionSequenceData:(NSMutableDictionary *)_sequenceAction withSeqenceIndex:(int)_sequenceIndex withStoryIndex:(int)_storyIndex
{
    //Fill list object name first
    [self fillObjectNameIntoPopupButtonWithStoryIndex:_storyIndex];
    
    currentSequenceData = _sequenceAction;
    currentSequenceIndex = _sequenceIndex;
    currentStoryIndex = _storyIndex;
    
    [txtStartAfetrTime setStringValue:[NSString stringWithFormat:@"%.0f", [[_sequenceAction objectForKey:TUTORIAL_ACTION_DATA_KEY_SCHEDULE_AFTER_TIME] floatValue] * 1000]];
    
    [popupButtonObjTarget selectItemWithTitle:[_sequenceAction objectForKey:TUTORIAL_ACTION_DATA_KEY_OBJECT_NAME]];
    
    [txtRepeat setStringValue:[_sequenceAction objectForKey:TUTORIAL_ACTION_DATA_KEY_REPEAT]];
    
    [txtEaseRate setStringValue:[_sequenceAction objectForKey:TUTORIAL_ACTION_DATA_ACTION_EASE_RATE]];
    
    [txtEasePeriod setStringValue:[_sequenceAction objectForKey:TUTORIAL_ACTION_DATA_ACTION_EASE_PERIOD]];
    
    if([popupButtonObjTarget titleOfSelectedItem] == nil)
    {
        //default none target
        [popupButtonObjTarget selectItemWithTitle:@"None target"];
        
        [self changeTargetName:nil];
    }
}

- (void)fillObjectNameIntoPopupButtonWithStoryIndex:(int)_storyIndex
{
    [popupButtonObjTarget removeAllItems];
    //default none target
    [popupButtonObjTarget addItemWithTitle:@"None target"];
    
    NSMutableArray *listObjectName = [mainWindow getListObjectNameInStory:_storyIndex];
    
    for(NSString *objectName in listObjectName)
    {
        [popupButtonObjTarget addItemWithTitle:objectName];
    }
}

-(void)updateActionSequenceDataFromGUI {
    
    NSString *actionSequenceType = @"Sequence"; //Default value for all sequence
    [currentSequenceData setObject:[ToolUtil setString:actionSequenceType] forKey:TUTORIAL_ACTION_DATA_KEY_ACTION_TYPE];
    
    [currentSequenceData setObject:[ToolUtil setString:popupButtonObjTarget.titleOfSelectedItem] forKey:TUTORIAL_ACTION_DATA_KEY_OBJECT_NAME];
    
    [currentSequenceData setObject:[NSString stringWithFormat:@"%.03f", [txtStartAfetrTime.stringValue floatValue] / 1000.0f] forKey:TUTORIAL_ACTION_DATA_KEY_SCHEDULE_AFTER_TIME];
    
    [currentSequenceData setObject:[ToolUtil setString:txtEaseRate.stringValue] forKey:TUTORIAL_ACTION_DATA_ACTION_EASE_RATE];
    
    [currentSequenceData setObject:[ToolUtil setString:txtEasePeriod.stringValue] forKey:TUTORIAL_ACTION_DATA_ACTION_EASE_PERIOD];
    
    [currentSequenceData setObject:[ToolUtil setString:txtRepeat.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_REPEAT];

    [mainWindow updateActionSequenceConfig:currentSequenceData sequenceIndex:currentSequenceIndex storyIndex:currentStoryIndex];
}

-(void)updateTotalTimeToRunSequence
{
    if(currentSequenceIndex >= 0)
    {
        //show total time to run this action sequence
        float totalTimeToRun = [TutorialData getTotalDurationTimeOfActionSequence:currentSequenceData];
        
        txtTotalTimeToRun.stringValue = [NSString stringWithFormat:@"%.02f", totalTimeToRun];
    }
    else
    {
        //show total time to run this action sequence
        txtTotalTimeToRun.stringValue = @"0";
    }
}

-(NSMutableDictionary *)getDefaultDataConfigs {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    //default is cocos2d sequence
    [result setObject:@"Sequence" forKey:TUTORIAL_ACTION_DATA_KEY_ACTION_TYPE];
    
    [result setObject:[ToolUtil setString:popupButtonObjTarget.titleOfSelectedItem] forKey:TUTORIAL_ACTION_DATA_KEY_OBJECT_NAME];
    
    [result setObject:[NSString stringWithFormat:@"%.03f", [txtStartAfetrTime.stringValue floatValue] / 1000.0f] forKey:TUTORIAL_ACTION_DATA_KEY_SCHEDULE_AFTER_TIME];
    
    [result setObject:[ToolUtil setString:txtEaseRate.stringValue] forKey:TUTORIAL_ACTION_DATA_ACTION_EASE_RATE];
    
    [result setObject:[ToolUtil setString:txtEasePeriod.stringValue] forKey:TUTORIAL_ACTION_DATA_ACTION_EASE_PERIOD];
    
    [result setObject:[ToolUtil setString:txtRepeat.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_REPEAT];
    
    return result;
}

- (IBAction)changeTargetName:(id)sender
{
    NSLog(@"Taget name: %@", popupButtonObjTarget.titleOfSelectedItem);
    
    [self updateActionSequenceDataFromGUI];
}

////////////////////////////////////////////////////////////////////////////////////////////
// control delegate

-(void)controlTextDidChange:(NSNotification *)obj {
    NSLog(@"Test did change");
    [self updateActionSequenceDataFromGUI];
    [mainWindow updateGUISequenceWhenChangeConfig];
    [mainWindow redrawAnimationTimeLine];
}

@end
