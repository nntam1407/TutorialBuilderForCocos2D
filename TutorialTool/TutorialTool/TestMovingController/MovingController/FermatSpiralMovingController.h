//
//  FermatSpiralMovingController.h
//  LibGame
//
//  Created by User on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingController.h"
#import "MovingObject.h"

@interface FermatSpiralMovingController : MovingController{

    //Cac tham so cuc bo
    CGPoint startPos;
    float distance;
    CGPoint delta;
    float amplitudeY;
    float distanceInterval;
    float iniPhase;
    float cycle;
    float omega;
    
    //Cac tham so truyen vao
    CGPoint endPos;
    float angle;
    BOOL clockWise;
    
}

+(id)runFermatSpiralMovingControllerWithDuration:(ccTime)_duration andDestination:(CGPoint)_endPoint andRotateTarget:(BOOL)_isRotate;

-(id)initFermatSpiralMovingControllerWithDuration:(ccTime)_duration andDestination:(CGPoint)_endPoint andRotateTarget:(BOOL)_isRotate;

@end
