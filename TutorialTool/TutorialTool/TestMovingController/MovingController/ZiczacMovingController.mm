//
//  ZiczacMovingController.m
//  LibGame
//
//  Created by User on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZiczacMovingController.h"
#import "MovingObject.h"

@implementation ZiczacMovingController


+(id)ziczacMovingWithDuration:(ccTime)_duration position:(CGPoint)_p amplitude:(float)_amplitude loopNumber:(int)_loopNumber positive:(BOOL)_positive andRotateTarget:(BOOL)_isRotate{
    return [[self alloc] initZiczacMovingControllerWithDuration:_duration position:_p amplitude:_amplitude loopNumber:_loopNumber positive:_positive andRotateTarget:_isRotate];
}

+(id)ziczacMovingWithDuration:(ccTime)_duration position:(CGPoint)_p startAmplitude:(float)_startAmplitude endAmplitude:(float)_endAmplitude loopNumber:(int)_loopNumber positive:(BOOL)_positive andRotateTarget:(BOOL)_isRotate{
    return [[self alloc] initZiczacMovingControllerWithDuration:_duration position:_p startAmplitude:_startAmplitude endAmplitude:_endAmplitude loopNumber:_loopNumber positive:_positive andRotateTarget:_isRotate];
}

-(id)initZiczacMovingControllerWithDuration:(ccTime)_duration position:(CGPoint)_p amplitude:(float)_amplitude loopNumber:(int)_loopNumber positive:(BOOL)_positive andRotateTarget:(BOOL)_isRotate {
    NSLog(@"INIT");
    self = [super initMovingControllerWith:_duration andRotateTarget:_isRotate];
    endPos = _p;
    startAmplitude = _amplitude;
    endAmplitude = _amplitude;
    loopNumber = _loopNumber;
    positive = _positive;
    needToChangeDirection = YES;
    timeToChangeDirection = duration / (loopNumber * 4);
    return self;
}

-(id)initZiczacMovingControllerWithDuration:(ccTime)_duration position:(CGPoint)_p startAmplitude:(float)_startAmplitude endAmplitude:(float)_endAmplitude loopNumber:(int)_loopNumber positive:(BOOL)_positive andRotateTarget:(BOOL)_isRotate{
    NSLog(@"INIT");
    self = [super initMovingControllerWith:_duration andRotateTarget:_isRotate];
    endPos = _p;
    startPos = ccp(-1, -1);
    startAmplitude = _startAmplitude;
    endAmplitude = _endAmplitude;
    loopNumber = _loopNumber;
    positive = _positive;
    revert = 1;
    needToChangeDirection = YES;
    timeToChangeDirection = duration / (loopNumber * 4);
    return self;
}

-(BOOL)isDone{
    if ([super isDone]) {
        revert==1?[target setPosition:endPos]:[target setPosition:startPos];
        return YES;
    }
    return NO;
}


-(void)update:(ccTime)dt{
    [super update:dt];
    if (firstTick) {
        
        
        //Tinh toa do diem bat dau
        if(startPos.x==-1&&startPos.y==-1){
            //Truong hop moi bat dau
            startPos = [target getPosition];
        }else {
            //Truong hop tiep tuc trong RepeatMoving
            if(dt>0){
                revert = 1;
                startPos = target.spriteBody.position;
                [target setPosition:startPos];
            }else {
                revert = -1;
            }
        }
        
//        NSLog(@"Start position is %f, %f",[target getPosition].x,[target getPosition].y);
        
        delta = ccpSub(endPos, startPos);
        //Tinh goc lech khi di chuyen
        float distance = ccpLength(delta);
        if(startPos.x > endPos.x){
            distance *= -1;
        }
        
        float mirrorEdge = fabsf(startPos.y - endPos.y);
        sinAngle = mirrorEdge/distance;
        cosAngle = sqrt(1-pow(sinAngle, 2));
        dtAmplitude = (endAmplitude - startAmplitude) / (loopNumber * 2);
        
        if (positive) {
            currentAmplitude = -startAmplitude;
        }
        else {
            currentAmplitude = startAmplitude;
        }
        
        timeCounter = 0;
        firstTick = NO;
    }

    timeCounter += fabsf(dt);
    if (timeCounter >= timeToChangeDirection) {
        timeCounter = timeCounter - timeToChangeDirection;
        if (needToChangeDirection) {
            currentAmplitude > 0 ? currentAmplitude += dtAmplitude : currentAmplitude -= dtAmplitude;
            currentAmplitude = -currentAmplitude;
            
            needToChangeDirection = NO;
        }else {
            needToChangeDirection = YES;
        }
    }
    
    CGPoint de = ccp(ccpLength(delta) / duration * dt,  dt * currentAmplitude / timeToChangeDirection);
    
    float newXPos = de.x*cosAngle-de.y*sinAngle;
    float newYPos = (de.y+newXPos*sinAngle)/cosAngle;
    
    CGPoint changeCoordinatePos = ccp(newXPos, newYPos);
    

    [target setPosition:ccp([target getPosition].x + changeCoordinatePos.x, [target getPosition].y + changeCoordinatePos.y)];
    
    [self makeTargetRotateWith:changeCoordinatePos];
}

@end
