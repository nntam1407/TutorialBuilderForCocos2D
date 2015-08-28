//
//  LagrangeInterpolationController.h
//  LibGame
//
//  Created by User on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingInterpolationController.h"

@interface LagrangeInterpolationController : MovingInterpolationController{
    
}

-(id)initLagrangeInterpolationControllerWith:(NSMutableArray *)_points;

-(NSMutableArray*)runMovingInterpolationWithEpsilion:(float)_smoothValue;

-(CGFloat)valueYWith:(NSMutableArray *)_arrayPoint andTime:(ccTime)_dt ;

@end
