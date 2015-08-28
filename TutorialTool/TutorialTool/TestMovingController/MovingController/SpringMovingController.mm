//
//  SpringMovingController.m
//  LibGame
//
//  Created by User on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpringMovingController.h"

@implementation SpringMovingController

+(id)springMovingControllerWithDuration:(ccTime)_duration andDestination:(CGPoint)_endPoint andAmplitude:(float)_amplitude andNumberLoop:(int)_numberLoop andPositive:(BOOL)_positive andDistance:(float)_distanceInterval andRotateTarget:(BOOL)_isRotate{
    
    return [[self alloc] initSpringMovingControllerWithDuration:_duration andDestination:_endPoint andAmplitude:_amplitude andNumberLoop:_numberLoop andPositive:_positive andDistance:_distanceInterval andRotateTarget:_isRotate];
}


-(id)initSpringMovingControllerWithDuration:(ccTime)_duration andDestination:(CGPoint)_endPos andAmplitude:(float)_amplitude andNumberLoop:(int)_numberLoop andPositive:(BOOL)_positive andDistance:(float)_distanceInterval andRotateTarget:(BOOL)_isRotate{
    
    self = [super initMovingControllerWith:_duration andRotateTarget:_isRotate];
    
    endPos = _endPos;
    clockwise = _positive;
    numberLoop = _numberLoop;
    amplitude = _amplitude;
    positive = 1.0;
    distanceInterval = _distanceInterval;
    startPos = ccp(-1, -1);
    
    return self;
}

-(void)update:(ccTime)dt{
    
    if(firstTick){
        
        firstTick = NO;
        
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
        radius = (ccpLength(ccpSub(startPos, endPos))-distanceInterval*numberLoop) / numberLoop;
        center = ccp((startPos.x + endPos.x)/2, (startPos.y + endPos.y)/2);
        cycle = duration/numberLoop;
        
        CGPoint tempPoint = ccpSub(startPos, center);
        if (tempPoint.y < 0) {
            iniPhase = -ccpAngle(tempPoint, ccp(1, 0));
        }
        else {
            iniPhase = ccpAngle(tempPoint, ccp(1, 0));
        }
        
        totalTime = 0;
        firstTick = NO;
        
        //Tien hanh doi truc toa do
        if(startPos.x!=endPos.x&&startPos.y!=endPos.y){
            //Tinh goc lech khi di chuyen
            distance = ccpDistance(startPos, endPos);
            if(startPos.x>endPos.x){
                distance*=-1;
            }
            endPosTemp = ccp(startPos.x+distance, startPos.y);
            
            float mirrorEdge = fabsf(startPos.y-endPos.y);
            sinAngle = mirrorEdge/distance;
            cosAngle = sqrt(1-pow(sinAngle, 2));
        } 
        
        
        return;
    }
    
    [super update:dt];
    
    
    CGPoint de;
    float x;
    float y;
    
    if(clockwise){
        positive = -1.0;
    }else {
        positive = 1.0;
    }
    
    
    //Kiem tra tung loai the hien cua xoan oc
    if(startPos.y==endPos.y){
        //Di chuyen theo x
        x = radius * cos(positive*2*M_PI/cycle * totalTime + iniPhase);
        y = amplitude * sin(positive*2*M_PI/cycle * totalTime + iniPhase);
        de = ccp(x - radius * cos(positive*2*M_PI/cycle * (totalTime - dt) + iniPhase), y - amplitude * sin(positive*2*M_PI/cycle * (totalTime - dt) + iniPhase));
        
        de.x+=(radius+distanceInterval)/(duration/numberLoop)*dt;
        
    }else if(startPos.x==endPos.x){
        //Di chuyen theo y
        x = amplitude * cos(positive*2*M_PI/cycle * totalTime + iniPhase);
        y = radius * sin(positive*2*M_PI/cycle * totalTime + iniPhase);
        de = ccp(x - amplitude * cos(positive*2*M_PI/cycle * (totalTime - dt) + iniPhase), y - radius * sin(positive*2*M_PI/cycle * (totalTime - dt) + iniPhase));
        
        de.y+=(radius+distanceInterval)/(duration/numberLoop)*dt;
        
    }else if(startPos.x!=endPos.x && startPos.y!=endPos.y){
        //Di chuyen theo ca x & y
        x = radius * cos(positive*2*M_PI/cycle * totalTime + iniPhase);
        y = amplitude * sin(positive*2*M_PI/cycle * totalTime + iniPhase);
        de = ccp(x - radius * cos(positive*2*M_PI/cycle * (totalTime - dt) + iniPhase), y - amplitude * sin(positive*2*M_PI/cycle * (totalTime - dt) + iniPhase));
        
        de.x+=(radius+distanceInterval)/(duration/numberLoop)*dt;
        
        //Tien hanh doi he truc toa do
        float newXPos = de.x*cosAngle-de.y*sinAngle;
        float newYPos = (de.y+newXPos*sinAngle)/cosAngle;
        
        de = ccp(newXPos, newYPos);
    }
    
    totalTime += dt;
    
    
//    [target setPosition:ccpAdd(ccp(target.body2d->GetPosition().x * PTM_RATIO, target.body2d->GetPosition().y * PTM_RATIO), de)];
    
    [target setPosition:ccpAdd(ccp([target getPosition].x, [target getPosition].y), de)]; 
    
    [self makeTargetRotateWith:de];
}

@end
