//
//  TutorialActionLib.m
//  LibGame
//
//  Created by User on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialActionLib.h"

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
#import "MovingDelay.h"

@implementation TutorialActionLib

+(id)getActionFromData:(NSMutableDictionary *)_actionData {
    NSString *actionName = [_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ACTION_TYPE];
    
    id action = nil;
    
    if([actionName isEqualToString:TUTORIAL_ACTION_MOVE_TO]) {
        
        action = [self actionMoveToWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_MOVE_BY]) {
        
        action = [self actionMoveByWithData:_actionData];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_JUMP_TO]) {
        
        action = [self actionJumpToWithData:_actionData];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_JUMP_BY]) {
        
        action = [self actionJumpByWithData:_actionData];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_BEZIER_TO]) {
        
        action = [self actionBezierToWithData:_actionData];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_BEZIER_BY]) {
        
        action = [self actionBezierByWithData:_actionData];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_SHOW]) {
        
        action = [self actionShowActionWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_HIDE]) {
        
        action = [self actionHideActionWithData:_actionData];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_FADE_IN]) {
        
        action = [self actionFadeInWithData:_actionData];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_FADE_OUT]) {
        
        action = [self actionFadeOutWithData:_actionData];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_FADE_TO]) {
        
        action = [self actionFadeToWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_SCALE_TO]) {
        
        action = [self actionScaleToWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_SCALE_BY]) {
        
        action = [self actionScaleByWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_ROTATE_TO]) {
        
        action = [self actionRotateToWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_ROTATE_BY]) {
        
        action = [self actionRotateByWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_PLACE]) {
        
        action = [self actionPlaceWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_DELAY]) {
        
        action = [self actionDelayWithData:_actionData];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_CUSTOM_MOVE]) {
        
        action = [self actionCustomMoveWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_SEQUENCE]) {
        
        action = [self actionRepeatSequenceForeverWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_RUN_ANIMATION]) {
        
        action = [self animationWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_IN]) {
        
        action = [self getEaseInActionWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_OUT]) {
        
        action = [self getEaseOutActionWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_IN_OUT]) {
        
        action = [self getEaseInOutActionWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_EXPONENTIAL_IN
]) {
        
        action = [self getEaseExponentialInActionWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_EXPONENTIAL_OUT]) {
        
        action = [self getEaseExponentialOutActionWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_EXPONENTIAL_IN_OUT]) {
        
        action = [self getEaseExponentialInOutActionWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_SINE_IN]) {
        
        action = [self getEaseSineInActionWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_SINE_OUT]) {
        
        action = [self getEaseSineOutActionWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_SINE_IN_OUT]) {
        
        action = [self getEaseSineInOutActionWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_ELASTIC_IN]) {
        
        action = [self getEaseElasticInActionWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_ELASTIC_OUT]) {
        
        action = [self getEaseElasticOutActionWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_ELASTIC_IN_OUT]) {
        
        action = [self getEaseElasticInOutActionWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_BOUNCE_IN]) {
        
        action = [self getEaseBounceInActionWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_BOUNCE_OUT]) {
        
        action = [self getEaseBounceOutActionWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_BOUNCE_IN_OUT]) {
        
        action = [self getEaseBounceInOutActionWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_BACK_IN]) {
        
        action = [self getEaseBackInActionWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_BACK_OUT]) {
        
        action = [self getEaseBackOutActionWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_EASE_BACK_IN_OUT]) {
        
        action = [self getEaseBackInOutActionWithData:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_LINEAR_MOVING]) {
        
        action = [self getLinearMoving:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_ZICZAC_MOVING]) {
        
        action = [self getZiczacMoving:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_MOVING_EASE_IN]) {
        
        action = [self getMovingEaseIn:_actionData];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_MOVING_EASE_OUT]) {
        
        action = [self getMovingEaseOut:_actionData];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_MOVING_EASE_IN_OUT]) {
        
        action = [self getMovingEaseInOut:_actionData];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_MOVING_EASE_OUT_IN]) {
        
        action = [self getMovingEaseOutIn:_actionData];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_ELIP_MOVING]) {
        
        action = [self getElipMoving:_actionData];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_ROUND_MOVING]) {
        
        action = [self getRoundMoving:_actionData];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_SPRING_MOVING]) {
        
        action = [self getSpringMoving:_actionData];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_FERMAT_SPIRAL_MOVING]) {
        
        action = [self getFermatSpiralMoving:_actionData];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_WAVY_SIN_MOVING]) {
        
        action = [self getWavySinMoving:_actionData];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_CUSTOM_SPRING_MOVING]) {
        
        action = [self getCustomSpringMoving:_actionData];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_MOVING_REVERT]) {
        
        action = [self getMovingRevert:_actionData];
        
    }else if([actionName isEqualToString:TUTORIAL_ACTION_MOVING_DELAY]) {
        
        action = [self getMovingDelay:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_MOVING_SEQUENCE]) {
        
        action = [self getMovingSequence:_actionData];
        
    } else if([actionName isEqualToString:TUTORIAL_ACTION_ELIP_MOVING]) {
        
        action = [self getElipMoving:_actionData];
        
    }
    
    return action;
}

