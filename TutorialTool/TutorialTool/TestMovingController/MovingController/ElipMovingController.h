//
//  ElipMovingController.h
//  LibGame
//
//  Created by User on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingController.h"
#import "MovingObject.h"

@interface ElipMovingController : MovingController{
    
    //Cac thong so cuc bo
    float distance;
    float radius;
    CGPoint startPos;
    CGPoint center;
    CGPoint delta;
    CGPoint endPosTemp;
    float cosAngle;
    float sinAngle;
    float iniPhase;
    int positive;
    float totalTime;
    
    
    //Cac tham so dau vao
    float amplitude;
    CGPoint endPos;
    BOOL clockwise;
}

+(id)runElipMovingControllerWithDuration:(ccTime)_duration position:(CGPoint)_p andAmplitude:(float)_amplitude clockwise:(BOOL)_clockwise andRotateTarget:(BOOL)_isRotate;

-(id)initElipMovingControllerWithDuration:(ccTime)_duration position:(CGPoint)_p andAmplitude:(float)_amplitude clockwise:(BOOL)_clockwise andRotateTarget:(BOOL)_isRotate;

@end
