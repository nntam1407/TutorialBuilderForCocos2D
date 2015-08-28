//
//  TutorialObject.h
//  LibGame
//
//  Created by User on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCSprite.h"
#import "TutorialLibDefine.h"
#import "MovingObject.h"

@class TutorialStoryboard;

extern int editMouseMode;

@interface TutorialObject : MovingObject <CCMouseEventDelegate>{
    TutorialStoryboard *tutorialStoryboardHandler;
    
    NSMutableDictionary *objectData;
    
    CGPoint oldMousePosition;
    
    BOOL holding;
    BOOL isRotating;
    
    CCSprite *rotateIcon;
    CCSprite *rotateCenter;
    CCSprite *frameBorder;
}

@property (nonatomic,retain) NSMutableDictionary *objectData;

-(id)initTutorialObjectWith:(TutorialStoryboard *)_tutorialStorboardHandler withData:(NSMutableDictionary *)_objectData;
-(void)applyObjectBodyProperties;

-(BOOL)isPointInSpriteRectWithPoint:(CGPoint)_point;

-(void)createFrameBorder;
-(void)createRotateIcon;

-(void)showEffectWhenSelected;
-(void)hideEffectWhenDeselected;

-(void)turnOnRotateModeIfTouchAtPoint:(CGPoint)_point;

-(void)changeObjectRotationWithPointDrag:(CGPoint)_point;

@end