+(NSMutableArray*)getActionsArrayWithData:_dictData{
    NSMutableArray *actions = [_dictData objectForKey:TUTORIAL_ACTION_DATA_ACTION_SEQUENCE];
    NSMutableArray *listActions = [NSMutableArray array];
    
    for(int i = 0; i < actions.count; i++) {
        NSMutableDictionary *actionDictionary = [actions objectAtIndex:i];
        id action = [self getActionFromData:actionDictionary];
        [listActions addObject:action];
    }
    return listActions;
}

+(CCAction *)actionRepeatSequenceForeverWithData:_dictData {
    int repeatTimes = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_REPEAT] intValue];
    
//    NSMutableArray *actions = [_dictData objectForKey:TUTORIAL_ACTION_DATA_ACTION_SEQUENCE];
//    NSMutableArray *listActions = [NSMutableArray array];
//    
//    for(int i = 0; i < actions.count; i++) {
//        NSMutableDictionary *actionDictionary = [actions objectAtIndex:i];
//        CCAction *action = [self getActionFromData:actionDictionary];
//        [listActions addObject:action];
//    }
    
    NSMutableArray *listActions = [self getActionsArrayWithData:_dictData];
    
    CCSequence* sequence=[CCSequence actionWithArray:listActions];
    CCRepeat* repeatSequence = [CCRepeat actionWithAction:sequence times:repeatTimes];
    
    return repeatSequence;
}

+(CCAction *)actionMoveToWithData:(NSMutableDictionary *)_dictData {
    float desPointX = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_X] floatValue];
    float desPointY = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_Y] floatValue];
    CGPoint desPoint = CGPointMake(desPointX, desPointY);
    
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    
    id action = [CCMoveTo actionWithDuration:durationTime position:desPoint];    
    return action;
}

+(CCAction *)actionMoveByWithData:(NSMutableDictionary *)_dictData {
    float desPointX = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_X] floatValue];
    float desPointY = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_Y] floatValue];
    CGPoint desPoint = CGPointMake(desPointX, desPointY);
    
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    
    id action = [CCMoveBy actionWithDuration:durationTime position:desPoint];
    return action;
}

+(CCAction *)actionJumpToWithData:(NSMutableDictionary *)_dictData {
    float desPointX = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_X] floatValue];
    float desPointY = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_Y] floatValue];
    CGPoint desPoint = CGPointMake(desPointX, desPointY);
    
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    
    float height=[[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_JUMP_HEIGHT] floatValue];
    
    int jumps=[[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_JUMPS] intValue];
    
    id action = [CCJumpTo actionWithDuration:durationTime position:desPoint height:height jumps:jumps];
    return action;
}

+(CCAction *)actionJumpByWithData:(NSMutableDictionary *)_dictData {
    float desPointX = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_X] floatValue];
    float desPointY = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_Y] floatValue];
    CGPoint desPoint = CGPointMake(desPointX, desPointY);
    
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    float height=[[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_JUMP_HEIGHT] floatValue];
    int jumps=[[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_JUMPS] intValue];
    
    id action = [CCJumpBy actionWithDuration:durationTime position:desPoint height:height jumps:jumps];
    return action;
}

