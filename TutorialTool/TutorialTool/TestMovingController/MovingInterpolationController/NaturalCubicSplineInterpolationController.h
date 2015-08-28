//
//  NaturalCubicSplineInterpolationController.h
//  LibGame
//
//  Created by User on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingInterpolationController.h"

@interface NaturalCubicSplineInterpolationController : MovingInterpolationController{
    
}


-(float)valueCubicSpline:(NSMutableArray*)_arr andValueK:(NSInteger)_valueK andValueX:(float)_valueX;

-(NSMutableArray *)calculatingZi:(NSMutableArray *)_arr ;

@end
