//
//  TutorialActionLib.h
//  LibGame
//
//  Created by User on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TutorialLibDefine.h"
#import "MovingController.h"

@interface TutorialActionLib : NSObject

+(id)getActionFromData:(NSMutableDictionary *)_actionData;

+(NSMutableArray*)getActionsArrayWithData:_dictData;

//Basic Actions
+(CCAction *)actionMoveToWithData:(NSMutableDictionary *)_dictData;
+(CCAction *)actionMoveByWithData:(NSMutableDictionary *)_dictData;
+(CCAction *)actionJumpToWithData:(NSMutableDictionary *)_dictData;
+(CCAction *)actionJumpByWithData:(NSMutableDictionary *)_dictData;
+(CCAction *)actionBezierToWithData:(NSMutableDictionary *)_dictData;
+(CCAction *)actionBezierByWithData:(NSMutableDictionary *)_dictData;
+(CCAction *)actionShowActionWithData:(NSMutableDictionary *)_dictData;
+(CCAction *)actionHideActionWithData:(NSMutableDictionary *)_dictData;
+(CCAction *)actionFadeInWithData:(NSMutableDictionary *)_dictData;
+(CCAction *)actionFadeOutWithData:(NSMutableDictionary *)_dictData;
+(CCAction *)actionFadeToWithData:(NSMutableDictionary *)_dictData;
+(CCAction *)actionScaleToWithData:(NSMutableDictionary *)_dictData;
+(CCAction *)actionScaleByWithData:(NSMutableDictionary *)_dictData;
+(CCAction *)actionRotateToWithData:(NSMutableDictionary *)_dictData;
+(CCAction *)actionRotateByWithData:(NSMutableDictionary *)_dictData;
+(CCAction *)actionPlaceWithData:(NSMutableDictionary *)_dictData;
+(CCAction *)actionDelayWithData:(NSMutableDictionary *)_dictData;
+(CCAction *)actionCustomMoveWithData:(NSMutableDictionary *)_dictData;
+(CCAction *)actionRepeatSequenceForeverWithData:(NSMutableDictionary *)_dictData;
+(CCAction *)animationWithData:(NSMutableDictionary *)_dictData;

//Ease actions
+(CCEaseIn*) getEaseInActionWithData:(NSMutableDictionary *)_dictData;
+(CCEaseOut*) getEaseOutActionWithData:(NSMutableDictionary *)_dictData;
+(CCEaseInOut*) getEaseInOutActionWithData:(NSMutableDictionary *)_dictData;
+(CCEaseExponentialIn*) getEaseExponentialInActionWithData:(NSMutableDictionary *)_dictData;
+(CCEaseExponentialOut*) getEaseExponentialOutActionWithData:(NSMutableDictionary *)_dictData;
+(CCEaseExponentialInOut*) getEaseExponentialInOutActionWithData:(NSMutableDictionary *)_dictData;
+(CCEaseSineIn*) getEaseSineInActionWithData:(NSMutableDictionary *)_dictData;
+(CCEaseSineOut*) getEaseSineOutActionWithData:(NSMutableDictionary *)_dictData;
+(CCEaseSineInOut*) getEaseSineInOutActionWithData:(NSMutableDictionary *)_dictData;
+(CCEaseElasticIn*) getEaseElasticInActionWithData:(NSMutableDictionary *)_dictData;
+(CCEaseElasticOut*) getEaseElasticOutActionWithData:(NSMutableDictionary *)_dictData;
+(CCEaseElasticInOut*) getEaseElasticInOutActionWithData:(NSMutableDictionary *)_dictData;
+(CCEaseBounceIn*) getEaseBounceInActionWithData:(NSMutableDictionary *)_dictData;
+(CCEaseBounceOut*) getEaseBounceOutActionWithData:(NSMutableDictionary *)_dictData;
+(CCEaseBounceInOut*) getEaseBounceInOutActionWithData:(NSMutableDictionary *)_dictData;
+(CCEaseBackIn*) getEaseBackInActionWithData:(NSMutableDictionary *)_dictData;
+(CCEaseBackOut*) getEaseBackOutActionWithData:(NSMutableDictionary *)_dictData;
+(CCEaseBackInOut*) getEaseBackInOutActionWithData:(NSMutableDictionary *)_dictData;

//Special action
+(MovingController *)getLinearMoving:(NSMutableDictionary *)_dictData;
+(MovingController *)getMovingEaseIn:(NSMutableDictionary *)_dictData;
+(MovingController *)getMovingEaseOut:(NSMutableDictionary *)_dictData;
+(MovingController *)getMovingEaseInOut:(NSMutableDictionary *)_dictData;
+(MovingController *)getMovingEaseOutIn:(NSMutableDictionary *)_dictData;
+(MovingController *)getZiczacMoving:(NSMutableDictionary *)_dictData;
+(MovingController *)getElipMoving:(NSMutableDictionary *)_dictData;
+(MovingController *)getSpringMoving:(NSMutableDictionary *)_dictData;
+(MovingController *)getFermatSpiralMoving:(NSMutableDictionary *)_dictData;
+(MovingController *)getWavySinMoving:(NSMutableDictionary *)_dictData;
+(MovingController *)getMovingSequence:(NSMutableDictionary *)_dictData;
+(MovingController *)getRoundMoving:(NSMutableDictionary *)_dictData;
+(MovingController *)getCustomSpringMoving:(NSMutableDictionary *)_dictData;
+(MovingController *)getMovingRevert:(NSMutableDictionary *)_dictData;
+(MovingController *)getMovingDelay:(NSMutableDictionary *)_dictData;
@end