+(CCAction *)actionBezierToWithData:(NSMutableDictionary *)_dictData {
    float desPointX = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_X] floatValue];
    float desPointY = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_Y] floatValue];
    
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    
    float controlPoint1_X = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_CONTROL_POINT_1_X] floatValue];
    float controlPoint1_Y = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_CONTROL_POINT_1_Y] floatValue];
    float controlPoint2_X = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_CONTROL_POINT_2_X] floatValue];
    float controlPoint2_Y = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_CONTROL_POINT_2_Y] floatValue];
    
    CGPoint desPoint = CGPointMake(desPointX, desPointY);
    CGPoint controlPoint1 = CGPointMake(controlPoint1_X, controlPoint1_Y);
    CGPoint controlPoint2 = CGPointMake(controlPoint2_X, controlPoint2_Y);
    
    ccBezierConfig bezier;
    bezier.controlPoint_1=controlPoint1;
    bezier.controlPoint_2=controlPoint2;
    bezier.endPosition=desPoint;
    
    id action = [CCBezierTo actionWithDuration:durationTime bezier:bezier];
    return action;
}

+(CCAction *)actionBezierByWithData:(NSMutableDictionary *)_dictData {
    float desPointX = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_X] floatValue];
    float desPointY = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_Y] floatValue];
    
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    
    float controlPoint1_X = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_CONTROL_POINT_1_X] floatValue];
    float controlPoint1_Y = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_CONTROL_POINT_1_Y] floatValue];
    float controlPoint2_X = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_CONTROL_POINT_2_X] floatValue];
    float controlPoint2_Y = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_CONTROL_POINT_2_Y] floatValue];
    
    CGPoint desPoint = CGPointMake(desPointX, desPointY);
    CGPoint controlPoint1 = CGPointMake(controlPoint1_X, controlPoint1_Y);
    CGPoint controlPoint2 = CGPointMake(controlPoint2_X, controlPoint2_Y);
    
    ccBezierConfig bezier;
    bezier.controlPoint_1=controlPoint1;
    bezier.controlPoint_2=controlPoint2;
    bezier.endPosition=desPoint;
    
    id action = [CCBezierBy actionWithDuration:durationTime bezier:bezier];
    return action;
}

+(CCAction *)actionShowActionWithData:(NSMutableDictionary *)_dictData {    
    return [CCShow action];
}

+(CCAction *)actionHideActionWithData:(NSMutableDictionary *)_dictData {    
    return [CCHide action];
}

+(CCAction *)actionFadeInWithData:(NSMutableDictionary *)_dictData {
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    id action=[CCFadeIn actionWithDuration:durationTime];
    return action;
}

+(CCAction *)actionFadeOutWithData:(NSMutableDictionary *)_dictData {
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    id action=[CCFadeOut actionWithDuration:durationTime];
    return action;
}

+(CCAction *)actionFadeToWithData:(NSMutableDictionary *)_dictData {
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    float opacity = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_FADE_OPACITY] floatValue];
    
    id action = [CCFadeTo actionWithDuration:durationTime opacity:opacity];
    return action;
}

+(CCAction *)actionScaleToWithData:(NSMutableDictionary *)_dictData {
    float scaleX = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_SCALE_X] floatValue];
    float scaleY = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_SCALE_Y] floatValue];
    
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    
    id action = [CCScaleTo actionWithDuration:durationTime scaleX:scaleX scaleY:scaleY];
    return action;
}

+(CCAction *)actionScaleByWithData:(NSMutableDictionary *)_dictData {
    float scaleX = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_SCALE_X] floatValue];
    float scaleY = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_SCALE_Y] floatValue];
    
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    
    id action = [CCScaleBy actionWithDuration:durationTime scaleX:scaleX scaleY:scaleY];
    return action;
}

+(CCAction *)actionRotateToWithData:(NSMutableDictionary *)_dictData {    
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    float angle = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_ROTATE_ANGLE] floatValue];
    
    id action = [CCRotateTo actionWithDuration:durationTime angle:angle];
    return action;
}

+(CCAction *)actionPlaceWithData:(NSMutableDictionary *)_dictData{
    float desPointX = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_X] floatValue];
    float desPointY = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_Y] floatValue];
    CGPoint desPoint = CGPointMake(desPointX, desPointY);
    id action=[CCPlace actionWithPosition:desPoint];
    return action;
}

+(CCAction *)actionDelayWithData:(NSMutableDictionary *)_dictData {
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    
    id action = [CCDelayTime actionWithDuration:durationTime];
    return action;
}

