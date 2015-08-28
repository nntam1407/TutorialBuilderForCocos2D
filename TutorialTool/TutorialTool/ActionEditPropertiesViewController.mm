//
//  ActionEditPropertiesViewController.m
//  TutorialTool
//
//  Created by User on 11/9/12.
//
//

#import "ActionEditPropertiesViewController.h"
#import "ToolUtil.h"
#import "TutorialData.h"
#import "MainWindow.h"
#import "TutorialSpriteLib.h"
#import "MovingInterpolationController.h"

@interface ActionEditPropertiesViewController ()

@end

@implementation ActionEditPropertiesViewController

@synthesize isChoosePoint;
@synthesize isMovingPointRecord;
@synthesize textFieldDuration;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(id)initWithMainWindow:(MainWindow *)_mainWindow {
    self = [super initWithNibName:@"ActionEditPropertiesViewController" bundle:nil];
    
    if(self) {
        mainWindow = _mainWindow;
        
        [self awakeFromNib];
    }
    
    return self;
}

-(void)awakeFromNib {
    currentActionData = nil;
    currentActionIndex = -1;
    currentSequenceIndex = -1;
    currentStoryIndex = -1;
    
    isMovingPointRecord = false;
    isChoosePoint = false;
    
    [comboBoxClockwise selectItemAtIndex:0];
    [comboBoxInscrease selectItemAtIndex:0];
    [comboBoxPositive selectItemAtIndex:0];
    
    
    //Fill list action type default is standard cocos action
    [self fillListActionNameForComboBox];
    //set default is first action in list
    [comboBoxChooseActionType selectItemAtIndex:0];
    
    [self fillListEaseTypeForComboBox:ACTION_TYPE_COCOS_2D];
    [comboBoxEaseType selectItemAtIndex:0];
    
    //Default set tooltip of comboxBox action type is callFunctionInGame
    comboBoxChooseActionType.toolTip = listActionTypesDescriptions[0];
}

///////////////////////////////////////////////////////
// GUI functions

-(void)resetToDefaultView {
    NSRect oldFrame = self.view.frame;
    
    [viewFunctionName removeFromSuperview];
    [viewDuration removeFromSuperview];
    [viewJumps removeFromSuperview];
    [viewOpacity removeFromSuperview];
    [viewHeight removeFromSuperview];
    [viewDestination removeFromSuperview];
    [viewScale removeFromSuperview];
    [viewAngle removeFromSuperview];
    [viewRecordListPoint removeFromSuperview];
    [viewAmlitututeStartEnd removeFromSuperview];
    [viewAmlitute removeFromSuperview];
    [viewMovingLoop removeFromSuperview];
    [viewPositive removeFromSuperview];
    [viewClockwise removeFromSuperview];
    [viewInscrease removeFromSuperview];
    [viewDistInterval removeFromSuperview];
    [viewNumSpring removeFromSuperview];
    [viewAnimationConfig removeFromSuperview];
    [viewEaseType removeFromSuperview];
    [viewPropertyEasePeriod removeFromSuperview];
    [viewPropertyEaseRate removeFromSuperview];
    
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + (oldFrame.size.height - DEFAULT_VIEW_FRAME_HEIGHT), self.view.frame.size.width, DEFAULT_VIEW_FRAME_HEIGHT)];
}

-(void)addNSViewControl:(NSView *)_view {
    NSRect addViewFrame = NSMakeRect(0, 0, _view.frame.size.width, _view.frame.size.height);
    [_view setFrame:addViewFrame];
    
    NSRect newMainViewFrame = NSMakeRect(self.view.frame.origin.x, self.view.frame.origin.y - addViewFrame.size.height, self.view.frame.size.width, self.view.frame.size.height + addViewFrame.size.height);
    [self.view setFrame:newMainViewFrame];
    
    [self.view addSubview:_view];
}

