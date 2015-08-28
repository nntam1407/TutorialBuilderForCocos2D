//
//  NewtonInterpolationController.h
//  LibGame
//
//  Created by User on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingInterpolationController.h"

@interface NewtonInterpolationController : MovingInterpolationController{
    
}


-(float)calculateValueFWith:(NSMutableArray *)_arr andI:(NSInteger)_i andJ:(NSInteger)_j ;

-(CGFloat)valueYWithNewton:(NSMutableArray *)_arrayPoint andValueX:(float)_valueX ;
@end