+(CCAction *)actionRotateByWithData:(NSMutableDictionary *)_dictData {
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    float angle = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_ROTATE_ANGLE] floatValue];
    
    id action = [CCRotateBy actionWithDuration:durationTime angle:angle];
    return action;
}

+(CCAction *)actionCustomMoveWithData:(NSMutableDictionary *)_dictData{
    NSArray *listDeltas = [_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_CUSTOM_MOVE_DELTAS];
    NSMutableArray *moveSequenceArray=[NSMutableArray array];
    for (NSDictionary *delta in listDeltas){
        float delta_x=[[delta objectForKey:TUTORIAL_ACTION_DATA_KEY_CUSTOM_MOVE_DELTA_X_VALUE] floatValue];
        float delta_y=[[delta objectForKey:TUTORIAL_ACTION_DATA_KEY_CUSTOM_MOVE_DELTA_Y_VALUE] floatValue];
        CGPoint deltaValue=ccp(delta_x,delta_y);
        float moveDuration=[[delta objectForKey:TUTORIAL_ACTION_DATA_KEY_CUSTOM_MOVE_DELTA_DURATION] floatValue];
        CCMoveBy* moveDelta=[CCMoveBy actionWithDuration:moveDuration position:deltaValue];
        [moveSequenceArray addObject:moveDelta];
    }
    id action=[CCSequence actionWithArray:moveSequenceArray];
    return action;
}

+(CCAction *)animationWithData:(NSMutableDictionary *)_dictData {
    int animationLoop = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_LOOP] intValue];
    float animationLoopDelay = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_LOOP_DELAY] floatValue];
    float frameDelay = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_FRAME_DELAY] floatValue];
    BOOL restoreOriginalFrame = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_RESTORE_FRAME] boolValue];
    
    NSArray *listFrameNames = [_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_LIST_FRAMES];
    
    NSMutableArray *animationFrames = [NSMutableArray array];
    for(NSString *frameName in listFrameNames) {
        CCSpriteFrame *spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [animationFrames addObject:spriteFrame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animationFrames delay:frameDelay];
    [animation setRestoreOriginalFrame:restoreOriginalFrame];
    
    CCAnimate *animate = [CCAnimate actionWithAnimation:animation];  
    
    id action = [CCRepeat actionWithAction:[CCSequence actions:animate, [CCDelayTime actionWithDuration:animationLoopDelay], nil] times:animationLoop];
    return action;
}

+(CCEaseIn*) getEaseInActionWithData:_dictData{
    
    float rate=[[_dictData objectForKey:TUTORIAL_ACTION_DATA_ACTION_EASE_RATE] floatValue];

    NSMutableArray *listActions = [self getActionsArrayWithData:_dictData];
    
    CCSequence* sequence = [CCSequence actionWithArray:listActions];    
    id action = [CCEaseIn actionWithAction:sequence rate:rate];
	return action;
}

+(CCEaseOut*) getEaseOutActionWithData:_dictData{
    float rate=[[_dictData objectForKey:TUTORIAL_ACTION_DATA_ACTION_EASE_RATE] floatValue];
    
    NSMutableArray *listActions = [self getActionsArrayWithData:_dictData];
    
    CCSequence* sequence = [CCSequence actionWithArray:listActions];    
    
    id action = [CCEaseOut actionWithAction:sequence rate:rate];
	return action;
}

+(CCEaseInOut*) getEaseInOutActionWithData:_dictData{
    float rate=[[_dictData objectForKey:TUTORIAL_ACTION_DATA_ACTION_EASE_RATE] floatValue];
    
    NSMutableArray *listActions = [self getActionsArrayWithData:_dictData];
    
    CCSequence* sequence = [CCSequence actionWithArray:listActions];    
    
    id action = [CCEaseInOut actionWithAction:sequence rate:rate];
	return action;
}

+(CCEaseExponentialIn*) getEaseExponentialInActionWithData:_dictData{
    NSMutableArray *listActions = [self getActionsArrayWithData:_dictData];
    
    CCSequence* sequence = [CCSequence actionWithArray:listActions];    
    
    id action = [CCEaseExponentialIn actionWithAction:sequence];
	return action;
}

