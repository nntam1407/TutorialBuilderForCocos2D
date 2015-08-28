//
//  TutorialAction.m
//  LibGame
//
//  Created by User on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialLibDefine.h"
#import "TutorialAction.h"
#import "TutorialStoryboard.h"
#import "TutorialSpriteLib.h"
#import "TutorialSequenceActionManager.h"
#import "cocos2d.h"

#import "MovingSequence.h"
#import "MovingDelay.h"
#import "CallFunctionC.h"
#import "LinearMovingController.h"
#import "MovingRepeat.h"
#import "MovingSequence.h"
#import "MovingRepeatForever.h"
#import "WavySinMovingController.h"
#import "FermatSpiralMovingController.h"
#import "RoundMovingController.h"
#import "ZiczacMovingController.h"
#import "SpringMovingController.h"
#import "ElipMovingController.h"
#import "CustomSpringMovingController.h"
#import "TutorialSpriteLib.h"
#import "MovingEaseIn.h"
#import "MovingEaseOut.h"
#import "MovingEaseInOut.h"
#import "MovingEaseOutIn.h"
#import "MovingRevert.h"
#import "MovingRevertForever.h"
#import "OnPointsMovingController.h"

@implementation TutorialAction

@synthesize actionName, easeType, objectTargetName;
@synthesize objectTagetOrderZIndex;
@synthesize functionInGameName;
@synthesize repeat, period, rate, angle;
@synthesize animationLoop, animationLoopDelay, animationFrameDelay, animationRestoreOriginalFrame;
@synthesize destinationPoint, duration, scaleX, scaleY;
@synthesize jumpHeight, jumpCount;
@synthesize fadeOpacity;
@synthesize movingLoop, movingAmplitude, movingStartAmplitude, movingEndAmplitude;
@synthesize movingDistanceInterval, movingClockwise, movingIncrease, movingNumberSpring, movingPositive;
@synthesize listAnimationFrameName;
@synthesize listPointOfOnPointMoving;

-(id)initTutorialActionWith:(TutorialSequenceActionManager *)_sequenceManager dictionaryData:(NSMutableDictionary *)_actionData {
    self = [super init];
    
    sequenceManager = _sequenceManager;
    
    listChildActions = [[NSMutableArray alloc] init];
    listPointOfOnPointMoving = [[NSMutableArray alloc] init];

    //read value from NSMultableDictionary action data
    [self readParameterValueFromDict:_actionData];
    
    return self;
}

