//
//  OnPointsMovingController.m
//  LibGame
//
//  Created by User on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OnPointsMovingController.h"
#import "MovingObject.h"
#import "BezierInterpolationController.h"
#import "LagrangeInterpolationController.h"
#import "NewtonInterpolationController.h"
#import "NaturalCubicSplineInterpolationController.h"
#import "CatmullRomInterpolationController.h"

@implementation OnPointsMovingController


+(id)onPointsMovingWithDuration:(ccTime)_duration andRotateTarget:(BOOL)_isRotate andPointsList:(NSValue*)_points, ...{
    NSMutableArray * arrPoints = [[NSMutableArray alloc] init];
    
    va_list params;
	va_start(params,_points);
	
    [arrPoints addObject:_points];
    
	NSValue* now;
	while(_points) {
		now = va_arg(params,NSValue*);
		if (now)
			[arrPoints addObject:now];
		else
			break;
	}
    
	va_end(params); 
    return [[self alloc] initOnPointsMovingControllerWithDuration:_duration andPointsArray:arrPoints andRotateTarget:_isRotate];
}

-(id)initOnPointsMovingControllerWithDuration:(ccTime)_duration andRotateTarget:(BOOL)_isRotate andPointsList:(NSValue*)_points, ...{
    NSMutableArray * arrPoints = [[NSMutableArray alloc] init];
    
    va_list params;
	va_start(params,_points);
	
    [arrPoints addObject:_points];
    
	NSValue* now;
	while(_points) {
		now = va_arg(params,NSValue*);
		if (now)
			[arrPoints addObject:now];
		else
			break;
	}
    
	va_end(params);
    
    return [self initOnPointsMovingControllerWithDuration:_duration andPointsArray:arrPoints andRotateTarget:_isRotate];
}

-(id)initOnPointsMovingControllerWithDuration:(ccTime)_duration andPointsArray:(NSMutableArray*)_points andRotateTarget:(BOOL)_isRotate{
    self = [super initMovingControllerWith:_duration andRotateTarget:_isRotate];
    points = _points;
    smoothValue = 5;
    return self;
}

