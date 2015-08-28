//
//  SequenceActionManager.m
//  TutorialTool
//
//  Created by User on 11/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialSequenceActionManager.h"
#import "TutorialStoryboard.h"

@implementation TutorialSequenceActionManager

@synthesize objectTarget;

-(id) initWithStoryboard:(TutorialStoryboard *)_storyboard andSequenceData:(NSMutableDictionary *)_sequenceData {
    self = [super init];
    
    if(self) {
        storyBoardHandler = _storyboard;
        
        [self readData:_sequenceData];
    }
    
    return self;
}

- (void)readData:(NSMutableDictionary *)_sequenceData {
    currentActionIndexRunning = 0;
    //currentRepeatSequenceCounter
    
    scheduleAfterTime = [[_sequenceData objectForKey:TUTORIAL_ACTION_DATA_KEY_SCHEDULE_AFTER_TIME] floatValue];
    
    //Get taget object
    NSString *objectTargetName = [_sequenceData objectForKey:TUTORIAL_ACTION_DATA_KEY_OBJECT_NAME];
    objectTarget = [storyBoardHandler getObjectByName:objectTargetName];
    
    repeat = [[_sequenceData objectForKey:TUTORIAL_ACTION_DATA_KEY_REPEAT] intValue];
    
    //get child actions if has    
    listActionObject = [[NSMutableArray alloc] init];
    
    NSMutableArray *childActionData = [_sequenceData objectForKey:TUTORIAL_ACTION_DATA_ACTION_SEQUENCE];
    for(int i = 0; i < childActionData.count; i++) {
        NSMutableDictionary *actionDictionary = [childActionData objectAtIndex:i];
        
        TutorialAction *childAction = [[TutorialAction alloc] initTutorialActionWith:self dictionaryData:actionDictionary];
        
        [listActionObject addObject:childAction];
        [childAction release];
    }
}

- (void)runSequence {
    if(objectTarget) {
        //default we run delay first, cause scheduleAfterTime
        
        currentActionIndexRunning = -1;
        currentRepeatSequenceCounter = 1;
        
        //[self performSelector:@selector(runNextAction) withObject:nil afterDelay:scheduleAfterTime];
        [[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(runNextAction) forTarget:self interval:scheduleAfterTime paused:NO repeat:0 delay:0];
    } else {
        [self finishSequenceCallback];
    }
}

/*
 * When each action in list callback finish, this function is called to run next action of sequence
 * When run all actions in list, it call finish sequence function
 */

- (void)runNextAction {    
    NSLog(@"run sequence");
    //If repeat < 0, we repeat forever    
    if(currentRepeatSequenceCounter <= repeat || repeat < 0) {
        currentActionIndexRunning++;
        
        if(currentActionIndexRunning < listActionObject.count) {
            TutorialAction *actionObject = [listActionObject objectAtIndex:currentActionIndexRunning];
            
            [actionObject runAction];
        } else {
            //End run sequence in this repeat session
            currentRepeatSequenceCounter++;
            currentActionIndexRunning = -1;
            
            [self runNextAction];
        }
    } else {
        //End all repeat sequence
        [self finishSequenceCallback];
    }
}

//Call by action when it finished running
-(void)tutorialFinishedAction:(TutorialAction *)_action {
    [self runNextAction];
}

- (void)finishSequenceCallback {
    //callback to handler
    [storyBoardHandler tutorialFinishedAction:self];
}

- (void)stopSequence {
    [[[CCDirector sharedDirector] scheduler] unscheduleAllSelectorsForTarget:self];
}

/*
 * Release all sequence data
 */

- (void)cleanUpSequenceObject {
    [[[CCDirector sharedDirector] scheduler] unscheduleAllSelectorsForTarget:self];
    
    //[objectTarget release];
    objectTarget = nil;
    
    [storyBoardHandler release];
    storyBoardHandler = nil;
    
    [listActionObject removeAllObjects];
    [listActionObject release];
    listActionObject = nil;
}

- (void)dealloc {
    NSLog(@"Sequence manager dealloc");
    
    [self stopSequence];
    [self cleanUpSequenceObject];
    
    [super dealloc];
}

@end
