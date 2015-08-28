//
//  TutorialAction.h
//  LibGame
//
//  Created by User on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TutorialLibDefine.h"
#import "TutorialSpriteObject.h"
#import "CallFunctionC.h"
//#import "MovingController.h"

@class TutorialSequenceActionManager;

@interface TutorialAction : NSObject {
    TutorialSequenceActionManager *sequenceManager;
    
    //order of object target
    int objectTagetOrderZIndex;
    
    //time delay before start action
    float scheduleTime;
    
    //Callback called when this action just finished
    id finishedCallback;
    
    //action parameters
    NSString *actionName;
    NSString *easeType;
    NSString *objectTargetName;
    NSString *functionInGameName;
    int repeat;
    float period;
    float rate;
    float angle;
    int animationLoop;
    float animationLoopDelay, animationFrameDelay;
    BOOL animationRestoreOriginalFrame;
    CGPoint destinationPoint;
    float duration;
    float scaleX, scaleY;
    float jumpHeight;
    int jumpCount;
    int fadeOpacity;
    int movingLoop;
    float movingAmplitude, movingStartAmplitude, movingEndAmplitude;
    float movingDistanceInterval;
    BOOL movingClockwise;
    BOOL movingIncrease;
    float movingNumberSpring;
    BOOL movingPositive;
    NSMutableArray *listAnimationFrameName; //List frame for action runAnimation
    NSMutableArray *listPointOfOnPointMoving; //Action OnPointMoving has this array point
    
    //list actions if this action is sequence
    NSMutableArray *listChildActions;
}

@property (retain, nonatomic) NSString *actionName;
@property (retain, nonatomic) NSString *easeType;
@property (retain, nonatomic) NSString *objectTargetName;
@property (retain, nonatomic) NSString *functionInGameName;
@property (nonatomic) int objectTagetOrderZIndex;
@property (nonatomic) int repeat;
@property (nonatomic) float period;
@property (nonatomic) float rate;
@property (nonatomic) float angle;
@property (nonatomic) int animationLoop;
@property (nonatomic) float animationLoopDelay, animationFrameDelay;
@property (nonatomic) BOOL animationRestoreOriginalFrame;
@property (nonatomic) CGPoint destinationPoint;
@property (nonatomic) float duration;
@property (nonatomic) float scaleX, scaleY;
@property (nonatomic) float jumpHeight;
@property (nonatomic) int jumpCount;
@property (nonatomic) int fadeOpacity;
@property (nonatomic) int movingLoop;
@property (nonatomic) float movingAmplitude, movingStartAmplitude, movingEndAmplitude;
@property (nonatomic) float movingDistanceInterval;
@property (nonatomic) BOOL movingClockwise;
@property (nonatomic) BOOL movingIncrease;
@property (nonatomic) float movingNumberSpring;
@property (nonatomic) BOOL movingPositive;
@property (retain, nonatomic) NSMutableArray *listAnimationFrameName; 
@property (retain, nonatomic) NSMutableArray *listPointOfOnPointMoving; 

-(id)initTutorialActionWith:(TutorialSequenceActionManager *)_sequenceManager dictionaryData:(NSMutableDictionary *)_actionData;

-(void)runAction;
-(void)pauseAction;
-(void)stopAction;

-(void)callFunctionInGameActionCallback:(id)_targetObj;
-(void)finishedActionCallback;

-(TutorialAction *)getChildActionAtIndex:(int)_index;
-(BOOL)updateChildActionAtIndex:(int)_index withAction:(TutorialAction *)_action;

-(void)reorderZIndexOfObjectTarget:(TutorialObject *)_target;

@end