+(CCEaseExponentialOut*) getEaseExponentialOutActionWithData:_dictData{
    NSMutableArray *listActions = [self getActionsArrayWithData:_dictData];
    
    CCSequence* sequence = [CCSequence actionWithArray:listActions];    
    
    id action = [CCEaseExponentialOut actionWithAction:sequence];
	return action;
}

+(CCEaseExponentialInOut*) getEaseExponentialInOutActionWithData:_dictData{
    NSMutableArray *listActions = [self getActionsArrayWithData:_dictData];
    
    CCSequence* sequence = [CCSequence actionWithArray:listActions];    
    
    id action = [CCEaseExponentialInOut actionWithAction:sequence];
	return action;
}

+(CCEaseSineIn*) getEaseSineInActionWithData:_dictData{
    NSMutableArray *listActions = [self getActionsArrayWithData:_dictData];
    
    CCSequence* sequence = [CCSequence actionWithArray:listActions];    
    
    id action = [CCEaseSineIn actionWithAction:sequence];
	return action;
}

+(CCEaseSineOut*) getEaseSineOutActionWithData:_dictData{
    NSMutableArray *listActions = [self getActionsArrayWithData:_dictData];
    
    CCSequence* sequence = [CCSequence actionWithArray:listActions];    
    
    id action = [CCEaseSineOut actionWithAction:sequence];
	return action;
}

+(CCEaseSineInOut*) getEaseSineInOutActionWithData:_dictData{
    NSMutableArray *listActions = [self getActionsArrayWithData:_dictData];
    
    CCSequence* sequence = [CCSequence actionWithArray:listActions];    
    
    id action = [CCEaseSineInOut actionWithAction:sequence];
	return action;
}

+(CCEaseElasticIn*) getEaseElasticInActionWithData:_dictData{
    float period = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_ACTION_EASE_PERIOD] floatValue];
    
    NSMutableArray *listActions = [self getActionsArrayWithData:_dictData];
    
    CCSequence* sequence = [CCSequence actionWithArray:listActions];    
    
    id action = [CCEaseElasticIn actionWithAction:sequence period:period];
	return action;
}

+(CCEaseElasticOut*) getEaseElasticOutActionWithData:_dictData{
    float period=[[_dictData objectForKey:TUTORIAL_ACTION_DATA_ACTION_EASE_PERIOD] floatValue];
    
    NSMutableArray *listActions = [self getActionsArrayWithData:_dictData];
    
    CCSequence* sequence = [CCSequence actionWithArray:listActions];    
    
    id action = [CCEaseElasticOut actionWithAction:sequence period:period];
	return action;
}

+(CCEaseElasticInOut*) getEaseElasticInOutActionWithData:_dictData{
    float period=[[_dictData objectForKey:TUTORIAL_ACTION_DATA_ACTION_EASE_PERIOD] floatValue];
    
    NSMutableArray *listActions = [self getActionsArrayWithData:_dictData];
    
    CCSequence* sequence = [CCSequence actionWithArray:listActions];    
    
    id action = [CCEaseElasticInOut actionWithAction:sequence period:period];
    
	return action;
}

+(CCEaseBounceIn*) getEaseBounceInActionWithData:_dictData{
    NSMutableArray *listActions = [self getActionsArrayWithData:_dictData];
    
    CCSequence* sequence = [CCSequence actionWithArray:listActions];    
    
    id action = [CCEaseBounceIn actionWithAction:sequence];
	return action;
}

+(CCEaseBounceOut*) getEaseBounceOutActionWithData:_dictData{
    NSMutableArray *listActions = [self getActionsArrayWithData:_dictData];
    
    CCSequence* sequence = [CCSequence actionWithArray:listActions];    
    
    id action = [CCEaseBounceOut actionWithAction:sequence];
	return action;
}

+(CCEaseBounceInOut*) getEaseBounceInOutActionWithData:_dictData{ 
    NSMutableArray *listActions = [self getActionsArrayWithData:_dictData];
    
    CCSequence* sequence = [CCSequence actionWithArray:listActions];    
    
    id action = [CCEaseBounceInOut actionWithAction:sequence];
	return action;
}

