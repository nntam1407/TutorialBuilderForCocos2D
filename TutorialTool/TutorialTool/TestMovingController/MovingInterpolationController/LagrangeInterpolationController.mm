//
//  LagrangeInterpolationController.m
//  LibGame
//
//  Created by User on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LagrangeInterpolationController.h"

@implementation LagrangeInterpolationController

-(id)initLagrangeInterpolationControllerWith:(NSMutableArray *)_points{
    self = [super initMovingInterpolationWith:_points];
    
       
    return self;
}

-(NSMutableArray*)runMovingInterpolationWithEpsilion:(float)_smoothValue{
    
    NSMutableArray *outputPoints = [[NSMutableArray alloc] init];
    
    //Code for Interpolation
    if ([points count] >= 2 ) {
        CGPoint start = [(NSValue*)[points objectAtIndex:0] pointValue];
        CGPoint end = [(NSValue*)[points lastObject] pointValue];
        if (start.x <= end.x) {
            for (int i = start.x; i < end.x; i++) {
                
                CGPoint position = ccp(i, [self valueYWith:points andTime:i]);
                [outputPoints addObject:[NSValue valueWithPoint:position]];
            }  
        }
    }
    
    outputPoints = [MovingInterpolationController pointCurveWith:outputPoints andEpsilon:_smoothValue];
    
    return outputPoints;
}

-(CGFloat)valueYWith:(NSMutableArray *)_arrayPoint andTime:(ccTime)_dt {
    
    float y = 0.0;
    
    for (int k = 0; k < [_arrayPoint count]; k++) {
        CGPoint pointK = [(NSValue*)[_arrayPoint objectAtIndex:k] pointValue];
        float la = 1.0;
        for (int i = 0; i < [_arrayPoint count]; i++) {
            CGPoint point = [(NSValue*)[_arrayPoint objectAtIndex:i] pointValue];
            if (i != k) {
                la = la*(_dt - point.x)/(pointK.x - point.x);
            } 
        }
        y = y + pointK.y*la;
    }
    return y;
}

@end