-(void)readParameterValueFromDict:(NSDictionary *)_actionDictData {
    scheduleTime = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_SCHEDULE_AFTER_TIME] floatValue];
    actionName = [_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_ACTION_TYPE];
    
    easeType = [_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_EASE_TYPE];
    
    objectTargetName = [_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_OBJECT_NAME];
    
    objectTagetOrderZIndex = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_REORDER_OBJECT_Z_INDEX] intValue];
    
    functionInGameName = [_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_NAME_OF_FUNCTION_IN_GAME];
    
    repeat = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_REPEAT] intValue];
    
    rate = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_ACTION_EASE_RATE] floatValue];
    period = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_ACTION_EASE_PERIOD] floatValue];
    
    float desPointX = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_X] floatValue];
    float desPointY = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_Y] floatValue];
    destinationPoint = CGPointMake(desPointX, desPointY);
    
    duration = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    
    jumpHeight = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_JUMP_HEIGHT] floatValue];
    jumpCount = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_JUMPS] intValue];
    
    fadeOpacity = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_FADE_OPACITY] floatValue];
    
    scaleX = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_SCALE_X] floatValue];
    scaleY = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_SCALE_Y] floatValue];
    
    angle = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_ROTATE_ANGLE] floatValue];
    
    animationLoop = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_LOOP] intValue];
    animationLoopDelay = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_LOOP_DELAY] floatValue];
    animationFrameDelay = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_FRAME_DELAY] floatValue];
    animationRestoreOriginalFrame = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_RESTORE_FRAME] boolValue];
    
    listAnimationFrameName = [_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_LIST_FRAMES];
    
    movingStartAmplitude = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_START_Amplitude] floatValue];
    movingEndAmplitude = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_END_Amplitude] floatValue];
    movingLoop = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_LOOP] intValue];
    movingPositive = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_POSITIVE] boolValue];
    movingAmplitude = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_Amplitude] floatValue];
    movingClockwise = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_CLOCKWISE] boolValue];
    movingDistanceInterval = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DISTANCE_INTERVAL] floatValue];
    movingNumberSpring = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_NUMBER_SPRING] intValue];
    movingIncrease = [[_actionDictData objectForKey:TUTORIAL_ACTION_DATA_KEY_INCREASE] boolValue];
    
    //get child actions if has    
    NSMutableArray *childActionData = [_actionDictData objectForKey:TUTORIAL_ACTION_DATA_ACTION_SEQUENCE];
    for(int i = 0; i < childActionData.count; i++) {
        NSMutableDictionary *actionDictionary = [childActionData objectAtIndex:i];
        
        TutorialAction *childAction = [[TutorialAction alloc] initTutorialActionWith:sequenceManager dictionaryData:actionDictionary];

        [listChildActions addObject:childAction];
        [childAction release];
    }
    
    //get list point of onpoint moving action if has    
    NSMutableArray *listPointData = [_actionDictData objectForKey:TUTORIAL_ACTION_ON_POINT_MOVING_LIST_POINT];
    
    for(int i = 0; i < listPointData.count; i++) {
        float posX = [[[listPointData objectAtIndex:i] objectForKey:TUTORIAL_ACTION_ON_POINT_MOVING_LIST_POINT_PARAMETER_POS_X] floatValue];
        
        float posY = [[[listPointData objectAtIndex:i] objectForKey:TUTORIAL_ACTION_ON_POINT_MOVING_LIST_POINT_PARAMETER_POS_Y] floatValue];
        
        [listPointOfOnPointMoving addObject:[NSValue valueWithPoint:CGPointMake(posX, posY)]];
    }
}

-(void)runAction {     
    /*
        - Get action from dictionary data
        - Check it is movingController or cocos2d Action
     */
    
    id action = [self getActionValue];
    
    if([action isKindOfClass:[MovingController class]]) {
        
        [self runMovingActionWith:action];
        
    } else if([action isKindOfClass:[CCAction class]]) {
        
        [self runActionWith:action];
        
    } else {
        
        [self finishedActionCallback];
        
    }
}

-(void)runActionWith:(id)_action {
    TutorialObject *targetObject = sequenceManager.objectTarget;
    
    finishedCallback = [CCCallFunc actionWithTarget:self selector:@selector(finishedActionCallback)];
    
    //reorder z_index of object refore run
    [self reorderZIndexOfObjectTarget:targetObject];
    
    [targetObject.spriteBody runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0], _action, finishedCallback, nil]];
}

-(void)runMovingActionWith:(id)_action {
    TutorialObject *targetObject = sequenceManager.objectTarget;
    
    finishedCallback = [CallFunctionC actionWithTarget:self selector:@selector(finishedActionCallback)];
    
    //reorder z_index of object refore run
    [self reorderZIndexOfObjectTarget:targetObject];
    
    [targetObject moveWith:[MovingSequence movingControllers:_action, finishedCallback, nil]];
}

-(void)pauseAction {
    
}

-(void)stopAction {
    
}

//called active object in game for storyboard
-(void)callFunctionInGameActionCallback:(id)_targetObj {
    NSLog(@"Object in game name = %@", functionInGameName);
    
    //[storyboardHandler tutorialActionCallFunctionInGame:functionInGameName];
}

//Call storyboard it finished running
-(void)finishedActionCallback {
    [sequenceManager tutorialFinishedAction:self];
}

