//
//  OnPointsMovingController.h
//  LibGame
//
//  Created by User on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingController.h"
#import "MovingInterpolationController.h"

@interface OnPointsMovingController : MovingController{
    NSMutableArray * points;
    NSMutableArray * pointsPath;
    float smoothValue;
    float lengthPath;
    
    float tempCount;
    int lastIndex;
    CGPoint lastPoint;
    
    MovingInterpolationController * interpolationFunction;
}

+(id)onPointsMovingWithDuration:(ccTime)_duration andRotateTarget:(BOOL)_isRotate andPointsList:(NSValue*)_points, ... NS_REQUIRES_NIL_TERMINATION;
-(id)initOnPointsMovingControllerWithDuration:(ccTime)_duration andRotateTarget:(BOOL)_isRotate andPointsList:(NSValue*)_points, ... NS_REQUIRES_NIL_TERMINATION;
-(id)initOnPointsMovingControllerWithDuration:(ccTime)_duration andPointsArray:(NSMutableArray*)_points andRotateTarget:(BOOL)_isRotate;
-(CGFloat)valueLagrangeYWith:(NSMutableArray *)_arrayPoint andTime:(ccTime)_dt;
@end