-(void)showControllWithActionName:(NSString *)_actionName {
    [self resetToDefaultView];
    [buttonRecordPoint setTitle:@"Start record"];
    
    if([_actionName isEqualToString:TUTORIAL_ACTION_CALL_FUNCTION_IN_GAME]) {
        
        [self addNSViewControl:viewFunctionName];
        
    } else if([_actionName isEqualToString:TUTORIAL_ACTION_MOVING_CALL_FUNCTION_IN_GAME]) {
        
        [self addNSViewControl:viewFunctionName];
        
    } else if([_actionName isEqualToString:TUTORIAL_ACTION_MOVE_TO]) {
        
        [self addNSViewControl:viewDuration];
        [self addNSViewControl:viewDestination];
        [self addNSViewControl:viewEaseType];
        
    } else if([_actionName isEqualToString:TUTORIAL_ACTION_MOVE_BY]) {
        
        [self addNSViewControl:viewDuration];
        [self addNSViewControl:viewDestination];
        [self addNSViewControl:viewEaseType];
    } else if([_actionName isEqualToString:TUTORIAL_ACTION_FADE_IN]) {
        
        [self addNSViewControl:viewDuration];
        
    } else if([_actionName isEqualToString:TUTORIAL_ACTION_FADE_OUT]) {
        
        [self addNSViewControl:viewDuration];
        
    } else if([_actionName isEqualToString:TUTORIAL_ACTION_FADE_TO]) {
        
        [self addNSViewControl:viewDuration];
        [self addNSViewControl:viewOpacity];
        
    } else if([_actionName isEqualToString:TUTORIAL_ACTION_SCALE_TO]) {
        
        [self addNSViewControl:viewDuration];
        [self addNSViewControl:viewScale];
        
    } else if([_actionName isEqualToString:TUTORIAL_ACTION_SCALE_BY]) {
        
        [self addNSViewControl:viewDuration];
        [self addNSViewControl:viewScale];
        
    } else if([_actionName isEqualToString:TUTORIAL_ACTION_ROTATE_TO]) {
        
        [self addNSViewControl:viewDuration];
        [self addNSViewControl:viewAngle];
        [self addNSViewControl:viewEaseType];        
        
    } else if([_actionName isEqualToString:TUTORIAL_ACTION_ROTATE_BY]) {
        
        [self addNSViewControl:viewDuration];
        [self addNSViewControl:viewAngle];
         [self addNSViewControl:viewEaseType];
        
    } else if([_actionName isEqualToString:TUTORIAL_ACTION_JUMP_TO]) {
        
        [self addNSViewControl:viewDuration];
        [self addNSViewControl:viewDestination];
        [self addNSViewControl:viewJumps];
        [self addNSViewControl:viewHeight];
        [self addNSViewControl:viewEaseType];        
    } else if([_actionName isEqualToString:TUTORIAL_ACTION_JUMP_BY]) {
        
        [self addNSViewControl:viewDuration];
        [self addNSViewControl:viewDestination];
        [self addNSViewControl:viewJumps];
        [self addNSViewControl:viewHeight];
        [self addNSViewControl:viewEaseType];        
    } else if([_actionName isEqualToString:TUTORIAL_ACTION_PLACE]) {

        [self addNSViewControl:viewDestination];
        
    } else if([_actionName isEqualToString:TUTORIAL_ACTION_DELAY]) {
        
        [self addNSViewControl:viewDuration];
        
    } else if([_actionName isEqualToString:TUTORIAL_ACTION_RUN_ANIMATION]) {
        
        [self addNSViewControl:viewAnimationConfig];
        
    } else if([_actionName isEqualToString:TUTORIAL_ACTION_LINEAR_MOVING]) {
        
        [self addNSViewControl:viewDuration];
        [self addNSViewControl:viewDestination];
        [self addNSViewControl:viewEaseType];
        
    } else if([_actionName isEqualToString:TUTORIAL_ACTION_ZICZAC_MOVING]) {
        
        [self addNSViewControl:viewDuration];
        [self addNSViewControl:viewDestination];
        [self addNSViewControl:viewAmlitututeStartEnd];
        [self addNSViewControl:viewMovingLoop];
        [self addNSViewControl:viewPositive];
        [self addNSViewControl:viewEaseType];

    } else if([_actionName isEqualToString:TUTORIAL_ACTION_ELIP_MOVING]) {
        
        [self addNSViewControl:viewDuration];
        [self addNSViewControl:viewDestination];
        [self addNSViewControl:viewAmlitute];
        [self addNSViewControl:viewClockwise];
        [self addNSViewControl:viewEaseType];

    } else if([_actionName isEqualToString:TUTORIAL_ACTION_ROUND_MOVING]) {
        
        [self addNSViewControl:viewDuration];
        [self addNSViewControl:viewDestination];
        [self addNSViewControl:viewClockwise];
        [self addNSViewControl:viewEaseType];

    } else if([_actionName isEqualToString:TUTORIAL_ACTION_SPRING_MOVING]) {
        
        [self addNSViewControl:viewDuration];
        [self addNSViewControl:viewDestination];
        [self addNSViewControl:viewAmlitute];
        [self addNSViewControl:viewMovingLoop];
        [self addNSViewControl:viewDistInterval];
        [self addNSViewControl:viewPositive];
        [self addNSViewControl:viewEaseType];

    } else if([_actionName isEqualToString:TUTORIAL_ACTION_FERMAT_SPIRAL_MOVING]) {
        
        [self addNSViewControl:viewDuration];
        [self addNSViewControl:viewDestination];
        [self addNSViewControl:viewEaseType];

    } else if([_actionName isEqualToString:TUTORIAL_ACTION_WAVY_SIN_MOVING]) {
        
        [self addNSViewControl:viewDuration];
        [self addNSViewControl:viewDestination];
        [self addNSViewControl:viewAmlitute];
        [self addNSViewControl:viewMovingLoop];
        [self addNSViewControl:viewPositive];
        [self addNSViewControl:viewEaseType];

    } else if([_actionName isEqualToString:TUTORIAL_ACTION_CUSTOM_SPRING_MOVING]) {
        
        [self addNSViewControl:viewDuration];
        [self addNSViewControl:viewDestination];
        [self addNSViewControl:viewAmlitututeStartEnd];
        [self addNSViewControl:viewDistInterval];
        [self addNSViewControl:viewNumSpring];
        [self addNSViewControl:viewPositive];
        [self addNSViewControl:viewInscrease];
        [self addNSViewControl:viewEaseType];

    } else if([_actionName isEqualToString:TUTORIAL_ACTION_MOVING_DELAY]) {
        
        [self addNSViewControl:viewDuration];
        
    } else if([_actionName isEqualToString:TUTORIAL_ACTION_ON_POINT_MOVING]) {
        
        [self addNSViewControl:viewDuration];
        [self addNSViewControl:viewRecordListPoint];
        [self addNSViewControl:viewEaseType];

    }
    
    //Redraw action edit view frame (to show scroll rule right position)
    [mainWindow showActionEditRightBar];
}

