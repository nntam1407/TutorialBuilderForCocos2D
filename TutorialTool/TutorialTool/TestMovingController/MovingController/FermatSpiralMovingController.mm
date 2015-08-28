//
//  FermatSpiralMovingController.m
//  LibGame
//
//  Created by User on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FermatSpiralMovingController.h"


@implementation FermatSpiralMovingController

+(id)runFermatSpiralMovingControllerWithDuration:(ccTime)_duration andDestination:(CGPoint)_endPoint andRotateTarget:(BOOL)_isRotate{
    
    return [[self alloc] initFermatSpiralMovingControllerWithDuration:_duration andDestination:_endPoint andRotateTarget:_isRotate];
}

-(id)initFermatSpiralMovingControllerWithDuration:(ccTime)_duration andDestination:(CGPoint)_endPoint andRotateTarget:(BOOL)_isRotate{
    
    self = [super initMovingControllerWith:_duration andRotateTarget:_isRotate];
    
    //Khoi tao cac thong so
    endPos = _endPoint;
    startPos = ccp(-1, -1);
    distanceInterval = 15.0;
    clockWise = YES;
    
    return self;
}

-(void)update:(ccTime)dt{
    
    [super update:dt];
    if(firstTick){
        
        //Tinh toa do diem bat dau
        if(startPos.x==-1&&startPos.y==-1){
            //Truong hop moi bat dau
            startPos = [target getPosition];
        }else {
            //Truong hop tiep tuc trong RepeatMoving
            if(dt>0){
                startPos = startPos;
                [target setPosition:startPos];
            }
        }
        distanceInterval = distance;
        CGPoint center = ccp((startPos.x + endPos.x)/2, (startPos.y + endPos.y)/2);
        cycle = duration/8;
        distance = ccpLength(ccpSub(startPos, endPos));
        
        CGPoint tempPoint = ccpSub(startPos, center);
        if (tempPoint.y < 0) {
            iniPhase = -ccpAngle(tempPoint, ccp(1, 0));
        }
        else {
            iniPhase = ccpAngle(tempPoint, ccp(1, 0));
        }
        
        omega = M_PI/cycle;
                
        firstTick = NO;
        return;
    }
    
    distanceInterval+=distance/duration*dt;
    
    
    float x;
    float y;
    if(clockWise){
        
        x = distanceInterval * cos(-2*omega * elapsed + iniPhase);
        y = distanceInterval * sin(-2*omega * elapsed + iniPhase);
        delta = ccp(x - distanceInterval * cos(-2*omega * (elapsed - dt) + iniPhase), y - distanceInterval * sin(-2*omega * (elapsed - dt) + iniPhase));
    }
    else {
        
        x = distanceInterval * cos(2*M_PI/cycle * elapsed + iniPhase);
        y = distanceInterval * sin(2*M_PI/cycle * elapsed + iniPhase);
        delta = ccp(x - distanceInterval * cos(2*M_PI/cycle * (elapsed - dt) + iniPhase), y - distanceInterval * sin(2*M_PI/cycle * (elapsed - dt) + iniPhase));
    }
    
    
//    [target setPosition:ccpAdd(ccp(target.body2d->GetPosition().x * PTM_RATIO, target.body2d->GetPosition().y * PTM_RATIO), delta)];
    
    [target setPosition:ccpAdd(ccp([target getPosition].x, [target getPosition].y), delta)];    
    
    [self makeTargetRotateWith:delta];
}


@end
