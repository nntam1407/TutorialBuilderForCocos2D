//
//  LinearMovingController.h
//  HeroBird
//
//  Created by VienTran on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingController.h"

@interface LinearMovingController : MovingController{
    CGPoint startPos;
    CGPoint endPos;
    CGPoint delta;
}

+(id)linearMovingWithDuration:(ccTime)_duration position:(CGPoint)_p andRotateTarget:(BOOL)_isRotate;
-(id)initLinearMovingControllerWithDuration:(ccTime)_duration position:(CGPoint)_p andRotateTarget:(BOOL)_isRotate;

@end
