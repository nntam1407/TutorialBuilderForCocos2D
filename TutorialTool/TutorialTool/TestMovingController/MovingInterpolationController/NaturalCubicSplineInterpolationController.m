//
//  NaturalCubicSplineInterpolationController.m
//  LibGame
//
//  Created by User on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NaturalCubicSplineInterpolationController.h"

@implementation NaturalCubicSplineInterpolationController

-(NSMutableArray*)runMovingInterpolationWithEpsilion:(float)_smoothValue{
    
    NSMutableArray *outputPoints = [[NSMutableArray alloc] init];
    
    //Code for Interpolation
    if ([points count] >=3) {
        for (int i = 0; i < [points count] - 1; i++) {
            CGPoint s = [(NSValue*)[points objectAtIndex:i] pointValue];
            CGPoint e = [(NSValue*)[points objectAtIndex:i+1] pointValue];
            
            if (s.x <= e.x) {
                for (int j = s.x; j <= e.x; j++) {
                    CGPoint position = ccp(j, [self valueCubicSpline:points andValueK:i andValueX:j]);
                    [outputPoints addObject:[NSValue valueWithPoint:position]];
                }
            } 
        }
    }
    
    outputPoints = [MovingInterpolationController pointCurveWith:outputPoints andEpsilon:_smoothValue];
    
    
    return outputPoints;
}


-(float)valueCubicSpline:(NSMutableArray*)_arr andValueK:(NSInteger)_valueK andValueX:(float)_valueX{
    
    float n = [_arr count];
    NSMutableArray *hi = [[NSMutableArray alloc] init];
    for (int i = 0; i < n - 1; i++) {
        CGPoint p0 = [(NSValue*)[_arr objectAtIndex:i] pointValue];
        CGPoint p1 = [(NSValue*)[_arr objectAtIndex:i+1] pointValue];
        [hi addObject:[NSNumber numberWithFloat:(p1.x - p0.x)]];
    }
    
    float h = [(NSNumber*)[hi objectAtIndex:_valueK] floatValue];
    
    NSMutableArray *zi = [self calculatingZi:_arr];
    float z0 = [(NSNumber*)[zi objectAtIndex:n-_valueK] floatValue];
    float z1 = [(NSNumber*)[zi objectAtIndex:n-_valueK-1] floatValue];
    
    float xi = [(NSValue*)[_arr objectAtIndex:_valueK] pointValue].x;
    
    float y0 = [(NSValue*)[_arr objectAtIndex:_valueK] pointValue].y;
    float y1 = [(NSValue*)[_arr objectAtIndex:_valueK+1] pointValue].y;
    
    float ai = y0;
    float bi = (y1 - y0)/h - h*z1/6 - h*z0/3;
    float ci = z0/2;
    float di = (z1 - z0)/h/6;
    
    float y = ai + bi*(_valueX - xi) + ci*powf((_valueX - xi), 2) + di*powf((_valueX - xi), 3);
    
    [zi removeAllObjects];
    
    return y;
}

-(NSMutableArray *)calculatingZi:(NSMutableArray *)_arr {
    
    int n = [_arr count];
    
    NSMutableArray *hi = [[NSMutableArray alloc] init];
    NSMutableArray *bi = [[NSMutableArray alloc] init];
    for (int i = 0; i <= n - 2; i++) {
        CGPoint p0 = [(NSValue*)[_arr objectAtIndex:i] pointValue];
        CGPoint p1 = [(NSValue*)[_arr objectAtIndex:i+1] pointValue];
        [hi addObject:[NSNumber numberWithFloat:(p1.x - p0.x)]];
        [bi addObject:[NSNumber numberWithFloat:(p1.y - p0.y)/[(NSNumber*)[hi objectAtIndex:i] floatValue]]];
    }
    
    NSMutableArray *ui = [[NSMutableArray alloc] init];
    NSMutableArray *vi = [[NSMutableArray alloc] init];
    float u0 = 2*([(NSNumber*)[hi objectAtIndex:0] floatValue] + [(NSNumber*)[hi objectAtIndex:1] floatValue]);
    float v0 = 6*([(NSNumber*)[bi objectAtIndex:1] floatValue] - [(NSNumber*)[bi objectAtIndex:0] floatValue]);
    [ui addObject:[NSNumber numberWithFloat:u0]];
    [vi addObject:[NSNumber numberWithFloat:v0]];
    
    for (int i = 1; i < n - 1; i++) {
        float h0 = [(NSNumber*)[hi objectAtIndex:i-1] floatValue];
        float h1 = [(NSNumber*)[hi objectAtIndex:i] floatValue];
        float b0 = [(NSNumber*)[bi objectAtIndex:i-1] floatValue];
        float b1 = [(NSNumber*)[bi objectAtIndex:i] floatValue];
        float u0 = [(NSNumber*)[ui objectAtIndex:i-1] floatValue];
        float v0 = [(NSNumber*)[vi objectAtIndex:i-1] floatValue];
        
        [ui addObject:[NSNumber numberWithFloat:2*(h0+h1)-powf(h0, 2)/u0]];
        [vi addObject:[NSNumber numberWithFloat:6*(b1-b0)-h0*v0/u0]];
    } 
    
    NSMutableArray *zi = [[NSMutableArray alloc] init];
    for (int i = n; i >= 0; i--) {
        if (i == n) {
            [zi addObject:[NSNumber numberWithFloat:0.0]];
        } else if (i == 0) {
            [zi addObject:[NSNumber numberWithFloat:0.0]];
        } else {
            float v0 = [(NSNumber*)[vi objectAtIndex:i-1] floatValue];
            float u0 = [(NSNumber*)[ui objectAtIndex:i-1] floatValue];
            float h0 = [(NSNumber*)[hi objectAtIndex:i-1] floatValue];
            float z1 = [(NSNumber*)[zi objectAtIndex:n-i-1] floatValue];
            [zi addObject:[NSNumber numberWithFloat:(v0 - h0*z1)/u0]];
        }
    }
    
    return zi;
}

@end
