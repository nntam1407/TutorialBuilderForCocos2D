//
//  NewtonInterpolationController.m
//  LibGame
//
//  Created by User on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewtonInterpolationController.h"

@implementation NewtonInterpolationController

-(NSMutableArray*)runMovingInterpolationWithEpsilion:(float)_smoothValue{
    
    NSMutableArray *outputPoints = [[NSMutableArray alloc] init];
    
    //Code for Interpolation
    if ([points count] >= 2 ) {
        CGPoint start = [(NSValue*)[points objectAtIndex:0] pointValue];
        CGPoint end = [(NSValue*)[points lastObject] pointValue];
        if (start.x <= end.x) {
            for (int i = start.x; i < end.x; i++) {
                
                CGPoint position = ccp(i, [self valueYWithNewton:points andValueX:i]);
                [outputPoints addObject:[NSValue valueWithPoint:position]];
            }  
        }
    }
    
    outputPoints = [MovingInterpolationController pointCurveWith:outputPoints andEpsilon:_smoothValue];
    
    return outputPoints;
}


-(float)calculateValueFWith:(NSMutableArray *)_arr andI:(NSInteger)_i andJ:(NSInteger)_j {
    CGPoint point1 = [(NSValue*)[_arr objectAtIndex:_i] pointValue];
    CGPoint point2 = [(NSValue*)[_arr objectAtIndex:_j] pointValue];
    
    if(_j == _i + 1) 
        return (point2.y - point1.y)/(point2.x - point1.x);
    else {
        return ([self calculateValueFWith:_arr andI:_i + 1 andJ:_j] - [self calculateValueFWith:_arr andI:_i andJ:_j - 1])/(point2.x - point1.x);
    }
}

-(CGFloat)valueYWithNewton:(NSMutableArray *)_arrayPoint andValueX:(float)_valueX {
    CGPoint point = [(NSValue*)[_arrayPoint objectAtIndex:0] pointValue];
    float y = point.y;
    
    for (int i = 1; i < [_arrayPoint count]; i++) {
        float ne = 1.0f;
        for (int j = 0; j <= i - 1; j++) {
            CGPoint po1 = [(NSValue*)[_arrayPoint objectAtIndex:j] pointValue];    
            ne = ne*(_valueX - po1.x);
            
        }
        y = y + ne*[self calculateValueFWith:_arrayPoint andI:0 andJ:i];
    }
    
    return y;
}


@end