+(CCEaseBackIn*) getEaseBackInActionWithData:_dictData{
    NSMutableArray *listActions = [self getActionsArrayWithData:_dictData];
    
    CCSequence* sequence = [CCSequence actionWithArray:listActions];    
    
    id action = [CCEaseBackIn actionWithAction:sequence];
	return action;
}

+(CCEaseBackOut*) getEaseBackOutActionWithData:_dictData{
    NSMutableArray *listActions = [self getActionsArrayWithData:_dictData];
    
    CCSequence* sequence = [CCSequence actionWithArray:listActions];    
    
    id action = [CCEaseBackOut actionWithAction:sequence];
	return action;
}

+(CCEaseBackInOut*) getEaseBackInOutActionWithData:_dictData{
    NSMutableArray *listActions = [self getActionsArrayWithData:_dictData];
    
    CCSequence* sequence = [CCSequence actionWithArray:listActions];    
    
    id action = [CCEaseBackInOut actionWithAction:sequence];
	return action;
}

+(MovingController *)getLinearMoving:(NSMutableDictionary *)_dictData {
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    float desPointX = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_X] floatValue];
    float desPointY = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_Y] floatValue];
    
    return [LinearMovingController linearMovingWithDuration:durationTime position:ccp(desPointX, desPointY)];
}

+(MovingController *)getMovingEaseIn:(NSMutableDictionary *)_dictData{
    NSMutableArray *listActions = [[NSMutableArray alloc] initWithArray:[self getActionsArrayWithData:_dictData]];
    
    id sequence = [MovingSequence movingControllersWithArray:listActions];
    return [MovingEaseIn moveWithMoveController:sequence];
}

+(MovingController *)getMovingEaseOut:(NSMutableDictionary *)_dictData{
    NSMutableArray *listActions = [[NSMutableArray alloc] initWithArray:[self getActionsArrayWithData:_dictData]];
    
    id sequence = [MovingSequence movingControllersWithArray:listActions];
    return [MovingEaseOut moveWithMoveController:sequence];
}

+(MovingController *)getMovingEaseInOut:(NSMutableDictionary *)_dictData{
    NSMutableArray *listActions = [[NSMutableArray alloc] initWithArray:[self getActionsArrayWithData:_dictData]];
    
    id sequence = [MovingSequence movingControllersWithArray:listActions];
    return [MovingEaseInOut moveWithMoveController:sequence];
}

+(MovingController *)getMovingEaseOutIn:(NSMutableDictionary *)_dictData{
    NSMutableArray *listActions = [[NSMutableArray alloc] initWithArray:[self getActionsArrayWithData:_dictData]];
    
    id sequence = [MovingSequence movingControllersWithArray:listActions];
    return [MovingEaseOutIn moveWithMoveController:sequence];
}

+(MovingController *)getZiczacMoving:(NSMutableDictionary *)_dictData{
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    
    float desPointX = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_X] floatValue];
    float desPointY = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_Y] floatValue];
    
    CGPoint destination = ccp(desPointX,desPointY);
    
    float startAmplitude = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_START_Amplitude] floatValue];
    float endAmplitude = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_END_Amplitude] floatValue];
    int loop = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_LOOP] intValue];
    
    BOOL positive=[[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_POSITIVE] boolValue];
    
    return [ZiczacMovingController ziczacMovingWithDuration:durationTime position:destination startAmplitude:startAmplitude endAmplitude:endAmplitude loopNumber:loop positive:positive];
}

+(MovingController *)getElipMoving:(NSMutableDictionary *)_dictData{
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    
    float desPointX = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_X] floatValue];
    float desPointY = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_Y] floatValue];
    
    CGPoint destination = ccp(desPointX,desPointY);
    
    float Amplitude = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_Amplitude] floatValue];
    
    BOOL clockwise=[[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_CLOCKWISE] boolValue];
    
    return [ElipMovingController runElipMovingControllerWithDuration:durationTime position:destination andAmplitude:Amplitude clockwise:clockwise];
}

+(MovingController *)getSpringMoving:(NSMutableDictionary *)_dictData{
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    
    float desPointX = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_X] floatValue];
    float desPointY = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_Y] floatValue];
    
    CGPoint destination = ccp(desPointX,desPointY);
    
    float Amplitude = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_Amplitude] floatValue];
    
    int loop = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_LOOP] intValue];
    
    BOOL positive=[[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_POSITIVE] boolValue];
    
    float distanceInterval = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DISTANCE_INTERVAL] floatValue];
    
    return [SpringMovingController springMovingControllerWithDuration:durationTime andDestination:destination andAmplitude:Amplitude andNumberLoop:loop andPositive:positive andDistance:distanceInterval];
}

