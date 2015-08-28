//
//  RoundMovingController.m
//  LibGame
//
//  Created by User on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RoundMovingController.h"
#import "MovingObject.h"

@implementation RoundMovingController

+(id)roundMovingWithDuration:(ccTime)_duration position:(CGPoint)_p clockwise:(BOOL)_clockwise andRotateTarget:(BOOL)_isRotate{
    return [[self alloc] initRoundMovingControllerWithDuration:_duration position:_p clockwise:_clockwise andRotateTarget:_isRotate];
}

-(id)initRoundMovingControllerWithDuration:(ccTime)_duration position:(CGPoint)_p clockwise:(BOOL)_clockwise andRotateTarget:(BOOL)_isRotate{
    self = [super initMovingControllerWith:_duration andRotateTarget:_isRotate];
    endPos = _p;
    clockwise = _clockwise;
    startPos = ccp(-1, -1);
    return self;
}


-(void)update:(ccTime)dt{
    if (firstTick) {
        
        //Tinh toa do diem bat dau
        if(startPos.x==-1&&startPos.y==-1){
            //Truong hop moi bat dau
            startPos = [target getPosition];
        }else {
            //Truong hop tiep tuc trong RepeatMoving
            if(dt>0){
                startPos = startPos;
                [target setPosition:startPos];
            }else {
                [target setPosition:endPos];
            }
        }
        
        radius = ccpLength(ccpSub(startPos, endPos)) / 2;
        center = ccp((startPos.x + endPos.x)/2, (startPos.y + endPos.y)/2);
        cycle = duration * 2;
        
        CGPoint tempPoint = ccpSub(startPos, center);
        
        if (tempPoint.y < 0) {
            iniPhase = -ccpAngle(tempPoint, ccp(1, 0));
        }
        else {
            iniPhase = ccpAngle(tempPoint, ccp(1, 0));
        }
        
        totalTime = 0;
        firstTick = NO;
    }
    
    [super update:dt];
    
    CGPoint de;
    float x;
    float y;
    if(clockwise){
        x = radius * cos(-2*M_PI/cycle * totalTime + iniPhase);
        y = radius * sin(-2*M_PI/cycle * totalTime + iniPhase);
        de = ccp(x - radius * cos(-2*M_PI/cycle * (totalTime - dt) + iniPhase), y - radius * sin(-2*M_PI/cycle * (totalTime - dt) + iniPhase));
    }
    else {
        x = radius * cos(2*M_PI/cycle * totalTime + iniPhase);
        y = radius * sin(2*M_PI/cycle * totalTime + iniPhase);
        de = ccp(x - radius * cos(-2*M_PI/cycle * (totalTime - dt) + iniPhase), y - radius * sin(-2*M_PI/cycle * (totalTime - dt) + iniPhase));
    }
    
    totalTime += dt;
    
    if(dt<0){
        de = ccp(de.x*-1, de.y*-1);
    }
    
//    [target setPosition:ccpAdd(ccp(target.body2d->GetPosition().x * PTM_RATIO, target.body2d->GetPosition().y * PTM_RATIO), de)];
    
    [target setPosition:ccpAdd(ccp([target getPosition].x, [target getPosition].y), de)];
    
    [self makeTargetRotateWith:de];
}


//+(id)roundMovingWithDuration:(ccTime)_duration position:(CGPoint)_p radius:(float)_radius roundDirection:(RoundMoveDirection)_roundDirection{
//    return [[[self alloc] initRoundMovingControllerWithDuration:_duration position:_p radius:_radius roundDirection:_roundDirection] autorelease];
//    
//}
//
//-(id)initRoundMovingControllerWithDuration:(ccTime)_duration position:(CGPoint)_p radius:(float)_radius roundDirection:(RoundMoveDirection)_roundDirection{
//    self = [super initMovingControllerWith:_duration];
//    radius = _radius;
//    endPos = _p;
//    roundDirection = _roundDirection;
//    return self;
//}
//
//
//-(void)update:(ccTime)dt{
//    if (firstTick) {
//        //Tính toán các giá trị ban đầu        
//        startPos = target.spriteBody.position;
//        float angle = acosf((ccpLength(ccpSub(startPos, endPos))/2)/radius);
//        
//        switch (roundDirection) {
//            case Direction1:
//                center = ccpIntersectPoint(startPos, ccpRotateByAngle(endPos, startPos, angle), endPos, ccpRotateByAngle(startPos, endPos, -angle));
//                cycle =  (2*M_PI) / (2 * (M_PI_2 - angle)) * duration;
//                amplitudeX = radius;
//                amplitudeY = radius;
//                break;
//            case Direction2:
//                center = ccpIntersectPoint(startPos, ccpRotateByAngle(endPos, startPos, angle), endPos, ccpRotateByAngle(startPos, endPos, -angle));
//                cycle =  (2*M_PI) / (2*M_PI - 2 * (M_PI_2 - angle)) * duration;
//                amplitudeX = radius;
//                amplitudeY = radius;
//                break;
//            case Direction3:
//                center = ccpIntersectPoint(startPos, ccpRotateByAngle(endPos, startPos, -angle), endPos, ccpRotateByAngle(startPos, endPos, angle));
//                //iniPhase = M_PI + ccpAngle(ccpSub(center, startPos), ccp(1, 0));
//                amplitudeX = radius;
//                amplitudeY = radius;
//                break;
//            case Direction4:
//                center = ccpIntersectPoint(startPos, ccpRotateByAngle(endPos, startPos, -angle), endPos, ccpRotateByAngle(startPos, endPos, angle));
//                //iniPhase = M_PI + ccpAngle(ccpSub(center, startPos), ccp(1, 0));
//                amplitudeX = radius;
//                amplitudeY = radius;
//                break;
//            default:
//                break;
//        }
//        
//        CGPoint tempPoint = ccpSub(startPos, center);
//        if (tempPoint.y < 0) {
//            iniPhase = -ccpAngle(tempPoint, ccp(1, 0));
//        }
//        else {
//            iniPhase = ccpAngle(tempPoint, ccp(1, 0));
//        }
//
//        totalTime = 0;
//        firstTick = NO;
//    }
//    
//    iniPhase = 0;
//    cycle = 2;
//    
//    [super update:dt];
//    float x = amplitudeX * cos(2*M_PI/cycle * totalTime + iniPhase);
//    float y = amplitudeY * sin(-2*M_PI/cycle * totalTime + iniPhase);
//    totalTime += dt;
//    [target setPosition:ccpAdd(center, ccp(x, y))];
//}


@end
