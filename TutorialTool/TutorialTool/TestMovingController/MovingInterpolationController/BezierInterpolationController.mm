//
//  BezierInterpolationController.m
//  LibGame
//
//  Created by User on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BezierInterpolationController.h"

@implementation BezierInterpolationController


-(NSMutableArray*)runMovingInterpolationWithEpsilion:(float)_smoothValue{
    
    NSMutableArray *outputPoints = [[NSMutableArray alloc] init];
    
    float number = 0.01;
    
    while (number<=1)
    {
        //get coordinates at position t
        CGPoint newPoint = [self getPointWith:number andPoints:points];
        [outputPoints addObject:[NSValue valueWithPoint:newPoint]];
        //increment position
        number += 0.01;
    }
    
    outputPoints = [MovingInterpolationController pointCurveWith:outputPoints andEpsilon:_smoothValue];
    
    return outputPoints;
}

-(CGPoint)getPointWith:(float)_number andPoints:(NSMutableArray*)_points{
    
    //clear totals
    float x = 0;
    float y = 0;
    //calculate n
    int n = _points.count-1;
    //calculate n!
    float factn = [self factoral:n];
    //loop thru points
    for (int i=0;i<=n;i++)
    {
        //calc binominal coefficent
        float b = factn/([self factoral:i]*[self factoral:n-i]);
        //calc powers
        float k = pow(1-_number, n-i)*pow(_number, i);
        //add weighted points to totals
        x += b*k*[[_points objectAtIndex:i] pointValue].x;
        y += b*k*[[_points objectAtIndex:i] pointValue].y;
    }
    //return result
    return ccp(x, y);
}

-(float)factoral:(float)value{
    
    //return special case
    if (value==0)
        return 1;
    //calc factoral of value
    float total = value;
    while (--value>1)
        total *= value;
    //return result
    return total;
}

@end
