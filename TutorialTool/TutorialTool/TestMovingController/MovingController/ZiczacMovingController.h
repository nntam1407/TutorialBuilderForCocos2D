//
//  ZiczacMovingController.h
//  LibGame
//
//  Created by User on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingController.h"

@interface ZiczacMovingController : MovingController{
    CGPoint startPos;
    CGPoint endPos;
    CGPoint delta;
    int revert;
    
    int loopNumber;//so buoc song
    float startAmplitude;//bien do cua buoc song
    float endAmplitude;
    float currentAmplitude;
    float dtAmplitude;
    double sinAngle;
    double cosAngle;
    BOOL positive;
    
    BOOL needToChangeDirection;
    float timeToChangeDirection;
    float timeCounter;
}

+(id)ziczacMovingWithDuration:(ccTime)_duration position:(CGPoint)_p amplitude:(float)_amplitude loopNumber:(int)_loopNumber positive:(BOOL)_positive andRotateTarget:(BOOL)_isRotate;
+(id)ziczacMovingWithDuration:(ccTime)_duration position:(CGPoint)_p startAmplitude:(float)_startAmplitude endAmplitude:(float)_endAmplitude loopNumber:(int)_loopNumber positive:(BOOL)_positive andRotateTarget:(BOOL)_isRotate;

-(id)initZiczacMovingControllerWithDuration:(ccTime)_duration position:(CGPoint)_p amplitude:(float)_amplitude loopNumber:(int)_loopNumber positive:(BOOL)_positive andRotateTarget:(BOOL)_isRotate;
-(id)initZiczacMovingControllerWithDuration:(ccTime)_duration position:(CGPoint)_p startAmplitude:(float)_startAmplitude endAmplitude:(float)_endAmplitude loopNumber:(int)_loopNumber positive:(BOOL)_positive andRotateTarget:(BOOL)_isRotate;

@end
