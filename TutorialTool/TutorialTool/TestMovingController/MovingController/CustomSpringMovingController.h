//
//  CustomSpringMovingController.h
//  LibGame
//
//  Created by User on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingController.h"
#import "MovingObject.h"

@interface CustomSpringMovingController : MovingController{
    
    //Cac bien cuc bo
    CGPoint startPos;
    CGPoint center;
    CGPoint delta;
    CGPoint endPosTemp;
    float iniPhase;
    float distanceInterval;
    float cycle;
    float radius;
    float distance;
    float sinAngle;
    float cosAngle;
    float intervalAmplitude;
    
    
    //Cac tham so dau vao
    CGPoint endPos;
    float maxAmplitude;
    float minAmplitude;
    int numberSpring;
    int positive;
    int inscrease;
}



+(id)runCustomSpringMovingControllerWithDuration:(ccTime)_duration andAmplitudeMax:(float)_amplitudeMax andAmplitudeMin:(float)_amplitudeMin andEndPosition:(CGPoint)_endPoint andNumberSpring:(int)_numberSpring andDistanceBetween:(float)_distanceInterval andIsPositive:(BOOL)_positive andIsInscrease:(BOOL)_isInscrease andRotateTarget:(BOOL)_isRotate;

-(id)initCustomSpringMovingControllerWithDuration:(ccTime)_duration andAmplitudeMax:(float)_amplitudeMax andAmplitudeMin:(float)_amplitudeMin andEndPosition:(CGPoint)_endPoint andNumberSpring:(int)_numberSpring andDistanceBetween:(float)_distanceInterval andIsPositive:(BOOL)_positive andIsInscrease:(BOOL)_isInscrease andRotateTarget:(BOOL)_isRotate;

@end
