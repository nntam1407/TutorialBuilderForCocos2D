//
//  MovingInterpolationController.m
//  LibGame
//
//  Created by User on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingInterpolationController.h"

@implementation MovingInterpolationController

-(id)initMovingInterpolationWith:(NSMutableArray *)_points{
    self = [super init];
    
    points = [[NSMutableArray alloc] initWithArray:_points];
    
    return self;
}

-(NSMutableArray*)runMovingInterpolationWithEpsilion:(float)_smoothValue{
    
    return nil;
}

+(NSMutableArray *)pointCurveWith:(NSMutableArray*)_roughPoints andEpsilon:(float)_smoothValue {
    //Smoothing
    NSMutableArray * smoothPoints = [[NSMutableArray alloc] init];
    
    CGPoint start;
    CGPoint end;
    
    for (int i = 0; i < [_roughPoints count] - 1; i++) {
        
        if (i == 0) {
            start = [(NSValue*)[_roughPoints objectAtIndex:i] pointValue];
        } else {
            start = [(NSValue*)[smoothPoints lastObject] pointValue];
        }
        
        end = [(NSValue*)[_roughPoints objectAtIndex:i+1] pointValue];
        
        CGFloat distance = ccpDistance(start, end);
        
        if (_smoothValue > distance) {
            do {
                i++;
                end = [(NSValue*)[_roughPoints objectAtIndex:i] pointValue];
                distance = ccpDistance(start, end);
                
            } while (_smoothValue > distance && i < [_roughPoints count]-1);
        }
        
        float alpha = _smoothValue/distance;
        float deltaX = alpha*(end.x - start.x);
        float deltaY = alpha*(end.y - start.y);
        if ([smoothPoints count] == 0) {
            [smoothPoints addObject:[NSValue valueWithPoint:start]];
        }
        if (_smoothValue < distance) {
            for (int j = 1; _smoothValue*j <= distance; j++) {
                CGFloat valueX = start.x + j*deltaX;
                CGFloat valueY = start.y + j*deltaY;
                
                [smoothPoints addObject:[NSValue valueWithPoint:ccp(valueX, valueY)]];
            }
        }
    }
    
    return smoothPoints;
}

@end
