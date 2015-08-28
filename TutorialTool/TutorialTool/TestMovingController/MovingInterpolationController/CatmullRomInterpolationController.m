//
//  CatmullRomInterpolationController.m
//  LibGame
//
//  Created by User on 10/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CatmullRomInterpolationController.h"

@implementation CatmullRomInterpolationController


-(NSMutableArray*)runMovingInterpolationWithEpsilion:(float)_smoothValue andTension:(CGFloat)_tension andSegment:(int)_segments {
    
    NSMutableArray *outputPoints = [[NSMutableArray alloc] init];
    
    outputPoints = [self drawCatmullRomSplinesWith:points andTension:_tension andSegment:_segments];
    
    outputPoints = [MovingInterpolationController pointCurveWith:outputPoints andEpsilon:_smoothValue];
    
    return outputPoints;
}

-(NSMutableArray*) drawCatmullRomSplinesWith:(NSMutableArray*)_points andTension:(CGFloat)_tension andSegment:(int)_segments{
    
    NSMutableArray *outputPoint = [[NSMutableArray alloc] init];
    float px, py;
    float tt, _1t, _2t;
    float h00, h10, h01, h11;
    CGPoint m0;
    CGPoint m1;
    CGPoint m2;
    CGPoint m3;
    
    float rez = 1.0f / _segments;
    
    for (int n = 0; n < [_points count]; n++) {
        
        for (float t = 0.0f; t < 1.0f; t += rez) {
            tt = t * t;
            _1t = 1 - t;
            _2t = 2 * t;
            h00 =  (1 + _2t) * (_1t) * (_1t);
            h10 =  t  * (_1t) * (_1t);
            h01 =  tt * (3 - _2t);
            h11 =  tt * (t - 1);
            
            if (!n) {
                
                m0 = ccpMult(ccpSub([[_points objectAtIndex:n+1] pointValue], [[_points objectAtIndex:n] pointValue]), _tension);
                m1 = ccpMult(ccpSub([[_points objectAtIndex:n+2] pointValue], [[_points objectAtIndex:n] pointValue]), _tension);
                
                px = h00 * [[_points objectAtIndex:n] pointValue].x + h10 * m0.x + h01 * [[_points objectAtIndex:n+1] pointValue].x + h11 * m1.x;
                py = h00 * [[_points objectAtIndex:n] pointValue].y + h10 * m0.y + h01 * [[_points objectAtIndex:n+1] pointValue].y + h11 * m1.y;
            }
            else if (n < [_points count]-2) {
                
                m1 = ccpMult(ccpSub([[_points objectAtIndex:n+1] pointValue], [[_points objectAtIndex:n-1] pointValue]), _tension);
                m2 = ccpMult(ccpSub([[_points objectAtIndex:n+2] pointValue], [[_points objectAtIndex:n] pointValue]), _tension);
                px = h00 * [[_points objectAtIndex:n] pointValue].x + h10 * m1.x + h01 * [[_points objectAtIndex:n+1] pointValue] .x + h11 * m2.x;
                py = h00 * [[_points objectAtIndex:n] pointValue].y + h10 * m1.y + h01 * [[_points objectAtIndex:n+1] pointValue] .y + h11 * m2.y;
            }
            else if (n == [_points count]-1) {
                
                m2 = ccpMult(ccpSub([[_points objectAtIndex:n] pointValue], [[_points objectAtIndex:n-2] pointValue]), _tension);
                m3 = ccpMult(ccpSub([[_points objectAtIndex:n] pointValue], [[_points objectAtIndex:n-1] pointValue]), _tension);
                px = h00 * [[_points objectAtIndex:n-1] pointValue].x + h10 * m2.x + h01 * [[_points objectAtIndex:n] pointValue].x + h11 * m3.x;
                py = h00 * [[_points objectAtIndex:n-1] pointValue].y + h10 * m2.y + h01 * [[_points objectAtIndex:n] pointValue].y + h11 * m3.y;
            }  
            
            [outputPoint addObject:[NSValue valueWithPoint:ccp(px,py)]];
        }
    }
    
    return outputPoint;
}

@end
