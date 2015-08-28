//
//  BezierInterpolationController.h
//  LibGame
//
//  Created by User on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingInterpolationController.h"

@interface BezierInterpolationController : MovingInterpolationController{
    
}

-(CGPoint)getPointWith:(float)_number andPoints:(NSMutableArray*)_points;
-(float)factoral:(float)value;

@end