////////////////////////////////////////////////////
// Functions

-(void)resetValue {
    currentStoryIndex = -1;
    currentSequenceIndex = -1;
    currentActionIndex = -1;
    currentActionData = nil;
}

-(void)bindDataWith:(NSMutableDictionary *)_actionData actionIndex:(int)_actionIndex sequenceIndex:(int)_seqIndex storyIndex:(int)_storyIndex {
    
    currentActionData = _actionData;
    currentActionIndex = _actionIndex;
    currentStoryIndex = _storyIndex;
    currentSequenceIndex = _seqIndex;
    
    isMovingPointRecord = false;
    listPointRecorded = nil;
    
    isChoosePoint = false;
    [buttonChoosePoint setEnabled:true];
    
    [textFieldDuration setEnabled:YES];
    [comboBoxChooseActionType setEnabled:YES];
    [buttonRecordPoint setStringValue:@"Start record"];
    
    [textFieldDuration setStringValue:[NSString stringWithFormat:@"%.0f", [[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue] * 1000]];
    
    [textFieldDestination_X setStringValue:[ToolUtil setString:[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_X]]];
    
    [textFieldDestination_Y setStringValue:[ToolUtil setString:[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_Y]]];
    
    [textFieldAngle setStringValue:[ToolUtil setString:[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ROTATE_ANGLE]]];
    
    [textFieldScaleX setStringValue:[ToolUtil setString:[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_SCALE_X]]];

    [textFieldScaleY setStringValue:[ToolUtil setString:[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_SCALE_Y]]];
    
    [textFieldJumps setStringValue:[ToolUtil setString:[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_JUMPS]]];
    
    [textFieldHeight setStringValue:[ToolUtil setString:[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_JUMP_HEIGHT]]];
    
    [textFieldOpacity setStringValue:[ToolUtil setString:[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_FADE_OPACITY]]];
    
    [textFieldCallFunctionName setStringValue:[ToolUtil setString:[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_NAME_OF_FUNCTION_IN_GAME]]];
    
    textFieldStartAmlitute.stringValue = [ToolUtil setString:[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_START_Amplitude]];
    
    textFieldEndAmlitute.stringValue = [ToolUtil setString:[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_END_Amplitude]];
    
    textFieldAmlitute.stringValue = [ToolUtil setString:[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_Amplitude]];
    
    textFieldMovingLoop.stringValue = [ToolUtil setString:[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_LOOP]];
    
    textFieldDistanceInterval.stringValue = [ToolUtil setString:[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_DISTANCE_INTERVAL]];
    
    textFieldNumberSpring.stringValue = [ToolUtil setString:[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_NUMBER_SPRING]];
    
    textFieldFrameDelay.stringValue = [NSString stringWithFormat:@"%.0f", [[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_FRAME_DELAY] floatValue] * 1000];
    
    textFieldAnimationLoop.stringValue = [ToolUtil setString:[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_LOOP]];
    
    textFieldAnimationLoopDelay.stringValue = [ToolUtil setString:[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_LOOP_DELAY]];
    
    BOOL positive = [[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_POSITIVE] boolValue];
    if(positive)
        [comboBoxPositive selectItemAtIndex:0];
    else
        [comboBoxPositive selectItemAtIndex:1];
    
    BOOL clockwise = [[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_CLOCKWISE] boolValue];
    if(clockwise)
        [comboBoxClockwise selectItemAtIndex:0];
    else
        [comboBoxClockwise selectItemAtIndex:1];
    
    BOOL Inscrease = [[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_INCREASE] boolValue];
    if(Inscrease)
        [comboBoxInscrease selectItemAtIndex:0];
    else
        [comboBoxInscrease selectItemAtIndex:1];
    
    BOOL isRestoreOriginalFrame = [[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_RESTORE_FRAME] boolValue];
    if(isRestoreOriginalFrame)
        [checkBoxRestoreOriginalFrame setState:NSOnState];
    else
        [checkBoxRestoreOriginalFrame setState:NSOffState];
    
    textFieldEaseRate.stringValue = [ToolUtil setString:[_actionData objectForKey:TUTORIAL_ACTION_DATA_ACTION_EASE_RATE]];
    
    textFieldEasePeriod.stringValue = [ToolUtil setString:[_actionData objectForKey:TUTORIAL_ACTION_DATA_ACTION_EASE_PERIOD]];
    
    [tableViewListFrameOfTexture reloadData];
    [tableViewFrameUsed reloadData];
    
    //cause after changed action type of comboBox, delegate didChangeSelection was called, and _actionData was changed, so we put it end of this function
    NSString *actionType = [_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ACTION_TYPE];
    [comboBoxChooseActionType selectItemWithObjectValue:actionType];
    
    NSString *easeType = [_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_EASE_TYPE];
    
    [comboBoxEaseType selectItemWithObjectValue:easeType];

    //Show control neccesary
    [self showControllWithActionName:actionType];

    [self changeSelectedEaseType];
}

-(void)updateDataFromGUI {
    NSString *actionType = comboBoxChooseActionType.objectValueOfSelectedItem;
    
    if(actionType)
        [currentActionData setObject:actionType forKey:TUTORIAL_ACTION_DATA_KEY_ACTION_TYPE];
    
    NSString *easeType = comboBoxEaseType.objectValueOfSelectedItem;
    
    if(easeType)
        [currentActionData setObject:easeType forKey:TUTORIAL_ACTION_DATA_KEY_EASE_TYPE];
    
    [currentActionData setObject:[ToolUtil setString:textFieldEaseRate.stringValue] forKey:TUTORIAL_ACTION_DATA_ACTION_EASE_RATE];
    
    [currentActionData setObject:[ToolUtil setString:textFieldEasePeriod.stringValue] forKey:TUTORIAL_ACTION_DATA_ACTION_EASE_PERIOD];
    
    //Set first value for action dictionary data
    [currentActionData setObject:[NSString stringWithFormat:@"%.03f", [textFieldDuration.stringValue floatValue] / 1000.0f] forKey:TUTORIAL_ACTION_DATA_KEY_DURATION];
    
    [currentActionData setObject:[ToolUtil setString:textFieldDestination_X.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_X];
    
    [currentActionData setObject:textFieldDestination_Y.stringValue forKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_Y];
    
    [currentActionData setObject:[ToolUtil setString:textFieldAngle.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_ROTATE_ANGLE];
    
    [currentActionData setObject:[ToolUtil setString:textFieldScaleX.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_SCALE_X];
    
    [currentActionData setObject:[ToolUtil setString:textFieldScaleY.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_SCALE_Y];
    
    
    [currentActionData setObject:[ToolUtil setString:textFieldJumps.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_JUMPS];
    
    [currentActionData setObject:[ToolUtil setString:textFieldHeight.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_JUMP_HEIGHT];
    
    [currentActionData setObject:[ToolUtil setString:textFieldOpacity.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_FADE_OPACITY];
    
    [currentActionData setObject:[ToolUtil setString:textFieldCallFunctionName.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_NAME_OF_FUNCTION_IN_GAME];
    
    [currentActionData setObject:[ToolUtil setString:textFieldStartAmlitute.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_START_Amplitude];
    
    [currentActionData setObject:[ToolUtil setString:textFieldEndAmlitute.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_END_Amplitude];
    
    [currentActionData setObject:[ToolUtil setString:textFieldAmlitute.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_Amplitude];
    
    [currentActionData setObject:[ToolUtil setString:textFieldMovingLoop.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_LOOP];
    
    [currentActionData setObject:[ToolUtil setString:textFieldDistanceInterval.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_DISTANCE_INTERVAL];
    
    [currentActionData setObject:textFieldNumberSpring.stringValue forKey:TUTORIAL_ACTION_DATA_KEY_NUMBER_SPRING];
    
    [currentActionData setObject:comboBoxPositive.objectValueOfSelectedItem forKey:TUTORIAL_ACTION_DATA_KEY_POSITIVE];
    
    [currentActionData setObject:comboBoxInscrease.objectValueOfSelectedItem forKey:TUTORIAL_ACTION_DATA_KEY_INCREASE];
    
    [currentActionData setObject:comboBoxClockwise.objectValueOfSelectedItem forKey:TUTORIAL_ACTION_DATA_KEY_CLOCKWISE];
    
    NSLog(@"Value: %@", comboBoxClockwise.objectValueOfSelectedItem);
    
    [currentActionData setObject:[NSString stringWithFormat:@"%.03f", [textFieldFrameDelay.stringValue floatValue]/1000.0f] forKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_FRAME_DELAY];
    
    [currentActionData setObject:[ToolUtil setString:textFieldAnimationLoop.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_LOOP];
    
    [currentActionData setObject:[ToolUtil setString:textFieldAnimationLoopDelay.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_LOOP_DELAY];
    
    if(checkBoxRestoreOriginalFrame.state == NSOnState)
        [currentActionData setObject:@"YES" forKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_RESTORE_FRAME];
    else
        [currentActionData setObject:@"NO" forKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_RESTORE_FRAME];
    
    [mainWindow updateActionWithData:currentActionData atIndex:currentActionIndex atSeqIndex:currentSequenceIndex atStoryIndex:currentStoryIndex];
}

-(void)fillListActionNameForComboBox {
    [comboBoxChooseActionType removeAllItems];
        
    for(int i = 0; i < LIST_ACTION_TYPE_COUNT; i++) {
        [comboBoxChooseActionType addItemWithObjectValue:[NSString stringWithFormat:@"%@", listActionTypes[i]]];
    }
    
        //set default is first action in list
    if(currentActionData) {
        NSString *actionName = [currentActionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ACTION_TYPE];
        
        [comboBoxChooseActionType selectItemWithObjectValue:actionName];
    } else {
        [comboBoxChooseActionType selectItemAtIndex:0];
    }
}

-(void)fillListEaseTypeForComboBox:(int)_actionType{
    [comboBoxEaseType removeAllItems];
    
    if(_actionType == ACTION_TYPE_COCOS_2D) {
        
        for(int i = 0; i < LIST_COCOS_EASE_TYPE_COUNT; i++) {
            [comboBoxEaseType addItemWithObjectValue:[NSString stringWithFormat:@"%@", listCocosEaseType[i]]];
        }
        
    } else if(_actionType == ACTION_TYPE_MOVING) {
        
        for(int i = 0; i < LIST_MOVING_EASE_TYPE_COUNT; i++) {
            [comboBoxEaseType addItemWithObjectValue:[NSString stringWithFormat:@"%@", listMovingEaseType[i]]];
        }
        
    }
    
    //set default is first action in list
    if(currentActionData) {
        NSString *easeType = [currentActionData objectForKey:TUTORIAL_ACTION_DATA_KEY_EASE_TYPE];
        
        [comboBoxEaseType selectItemWithObjectValue:easeType];
        
        if (comboBoxEaseType.indexOfSelectedItem < 0){
            [comboBoxEaseType selectItemAtIndex:0];
        }
        
    } else {
        [comboBoxEaseType selectItemAtIndex:0];
    }
}



-(NSMutableDictionary *)getDefaultDataConfigs {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    NSString *actionType = comboBoxChooseActionType.objectValueOfSelectedItem;
    
    if(actionType)
        [result setObject:actionType forKey:TUTORIAL_ACTION_DATA_KEY_ACTION_TYPE];
    
    NSString *easeType = comboBoxEaseType.objectValueOfSelectedItem;
    
    if(easeType)
        [result setObject:easeType forKey:TUTORIAL_ACTION_DATA_KEY_EASE_TYPE];
    
    [result setObject:[ToolUtil setString:textFieldEaseRate.stringValue] forKey:TUTORIAL_ACTION_DATA_ACTION_EASE_RATE];
    
    [result setObject:[ToolUtil setString:textFieldEasePeriod.stringValue] forKey:TUTORIAL_ACTION_DATA_ACTION_EASE_PERIOD];
    
    //Set first value for action dictionary data
    [result setObject:[NSString stringWithFormat:@"%.03f", [textFieldDuration.stringValue floatValue] / 1000.0f] forKey:TUTORIAL_ACTION_DATA_KEY_DURATION];
    
    [result setObject:[ToolUtil setString:textFieldDestination_X.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_X];
    
    [result setObject:textFieldDestination_Y.stringValue forKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_Y];
    
    [result setObject:[ToolUtil setString:textFieldAngle.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_ROTATE_ANGLE];
    
    [result setObject:[ToolUtil setString:textFieldScaleX.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_SCALE_X];
    
    [result setObject:[ToolUtil setString:textFieldScaleY.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_SCALE_Y];
    
    [result setObject:[ToolUtil setString:textFieldJumps.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_JUMPS];
    
    [result setObject:[ToolUtil setString:textFieldHeight.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_JUMP_HEIGHT];
    
    [result setObject:[ToolUtil setString:textFieldOpacity.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_FADE_OPACITY];
    
    [result setObject:[ToolUtil setString:textFieldCallFunctionName.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_NAME_OF_FUNCTION_IN_GAME];
    
    [result setObject:[ToolUtil setString:textFieldStartAmlitute.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_START_Amplitude];
    
    [result setObject:[ToolUtil setString:textFieldEndAmlitute.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_END_Amplitude];
    
    [result setObject:[ToolUtil setString:textFieldAmlitute.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_Amplitude];
    
    [result setObject:[ToolUtil setString:textFieldMovingLoop.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_LOOP];
    
    [result setObject:[ToolUtil setString:textFieldDistanceInterval.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_DISTANCE_INTERVAL];
    
    [result setObject:textFieldNumberSpring.stringValue forKey:TUTORIAL_ACTION_DATA_KEY_NUMBER_SPRING];
    
    [result setObject:comboBoxPositive.objectValueOfSelectedItem forKey:TUTORIAL_ACTION_DATA_KEY_POSITIVE];
    
    [result setObject:comboBoxInscrease.objectValueOfSelectedItem forKey:TUTORIAL_ACTION_DATA_KEY_INCREASE];
    
    [result setObject:comboBoxClockwise.objectValueOfSelectedItem forKey:TUTORIAL_ACTION_DATA_KEY_CLOCKWISE];
    
    [result setObject:[NSString stringWithFormat:@"%.03f", [textFieldFrameDelay.stringValue floatValue]/1000.0f] forKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_FRAME_DELAY];
    
    [result setObject:[ToolUtil setString:textFieldAnimationLoop.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_LOOP];
    
    [result setObject:[ToolUtil setString:textFieldAnimationLoopDelay.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_LOOP_DELAY];
    
    if(checkBoxRestoreOriginalFrame.state == NSOnState)
        [result setObject:@"YES" forKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_RESTORE_FRAME];
    else
        [result setObject:@"NO" forKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_RESTORE_FRAME];
    
    return result;
}

-(void)changeSelectedActionType {
    //Show action description
    int selectedIndex = (int)[comboBoxChooseActionType indexOfSelectedItem];
    comboBoxChooseActionType.toolTip = listActionTypesDescriptions[selectedIndex];
    
    NSString *actionName = [comboBoxChooseActionType objectValueOfSelectedItem];
    [self showControllWithActionName:actionName];
    
    [self fillListEaseTypeForComboBox:[ToolUtil checkTypeActionSelected:actionName]];
    //[currentActionData objectForKey:TUTORIAL_ACTION_DATA_KEY_EASE_TYPE];
    //[comboBoxEaseType selectItemWithObjectValue:[currentActionData objectForKey:TUTORIAL_ACTION_DATA_KEY_EASE_TYPE]];

    
    [self updateDataFromGUI];
    [mainWindow redrawAnimationTimeLine];
}

-(void)changeSelectedEaseType {    
    
    NSString *actionEaseType = comboBoxEaseType.objectValueOfSelectedItem;

    NSString *actionName = [comboBoxChooseActionType objectValueOfSelectedItem];
    [viewPropertyEaseRate removeFromSuperview];
    [viewPropertyEasePeriod removeFromSuperview];
    
    [self showControllWithActionName:actionName];

    if (viewEaseType.superview){
        if([actionEaseType isEqualToString:@"EaseIn"] || [actionEaseType isEqualToString:@"EaseOut"] || [actionEaseType isEqualToString:@"EaseInOut"]) {
            
            [self addNSViewControl:viewPropertyEaseRate];
        }
        
        if([actionEaseType isEqualToString:@"EaseElasticIn"] || [actionEaseType isEqualToString:@"EaseElasticOut"] || [actionEaseType isEqualToString:@"EaseElasticInOut"]){
            
            
            [self addNSViewControl:viewPropertyEasePeriod];
        }
    }

    
    [self updateDataFromGUI];
    
    //rewrite action data if change config of action    

}


////////////////////////////////////////////////////
// IBOutlet functions

-(IBAction)restoreOriginalFrameChange:(id)sender {
    if(currentActionData) {
        [self updateDataFromGUI];
    }
}

-(IBAction)buttonRecordPointClicked:(id)sender {
    if(isMovingPointRecord) {
        isMovingPointRecord = false;
        [buttonRecordPoint setTitle:@"Start record"];
        
        [comboBoxChooseActionType setEnabled:true];
        [textFieldDuration setEditable:true];
        
        if(listPointRecorded.count > 0) {
            //rewrite action data if change config of action
            //split listPointRecorded into array with less point
            //hold last point
            NSValue *lastPoint = [listPointRecorded objectAtIndex:listPointRecorded.count - 1];
            
            listPointRecorded = [MovingInterpolationController pointCurveWith:listPointRecorded andEpsilon:SPLIT_LIST_ON_POINT_EPXILON_VALUE];
            
            [listPointRecorded addObject:lastPoint];
            
            if(currentActionIndex >= 0) {                
                [TutorialData addPointList:listPointRecorded toOnPointMovingAction:currentActionData];
                
                [mainWindow updateActionWithData:currentActionData atIndex:currentActionIndex atSeqIndex:currentSequenceIndex atStoryIndex:currentStoryIndex];
            }
            
            //set object to first start before moving
            CGPoint firstPoint = [[listPointRecorded objectAtIndex:0] pointValue];
            
            [mainWindow updateCurrentObjectSelectedWithPoint:firstPoint];
        }
    } else {
        isMovingPointRecord = true;
        [buttonRecordPoint setTitle:@"Stop record"];
        
        [comboBoxChooseActionType setEnabled:false];
        [textFieldDuration setEnabled:false];
        
        listPointRecorded = [[NSMutableArray alloc] init];
    }
}

-(void)objectWithName:(NSString *)_objectName isMovingToPoint:(CGPoint)_point {
    // first we check this program is staying record point mode
    // then check name of object which is moving is object name of action
    
    if(isMovingPointRecord) {
        NSString *objectTargetOfActionName = mainWindow.viewEditActionSequence.popupButtonObjTarget.titleOfSelectedItem;
        
        if([objectTargetOfActionName isEqualToString:_objectName]) {
            NSValue *pointValue = [NSValue valueWithPoint:_point];
            [listPointRecorded addObject:pointValue];
        }
    }
}

-(IBAction)addFrameToListFrameUsed:(id)sender {    
    int frameChoosedIndex = (int)tableViewListFrameOfTexture.selectedRow;
    
    if(currentStoryIndex >= 0 && currentActionIndex >= 0 && currentSequenceIndex >= 0 && frameChoosedIndex >= 0) {
        
        NSMutableArray *listFrameInActionData = [TutorialData getListFramesFromAnimationData:currentActionData];
        
        if(!listFrameInActionData) {
            [TutorialData addListFrames:[[NSMutableArray alloc] init] toAnimationAction:currentActionData];
        }
        
        NSString *frameChoosedValue = [[mainWindow getAllFrameNameOfListTexturePlistAdded] objectAtIndex:frameChoosedIndex];
        
        [TutorialData addFrame:frameChoosedValue toAnimationAction:currentActionData];
        
        [mainWindow updateActionWithData:currentActionData atIndex:currentActionIndex atSeqIndex:currentSequenceIndex atStoryIndex:currentStoryIndex];
        [mainWindow redrawAnimationTimeLine];
        
        [tableViewFrameUsed reloadData];
    }
}

-(IBAction)removeFrameFromListFrameUsed:(id)sender {    
    int frameChoosedIndex = (int)tableViewFrameUsed.selectedRow;
    
    if(currentStoryIndex >= 0 && currentActionIndex >= 0 && currentSequenceIndex >= 0 && frameChoosedIndex >= 0) {
        
        [TutorialData removeFrameAtIndex:frameChoosedIndex fromAnimationAction:currentActionData];
        
        [mainWindow updateActionWithData:currentActionData atIndex:currentActionIndex atSeqIndex:currentSequenceIndex atStoryIndex:currentStoryIndex];
        [mainWindow redrawAnimationTimeLine];
        
        [tableViewFrameUsed reloadData];
    }
}

-(void)changeDurationWith:(float)_delta {
    if(currentStoryIndex >= 0 && currentSequenceIndex >= 0 && currentActionIndex >= 0) {
        NSString *actionType = [currentActionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ACTION_TYPE];
        
        if ([actionType isEqualToString:TUTORIAL_ACTION_RUN_ANIMATION]){
            
            NSMutableArray *listAnimationFrames = [currentActionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_LIST_FRAMES];
            
            float frameDelay = [[currentActionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_FRAME_DELAY ] floatValue];
            
            float newFrameDelay = ((listAnimationFrames.count * frameDelay) + _delta) / listAnimationFrames.count;
            
            [currentActionData setValue:[NSString stringWithFormat:@"%.03f",newFrameDelay] forKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_FRAME_DELAY];
            
            textFieldFrameDelay.stringValue = [NSString stringWithFormat:@"%.0f",newFrameDelay*1000];
            
        }else{
            
            textFieldDuration.stringValue = [NSString stringWithFormat:@"%.03f",textFieldDuration.stringValue.floatValue + _delta];
            
            [currentActionData setValue:textFieldDuration.stringValue forKey:TUTORIAL_ACTION_DATA_KEY_DURATION];
        }
        
        [mainWindow updateActionWithData:currentActionData atIndex:currentActionIndex atSeqIndex:currentSequenceIndex atStoryIndex:currentStoryIndex];
    }
}

-(void)updateDurationWith:(float)_durationTime {
    if(currentStoryIndex >= 0 && currentSequenceIndex >= 0 && currentActionIndex >= 0) {
        NSString *actionType = [currentActionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ACTION_TYPE];
        
        if ([actionType isEqualToString:TUTORIAL_ACTION_RUN_ANIMATION]){
            
            NSMutableArray *listAnimationFrames = [currentActionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_LIST_FRAMES];
            
            //float frameDelay = [[currentActionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_FRAME_DELAY ] floatValue];
            
            float newFrameDelay = _durationTime / listAnimationFrames.count;
            
            [currentActionData setValue:[NSString stringWithFormat:@"%.03f",newFrameDelay] forKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_FRAME_DELAY];
            
            textFieldFrameDelay.stringValue = [NSString stringWithFormat:@"%.0f",newFrameDelay*1000];
            
        }else{
            
            textFieldDuration.stringValue = [NSString stringWithFormat:@"%.0f",_durationTime * 1000];
            
            [currentActionData setValue:[NSString stringWithFormat:@"%.03f", _durationTime] forKey:TUTORIAL_ACTION_DATA_KEY_DURATION];
        }
        
        [mainWindow updateActionWithData:currentActionData atIndex:currentActionIndex atSeqIndex:currentSequenceIndex atStoryIndex:currentStoryIndex];
    }
}

////////////////////////////////////////////////////
// NSController delegate

-(void)comboBoxSelectionDidChange:(NSNotification *)notification {
    if(notification.object == comboBoxChooseActionType) {
        [self changeSelectedActionType];
    }
    if(notification.object == comboBoxEaseType) {
        [self changeSelectedEaseType];
    }
    if(notification.object == comboBoxInscrease || notification.object ==comboBoxPositive || notification.object ==comboBoxClockwise){
        [self updateDataFromGUI];
    }
}

-(void)controlTextDidChange:(NSNotification *)obj {
    if(currentSequenceIndex >= 0 && currentActionIndex >= 0) {
        [self updateDataFromGUI];
        [tableViewFrameUsed reloadData];
        
        [mainWindow redrawAnimationTimeLine];
    }
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    NSString *value = nil;
    
    
    if(tableView == tableViewListFrameOfTexture) {
        NSMutableArray *allFrameName = [mainWindow getAllFrameNameOfListTexturePlistAdded];
        
        value = [allFrameName objectAtIndex:row];
    }
    
    if(tableView == tableViewFrameUsed) {
        NSMutableArray *listFrameUsed = [TutorialData getListFramesFromAnimationData:currentActionData];
        
        if(listFrameUsed.count > 0)
            value = [listFrameUsed objectAtIndex:row];
    }
    
    return value;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    int rowCount = 0;
    
    if(tableView == tableViewListFrameOfTexture) {
        rowCount = (int)[mainWindow getAllFrameNameOfListTexturePlistAdded].count;
    }
    
    if(tableView == tableViewFrameUsed) {
        NSMutableArray *listFrameUsed = [TutorialData getListFramesFromAnimationData:currentActionData];
        
        rowCount = (int)listFrameUsed.count;
    }
    
    return rowCount;
}

-(IBAction)buttonChoosePointClick:(id)sender {
    if(isChoosePoint) {
        isChoosePoint = false;
        [buttonChoosePoint setEnabled:true];
    } else {
        isChoosePoint = true;
        [buttonChoosePoint setEnabled:false];
    }
}

-(void)setPointOfMouseClickedOnCocosView:(CGPoint)_point {
    if(isChoosePoint) {
        if(currentSequenceIndex >= 0 && currentActionIndex >= 0) {
            [textFieldDestination_X setStringValue:[NSString stringWithFormat:@"%.0f", _point.x]];
            [textFieldDestination_Y setStringValue:[NSString stringWithFormat:@"%.0f", _point.y]];
            
            [self updateDataFromGUI];
            [mainWindow redrawAnimationTimeLine];
            
            [self buttonChoosePointClick:nil];
        }
    }
}

@end
