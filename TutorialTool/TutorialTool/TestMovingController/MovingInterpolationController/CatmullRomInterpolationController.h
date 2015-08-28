//
//  CatmullRomInterpolationController.h
//  LibGame
//
//  Created by User on 10/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingInterpolationController.h"

@interface CatmullRomInterpolationController : MovingInterpolationController{
    
}

-(NSMutableArray*) drawCatmullRomSplinesWith:(NSMutableArray*)_points andTension:(CGFloat)_tension andSegment:(int)_segments;

-(NSMutableArray*)runMovingInterpolationWithEpsilion:(float)_smoothValue andTension:(CGFloat)_tension andSegment:(int)_segments;

@end