+(MovingController *)getFermatSpiralMoving:(NSMutableDictionary *)_dictData{
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    
    float desPointX = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_X] floatValue];
    float desPointY = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_Y] floatValue];
    
    CGPoint destination = ccp(desPointX,desPointY);
    
    return [FermatSpiralMovingController runFermatSpiralMovingControllerWithDuration:durationTime andDestination:destination];
}

+(MovingController *)getWavySinMoving:(NSMutableDictionary *)_dictData{
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    
    float desPointX = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_X] floatValue];
    float desPointY = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_Y] floatValue];
    
    CGPoint destination = ccp(desPointX,desPointY);
    
    float Amplitude = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_Amplitude] floatValue];
    
    int loop = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_LOOP] intValue];
    
    BOOL positive=[[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_POSITIVE] boolValue];
    
    return [WavySinMovingController wavySinMovingWithDuration:durationTime andDestination:destination andAmplitude:Amplitude andNumberLoop:loop andPositive:positive];
}

+(MovingController *)getMovingSequence:(NSMutableDictionary *)_dictData{
    int repeatTimes = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_REPEAT] intValue];
    
    NSMutableArray *listActions = [[NSMutableArray alloc] initWithArray:[self getActionsArrayWithData:_dictData]];
    
    id sequence = [MovingSequence movingControllersWithArray:listActions];
    
    id repeatSequence = nil;
    
    if(repeatTimes >= 0) {
        repeatSequence = [MovingRepeat repeatWithMoveController:sequence withTimes:repeatTimes];
    } else {
        repeatSequence = [MovingRepeatForever repeatWithMoveController:sequence];
    }
    
    return repeatSequence;
}

+(MovingController *)getRoundMoving:(NSMutableDictionary *)_dictData{
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    
    float desPointX = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_X] floatValue];
    float desPointY = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_Y] floatValue];
    
    CGPoint destination = ccp(desPointX,desPointY);
    
    BOOL clockwise=[[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_CLOCKWISE] boolValue];
    
    return [RoundMovingController roundMovingWithDuration:durationTime position:destination clockwise:clockwise];
}

+(MovingController *)getCustomSpringMoving:(NSMutableDictionary *)_dictData{
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    
    float desPointX = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_X] floatValue];
    float desPointY = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_Y] floatValue];
    
    CGPoint destination = ccp(desPointX,desPointY);
    
    float maxAmplitude = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_MAX_Amplitude] floatValue];
    float minAmplitude = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_MIN_Amplitude] floatValue];
    
    float distanceInterval = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DISTANCE_INTERVAL] floatValue];
    
    int numberSpring = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_NUMBER_SPRING] intValue];
    
    BOOL positive=[[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_POSITIVE] boolValue];
    
    BOOL increase=[[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_INCREASE] boolValue];
    
    return [CustomSpringMovingController runCustomSpringMovingControllerWithDuration:durationTime andAmplitudeMax:maxAmplitude andAmplitudeMin:minAmplitude andEndPosition:destination andNumberSpring:numberSpring andDistanceBetween:distanceInterval andIsPositive:positive andIsInscrease:increase];
}

+(MovingController *)getMovingRevert:(NSMutableDictionary *)_dictData{
    int repeatTimes = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_REPEAT] intValue];
    
    NSMutableArray *listActions = [[NSMutableArray alloc] initWithArray:[self getActionsArrayWithData:_dictData]];
    
    id sequence = [MovingSequence movingControllersWithArray:listActions];
    
    id repeatSequence = nil;
    
    if(repeatTimes >= 0) {
        repeatSequence = [MovingRevert revertWithWith:sequence withTimes:repeatTimes];
    } else {
        repeatSequence = [MovingRevertForever repeatWithMoveController:sequence];
    }
    
    return repeatSequence;
}


+(MovingController *)getMovingDelay:(NSMutableDictionary *)_dictData{
    float durationTime = [[_dictData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
    return [MovingDelay delayWithDuration:durationTime];
}


@end