-(TutorialAction *)getChildActionAtIndex:(int)_index {
    if(_index >= 0 && _index < listChildActions.count) {
        return [listChildActions objectAtIndex:_index];
    }
    
    return nil;
}

-(BOOL)updateChildActionAtIndex:(int)_index withAction:(TutorialAction *)_action {
    if(_index >= 0 && _index < listChildActions.count && _action != nil) {
        [listChildActions replaceObjectAtIndex:_index withObject:_action];
        
        return true;
    }
    
    return false;
}

-(void)reorderZIndexOfObjectTarget:(TutorialObject *)_target {
    [_target.spriteBody.parent reorderChild:_target.spriteBody z:objectTagetOrderZIndex];
}

-(void)dealloc {
    NSLog(@"Tutorial action dealloc");
    
    actionName = nil;
    objectTargetName = nil;
    
    [listAnimationFrameName removeAllObjects];
    
    [listPointOfOnPointMoving removeAllObjects];
    [listPointOfOnPointMoving release];
    listPointOfOnPointMoving = nil;
    
    [listChildActions removeAllObjects];
    [listChildActions release];
    listChildActions = nil;
    
    [super dealloc];
}

-(id)getActionValue {
    id action = nil;
    
    if([actionName isEqualToString:TUTORIAL_ACTION_CALL_FUNCTION_IN_GAME]) {
        
        action = [CCCallFunc actionWithTarget:self selector:@selector(callFunctionInGameActionCallback:)];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_MOVING_CALL_FUNCTION_IN_GAME]) {
        
        action = [CallFunctionC actionWithTarget:self selector:@selector(callFunctionInGameActionCallback:)];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_MOVE_TO]) {
        
        action = [CCMoveTo actionWithDuration:duration position:destinationPoint];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_MOVE_BY]) {
        
        action = [CCMoveBy actionWithDuration:duration position:destinationPoint];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_JUMP_TO]) {
        
        action = [CCJumpTo actionWithDuration:duration position:destinationPoint height:jumpHeight jumps:jumpCount];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_JUMP_BY]) {
        
        action = [CCJumpBy actionWithDuration:duration position:destinationPoint height:jumpHeight jumps:jumpCount];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_SHOW]) {
        
        action = [[CCShow alloc]init];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_HIDE]) {
        
        action = [CCHide action];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_FADE_IN]) {
        
        action = [CCFadeIn actionWithDuration:duration];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_FADE_OUT]) {
        
        action = [CCFadeOut actionWithDuration:duration];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_FADE_TO]) {
        
        action = [CCFadeTo actionWithDuration:duration opacity:fadeOpacity];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_SCALE_TO]) {
        
        action = [CCScaleTo actionWithDuration:duration scaleX:scaleX scaleY:scaleY];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_SCALE_BY]) {
        
        action = [CCScaleBy actionWithDuration:duration scaleX:scaleX scaleY:scaleY];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_ROTATE_TO]) {
        
        action = [CCRotateTo actionWithDuration:duration angle:angle];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_ROTATE_BY]) {
        
        action = [CCRotateBy actionWithDuration:duration angle:angle];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_PLACE]) {
        
        action = [CCPlace actionWithPosition:destinationPoint];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_DELAY]) {
        
        action = [CCDelayTime actionWithDuration:duration];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_SEQUENCE]) {
        
        action = [CCRepeat actionWithAction:[CCSequence actionWithArray:[self getListChildActionsValue]] times:repeat];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_RUN_ANIMATION]) {
        
        action = [self animation];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_IN]) {

        action = [CCEaseIn actionWithAction:[CCSequence actionWithArray:[self getListChildActionsValue]] rate:rate];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_OUT]) {
        
        action = [CCEaseOut actionWithAction:[CCSequence actionWithArray:[self getListChildActionsValue]] rate:rate];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_IN_OUT]) {
        
        action = [CCEaseInOut actionWithAction:[CCSequence actionWithArray:[self getListChildActionsValue]] rate:rate];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_EXPONENTIAL_IN
               ]) {
        
        action = [CCEaseExponentialIn actionWithAction:[CCSequence actionWithArray:[self getListChildActionsValue]]];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_EXPONENTIAL_OUT]) {
        
        action = [CCEaseExponentialOut actionWithAction:[CCSequence actionWithArray:[self getListChildActionsValue]]];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_EXPONENTIAL_IN_OUT]) {
        
        action = [CCEaseExponentialInOut actionWithAction:[CCSequence actionWithArray:[self getListChildActionsValue]]];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_SINE_IN]) {
        
        action = [CCEaseSineIn actionWithAction:[CCSequence actionWithArray:[self getListChildActionsValue]]];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_SINE_OUT]) {
        
        action = [CCEaseSineOut actionWithAction:[CCSequence actionWithArray:[self getListChildActionsValue]]];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_SINE_IN_OUT]) {
        
        action = [CCEaseSineInOut actionWithAction:[CCSequence actionWithArray:[self getListChildActionsValue]]];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_ELASTIC_IN]) {
        
        action = [CCEaseElasticIn actionWithAction:[CCSequence actionWithArray:[self getListChildActionsValue]] period:period];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_ELASTIC_OUT]) {
        
        action = [CCEaseElasticOut actionWithAction:[CCSequence actionWithArray:[self getListChildActionsValue]] period:period];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_ELASTIC_IN_OUT]) {
        
        action = [CCEaseElasticInOut actionWithAction:[CCSequence actionWithArray:[self getListChildActionsValue]] period:period];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_BOUNCE_IN]) {
        
        action = [CCEaseBounceIn actionWithAction:[CCSequence actionWithArray:[self getListChildActionsValue]]];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_BOUNCE_OUT]) {
        
        action = [CCEaseBounceOut actionWithAction:[CCSequence actionWithArray:[self getListChildActionsValue]]];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_BOUNCE_IN_OUT]) {
        
        action = [CCEaseBounceInOut actionWithAction:[CCSequence actionWithArray:[self getListChildActionsValue]]];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_BACK_IN]) {
        
        action = [CCEaseBackIn actionWithAction:[CCSequence actionWithArray:[self getListChildActionsValue]]];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_BACK_OUT]) {
        
        action = [CCEaseBackOut actionWithAction:[CCSequence actionWithArray:[self getListChildActionsValue]]];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_BACK_IN_OUT]) {
        
        action = [CCEaseBackInOut actionWithAction:[CCSequence actionWithArray:[self getListChildActionsValue]]];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_LINEAR_MOVING]) {
        
        action = [LinearMovingController linearMovingWithDuration:duration position:destinationPoint andRotateTarget:NO];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_ZICZAC_MOVING]) {
        
        action = [ZiczacMovingController ziczacMovingWithDuration:duration position:destinationPoint startAmplitude:movingStartAmplitude endAmplitude:movingEndAmplitude loopNumber:movingLoop positive:movingPositive andRotateTarget:NO];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_MOVING_EASE_IN]) {
        
        action = [MovingEaseIn moveWithMoveController:[MovingSequence movingControllersWithArray:[[self getListChildActionsValue] retain]]];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_MOVING_EASE_OUT]) {
        
        action = [MovingEaseInOut moveWithMoveController:[MovingSequence movingControllersWithArray:[[self getListChildActionsValue] retain]]];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_MOVING_EASE_IN_OUT]) {
        
        action = [MovingEaseInOut moveWithMoveController:[MovingSequence movingControllersWithArray:[[self getListChildActionsValue] retain]]];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_MOVING_EASE_OUT_IN]) {

        action = [MovingEaseOutIn moveWithMoveController:[MovingSequence movingControllersWithArray:[[self getListChildActionsValue] retain]]];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_ELIP_MOVING]) {
        
        action = [ElipMovingController runElipMovingControllerWithDuration:duration position:destinationPoint andAmplitude:movingAmplitude clockwise:movingClockwise andRotateTarget:NO];
        
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_ROUND_MOVING]) {
        
        action = [RoundMovingController roundMovingWithDuration:duration position:destinationPoint clockwise:movingClockwise andRotateTarget:NO];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_SPRING_MOVING]) {
        
        action = [SpringMovingController springMovingControllerWithDuration:duration andDestination:destinationPoint andAmplitude:movingAmplitude andNumberLoop:movingLoop andPositive:movingPositive andDistance:movingDistanceInterval andRotateTarget:NO];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_FERMAT_SPIRAL_MOVING]) {
        
        action = [FermatSpiralMovingController runFermatSpiralMovingControllerWithDuration:duration andDestination:destinationPoint andRotateTarget:NO];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_WAVY_SIN_MOVING]) {
        
        action = [WavySinMovingController wavySinMovingWithDuration:duration andDestination:destinationPoint andAmplitude:movingAmplitude andNumberLoop:movingLoop andPositive:movingPositive andRotateTarget:NO];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_CUSTOM_SPRING_MOVING]) {
        
        action = [CustomSpringMovingController runCustomSpringMovingControllerWithDuration:duration andAmplitudeMax:movingEndAmplitude andAmplitudeMin:movingStartAmplitude andEndPosition:destinationPoint andNumberSpring:movingNumberSpring andDistanceBetween:movingDistanceInterval andIsPositive:movingPositive andIsInscrease:movingIncrease andRotateTarget:NO];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_MOVING_REVERT]) {
        
        id sequence = [MovingSequence movingControllersWithArray:[[self getListChildActionsValue] retain]];
        
        if(repeat >= 0) {
            action = [MovingRevert revertWithWith:sequence withTimes:repeat];
        } else {
            action = [MovingRevertForever repeatWithMoveController:sequence];
        }
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_MOVING_DELAY]) {
        
        action = [MovingDelay delayWithDuration:duration];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_MOVING_SEQUENCE]) {
        
        id sequence = [MovingSequence movingControllersWithArray:[[self getListChildActionsValue] retain]];
        
        if(repeat >= 0) {
            action = [MovingRepeat repeatWithMoveController:sequence withTimes:repeat];
        } else {
            action = [MovingRepeatForever repeatWithMoveController:sequence];
        }

    } else if([actionName isEqualToString:TUTORIAL_ACTION_ON_POINT_MOVING]) {
        
        if((int)listPointOfOnPointMoving.count > 0) {
            action = [[OnPointsMovingController alloc] initOnPointsMovingControllerWithDuration:duration andPointsArray:listPointOfOnPointMoving andRotateTarget:NO];
        }
        
    }
    
    /////////////////////////////////////////////////////
    
    // Test New Action Ease
    
    if([easeType isEqualToString:TUTORIAL_ACTION_EASE_IN]) {
        
        action = [CCEaseIn actionWithAction:action rate:rate];
        
    } else if([easeType isEqualToString:TUTORIAL_ACTION_EASE_OUT]) {
        
        action = [CCEaseOut actionWithAction:action rate:rate];
        
    } else if([easeType isEqualToString:TUTORIAL_ACTION_EASE_IN_OUT]) {
        
        action = [CCEaseInOut actionWithAction:action rate:rate];
        
    } else if([easeType isEqualToString:TUTORIAL_ACTION_EASE_EXPONENTIAL_IN
               ]) {
        
        action = [CCEaseExponentialIn actionWithAction:action];
        
    } else if([easeType isEqualToString:TUTORIAL_ACTION_EASE_EXPONENTIAL_OUT]) {
        
        action = [CCEaseExponentialOut actionWithAction:action];
        
    } else if([easeType isEqualToString:TUTORIAL_ACTION_EASE_EXPONENTIAL_IN_OUT]) {
        
        action = [CCEaseExponentialInOut actionWithAction:action];
        
    } else if([easeType isEqualToString:TUTORIAL_ACTION_EASE_SINE_IN]) {
        
        action = [CCEaseSineIn actionWithAction:action];
        
    } else if([easeType isEqualToString:TUTORIAL_ACTION_EASE_SINE_OUT]) {
        
        action = [CCEaseSineOut actionWithAction:action];        
        
    } else if([easeType isEqualToString:TUTORIAL_ACTION_EASE_SINE_IN_OUT]) {
        
        action = [CCEaseSineInOut actionWithAction:action];
        
    } else if([easeType isEqualToString:TUTORIAL_ACTION_EASE_ELASTIC_IN]) {
        
        action = [CCEaseElasticIn actionWithAction:action period:period];
        
    } else if([easeType isEqualToString:TUTORIAL_ACTION_EASE_ELASTIC_OUT]) {
        
        action = [CCEaseElasticOut actionWithAction:action period:period];
        
    } else if([easeType isEqualToString:TUTORIAL_ACTION_EASE_ELASTIC_IN_OUT]) {
        
        action = [CCEaseElasticInOut actionWithAction:action period:period];
        
    } else if([easeType isEqualToString:TUTORIAL_ACTION_EASE_BOUNCE_IN]) {
        
        action = [CCEaseBounceIn actionWithAction:action];
        
    } else if([easeType isEqualToString:TUTORIAL_ACTION_EASE_BOUNCE_OUT]) {
        
        action = [CCEaseBounceOut actionWithAction:action];
        
    } else if([easeType isEqualToString:TUTORIAL_ACTION_EASE_BOUNCE_IN_OUT]) {
        
        action = [CCEaseBounceInOut actionWithAction:action];
        
    } else if([easeType isEqualToString:TUTORIAL_ACTION_EASE_BACK_IN]) {
        
        action = [CCEaseBackIn actionWithAction:action];
        
    } else if([easeType isEqualToString:TUTORIAL_ACTION_EASE_BACK_OUT]) {
        
        action = [CCEaseBackOut actionWithAction:action];
        
    } else if([easeType isEqualToString:TUTORIAL_ACTION_EASE_BACK_IN_OUT]) {
        
        action = [CCEaseBackInOut actionWithAction:action];
        
    } else if([easeType isEqualToString:TUTORIAL_ACTION_MOVING_EASE_IN]) {
        
        action = [MovingEaseIn moveWithMoveController:action];
        
    }else if([easeType isEqualToString:TUTORIAL_ACTION_MOVING_EASE_OUT]) {
        
        action = [MovingEaseInOut moveWithMoveController:action];
        
    }else if([easeType isEqualToString:TUTORIAL_ACTION_MOVING_EASE_IN_OUT]) {
        
        action = [MovingEaseInOut moveWithMoveController:action];
        
    }else if([easeType isEqualToString:TUTORIAL_ACTION_MOVING_EASE_OUT_IN]) {
        
        action = [MovingEaseOutIn moveWithMoveController:action];
    }
    // End Test
    /////////////////////////////////////////////////////
    
    
    return action;
}

-(NSMutableArray *)getListChildActionsValue {
    NSMutableArray *listActions = [NSMutableArray array];
    
    for(int i = 0; i < listChildActions.count; i++) {
        id action = [[listChildActions objectAtIndex:i] getActionValue];
        [listActions addObject:action];
        
        action = nil;
    }
    
    return listActions;
}

-(CCAction *)animation {    
    NSMutableArray *animationFrames = [NSMutableArray array];
    for(NSString *frameName in listAnimationFrameName) {
        
        NSLog(@"Frame Name: %@", frameName);
        
        CCSpriteFrame *spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [animationFrames addObject:spriteFrame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animationFrames delay:animationFrameDelay];
    [animation setRestoreOriginalFrame:animationRestoreOriginalFrame];
    
    CCAnimate *animate = [CCAnimate actionWithAnimation:animation];  
    
    id action = [CCRepeat actionWithAction:[CCSequence actions:animate, [CCDelayTime actionWithDuration:animationLoopDelay], nil] times:animationLoop];
    return action;
}


@end