//Phát sinh điểm theo thuật toán và làm mượt các điểm
-(NSMutableArray*)generateMovingPathWith:(NSMutableArray*)_points withSmoothValue:(float)_smoothValue{
    NSMutableArray * roughPoints = [[NSMutableArray alloc] init];
    for (float i = [[_points objectAtIndex:0] pointValue].x ; i < [[_points lastObject] pointValue].x ; i+= smoothValue) {
        [roughPoints addObject:[NSValue valueWithPoint:ccp(i, [self valueLagrangeYWith:_points andTime:i])]];
    }
    
    //Smoothing
    NSMutableArray * smoothPoints = [[NSMutableArray alloc] init];
    
    CGPoint start;
    CGPoint end;
    
    for (int i = 0; i < [roughPoints count] - 1; i++) {
        
        if (i == 0) {
            start = [(NSValue*)[roughPoints objectAtIndex:i] pointValue];
        } else {
            start = [(NSValue*)[smoothPoints lastObject] pointValue];
        }
        
        end = [(NSValue*)[roughPoints objectAtIndex:i+1] pointValue];
        
        CGFloat distance = ccpDistance(start, end);
        
        if (_smoothValue > distance) {
            do {
                i++;
                end = [(NSValue*)[roughPoints objectAtIndex:i] pointValue];
                distance = ccpDistance(start, end);
                
            } while (_smoothValue > distance && i < [roughPoints count]-1);
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



-(CGFloat)valueLagrangeYWith:(NSMutableArray *)_arrayPoint andTime:(ccTime)_dt {
    float y = 0.0;
    //  float t;
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

-(void)startMovingWithTarget:(MovingObject *)_target{
    [super startMovingWithTarget:_target];
    [points insertObject:[NSValue valueWithPoint:target.spriteBody.position] atIndex:0];
    CatmullRomInterpolationController *interpolationCatMull = [[CatmullRomInterpolationController alloc] initMovingInterpolationWith:points];
    
    // Tension: độ cong thường lấy là 0.5, bằng 0 la đường thẳng
    // Segment: Số điểm nội suy giữa hai toạ độ
    pointsPath = [interpolationCatMull runMovingInterpolationWithEpsilion:smoothValue andTension:0.5 andSegment:100];
    
    lengthPath = 0;
    for (int i = 0; i < [pointsPath count] - 1; i++) {
        lengthPath += ccpDistance([[pointsPath objectAtIndex:i] pointValue], [[pointsPath objectAtIndex:(i+1)] pointValue]);
    }
    lastPoint = [[pointsPath objectAtIndex:0] pointValue];
    
    lastIndex = 0;
    tempCount = 0;
    //firstTick = NO;
    
    [points removeObjectAtIndex:0];
}

-(void)update:(ccTime)dt{
    [super update:dt];
    if (firstTick) {
//        [points insertObject:[NSValue valueWithCGPoint:target.spriteBody.position] atIndex:0];
//        
//        //pointsPath = [self generateMovingPathWith:points withSmoothValue:smoothValue];
//        interpolationFunction = [[BezierInterpolationController alloc] initMovingInterpolationWith:points];
//        pointsPath = [interpolationFunction runMovingInterpolationWithEpsilion:smoothValue];
//        
//        lengthPath = 0;
//        for (int i = 0; i < [pointsPath count] - 1; i++) {
//            lengthPath += ccpDistance([[pointsPath objectAtIndex:i] CGPointValue], [[pointsPath objectAtIndex:(i+1)] CGPointValue]);
//        }
//        lastPoint = [[pointsPath objectAtIndex:0] CGPointValue] ;
//        
//        NSLog(@"==Khoang cach %f" , ccpDistance([[points lastObject] CGPointValue], [[pointsPath lastObject]CGPointValue]));
//        
//        lastIndex = 0;
//        tempCount = 0;
        firstTick = NO;
    }

    CGPoint newPoint;
    
    //Tính khoảng cách di chuyển trong 1 step
    float length = dt / duration * lengthPath;
    //Tính khoảng cách từ vị trí mới đến nút tiếp theo trong đường di chuyển.
    float lengthFromNextPoint = length - ccpDistance(lastPoint, [[pointsPath objectAtIndex:lastIndex + 1] pointValue]);
    
    //Nếu giá trị < 0 nghĩa là vị trí mới này chưa vượt qua nút mới trong đường di chuyển.
    if (lengthFromNextPoint < 0) {
        //Tính toán vị trí mới nằm giữa vị trí cũ và nút gần nhất nằm sau vị trí cũ.
        float alpha = length/ccpDistance(lastPoint, [[pointsPath objectAtIndex:lastIndex + 1] pointValue]);
        float newX = alpha*([[pointsPath objectAtIndex:lastIndex + 1] pointValue].x - lastPoint.x) + lastPoint.x;
        float newY = alpha*([[pointsPath objectAtIndex:lastIndex + 1] pointValue].y - lastPoint.y) + lastPoint.y;
        newPoint = ccp(newX, newY);
    }else {
        //Tính khoảng cách từ vị trí mới đến vị trí cũ theo số nút.
        int numOfStep = lengthFromNextPoint / smoothValue;
        if (lastIndex + numOfStep >= [pointsPath count] - 2) {
            newPoint = [[pointsPath lastObject] pointValue];
        }else {
            float lengthFromNearPoint = lengthFromNextPoint - smoothValue * numOfStep;
            
            float alpha = lengthFromNearPoint/smoothValue;
            
            float newX = alpha*([[pointsPath objectAtIndex:lastIndex + numOfStep + 2] pointValue].x - [[pointsPath objectAtIndex:lastIndex + numOfStep + 1] pointValue].x) + [[pointsPath objectAtIndex:lastIndex + numOfStep + 1] pointValue].x;
            float newY = alpha*([[pointsPath objectAtIndex:lastIndex + numOfStep + 2] pointValue].y - [[pointsPath objectAtIndex:lastIndex + numOfStep + 1] pointValue].y) + [[pointsPath objectAtIndex:lastIndex + numOfStep + 1] pointValue].y;
            newPoint = ccp(newX, newY);
            
            //Lưu lại nút gần nhất trong đường di chuyển trước vị trí mới của object
            lastIndex = lastIndex + numOfStep + 1;

        }
        
    }

//    if (newPoint.x - lastPoint.x > 0) {
//        target.spriteBody.flipX = YES;
//    }else {
//        target.spriteBody.flipX = NO;
//    }
//    
    [target setPosition:ccpAdd(ccp([target getPosition].x, [target getPosition].y),ccpSub(newPoint, lastPoint))];
    
    //set rotate
    [self makeTargetRotateWith:ccpSub(newPoint, lastPoint)];

    
    lastPoint = newPoint;
}

@end
