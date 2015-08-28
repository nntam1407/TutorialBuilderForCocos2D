//
//  SpringMovingController.h
//  LibGame
//
//  Created by User on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingController.h"
#import "MovingObject.h"

@interface SpringMovingController : MovingController{
    
    
    //Cac thong so cuc bo
    float radius;
    CGPoint startPos;
    float cycle;
    float totalTime;
    float iniPhase;
    CGPoint center;
    float distance;
    CGPoint endPosTemp;
    float sinAngle;
    float cosAngle;
    float positive;
    
    //Cac tham so dau vao
    CGPoint endPos;
    float amplitude;
    float distanceInterval;
    BOOL clockwise;
    int numberLoop;
}

+(id)springMovingControllerWithDuration:(ccTime)_duration andDestination:(CGPoint)_endPoint andAmplitude:(float)_amplitude andNumberLoop:(int)_numberLoop andPositive:(BOOL)_positive andDistance:(float)_distanceInterval andRotateTarget:(BOOL)_isRotate;

-(id)initSpringMovingControllerWithDuration:(ccTime)_duration andDestination:(CGPoint)_endPos andAmplitude:(float)_amplitude andNumberLoop:(int)_numberLoop andPositive:(BOOL)_positive andDistance:(float)_distanceInterval andRotateTarget:(BOOL)_isRotate;

@end
