//
//  SequenceActionManager.h
//  TutorialTool
//
//  Created by User on 11/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "TutorialLibDefine.h"
#import "TutorialSpriteObject.h"
#import "CallFunctionC.h"
#import "TutorialAction.h"

@interface TutorialSequenceActionManager : NSObject {
    TutorialStoryboard *storyBoardHandler;
    
    //List action in sequence
    NSMutableArray *listActionObject;
    
    //Time delay to start action
    float scheduleAfterTime;
    int repeat;
    
    TutorialObject *objectTarget;
    
    //variables for run sequence;
    int currentActionIndexRunning;
    int currentRepeatSequenceCounter;
    
    //init timer for schedule after time
    CCTimer *mainTimer;
}

@property (retain, nonatomic) TutorialObject *objectTarget;

- (id)initWithStoryboard:(TutorialStoryboard *)_storyboard andSequenceData:(NSMutableDictionary *)_sequenceData;

- (void)readData:(NSMutableDictionary *)_sequenceData;

- (void)runSequence;
- (void)stopSequence;

-(void)tutorialFinishedAction:(TutorialAction *)_action;

@end
