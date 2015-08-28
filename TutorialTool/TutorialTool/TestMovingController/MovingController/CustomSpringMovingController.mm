//
//  CustomSpringMovingController.m
//  LibGame
//
//  Created by User on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomSpringMovingController.h"

@implementation CustomSpringMovingController

+(id)runCustomSpringMovingControllerWithDuration:(ccTime)_duration andAmplitudeMax:(float)_amplitudeMax andAmplitudeMin:(float)_amplitudeMin andEndPosition:(CGPoint)_endPoint andNumberSpring:(int)_numberSpring andDistanceBetween:(float)_distanceInterval andIsPositive:(BOOL)_positive andIsInscrease:(BOOL)_isInscrease andRotateTarget:(BOOL)_isRotate{
    
    return [[self alloc] initCustomSpringMovingControllerWithDuration:_duration andAmplitudeMax:_amplitudeMax andAmplitudeMin:_amplitudeMin andEndPosition:_endPoint andNumberSpring:_numberSpring andDistanceBetween:_distanceInterval andIsPositive:_positive andIsInscrease:_isInscrease andRotateTarget:_isRotate];
}

-(id)initCustomSpringMovingControllerWithDuration:(ccTime)_duration andAmplitudeMax:(float)_amplitudeMax andAmplitudeMin:(float)_amplitudeMin andEndPosition:(CGPoint)_endPoint andNumberSpring:(int)_numberSpring andDistanceBetween:(float)_distanceInterval andIsPositive:(BOOL)_positive andIsInscrease:(BOOL)_isInscrease andRotateTarget:(BOOL)_isRotate{
    
    self = [super initMovingControllerWith:_duration andRotateTarget:_isRotate];
    
    maxAmplitude = _amplitudeMax;
    minAmplitude = _amplitudeMin;
    startPos = ccp(-1, -1);
    endPos = _endPoint;
    numberSpring = _numberSpring;
    distanceInterval = _distanceInterval;
    
    if(_positive){
        positive = -1;
        
    }else {
        positive = 1;
        
    }
    
    if(_isInscrease){
        inscrease = 1;
        intervalAmplitude = minAmplitude;
    }else {
        inscrease = -1;
        intervalAmplitude = maxAmplitude;
    }
    
    return self;
}

-(void)update:(ccTime)dt{
    
    if(firstTick){
        
        //Tinh toa do diem bat dau
        if(startPos.x==-1&&startPos.y==-1){
            //Truong hop moi bat dau
            startPos = [target getPosition];
        }else {
            //Truong hop tiep tuc trong RepeatMoving
            if(dt>0){
                [target setPosition:startPos];
            }else {
                [target setPosition:endPos];
            }
        }
        
        radius = (ccpLength(ccpSub(startPos, endPos))-distanceInterval*numberSpring) / numberSpring;
        center = ccp((startPos.x + endPos.x)/2, (startPos.y + endPos.y)/2);
        cycle = duration/numberSpring;
        
        CGPoint tempPoint = ccpSub(startPos, center);
        if (tempPoint.y < 0) {
            iniPhase = -ccpAngle(tempPoint, ccp(1, 0));
        }
        else {
            iniPhase = ccpAngle(tempPoint, ccp(1, 0));
        }
        
        
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
        
        //cap nhat firstTick
        firstTick = NO;
        
        return;
    }
    
    [super update:dt];
    
    //Cap nhat lai intervalAmplitude
    intervalAmplitude +=inscrease*(maxAmplitude-minAmplitude)/duration*dt;
    
    //Cap nhat vi tri lien tuc
    float x, y;
    
    //Kiem tra tung loai the hien cua xoan oc
    if(startPos.y==endPos.y){
        //Di chuyen theo x
        x = radius * cos(positive*2*M_PI/cycle * elapsed + iniPhase);
        y = intervalAmplitude * sin(positive*2*M_PI/cycle * elapsed + iniPhase);
        delta = ccp(x - radius * cos(positive*2*M_PI/cycle * (elapsed - dt) + iniPhase), y - intervalAmplitude * sin(positive*2*M_PI/cycle * (elapsed - dt) + iniPhase));
        
        delta.x+=(radius+distanceInterval)/(duration/numberSpring)*dt;
        
    }else if(startPos.x==endPos.x){
        //Di chuyen theo y
        x = intervalAmplitude * cos(positive*2*M_PI/cycle * elapsed + iniPhase);
        y = radius * sin(positive*2*M_PI/cycle * elapsed + iniPhase);
        delta = ccp(x - intervalAmplitude * cos(positive*2*M_PI/cycle * (elapsed - dt) + iniPhase), y - radius * sin(positive*2*M_PI/cycle * (elapsed - dt) + iniPhase));
        
        delta.y+=(radius+distanceInterval)/(duration/numberSpring)*dt;
        
    }else if(startPos.x!=endPos.x && startPos.y!=endPos.y){
        
        //Di chuyen theo ca x & y
        x = radius * cos(positive*2*M_PI/cycle * elapsed + iniPhase);
        y = intervalAmplitude * sin(positive*2*M_PI/cycle * elapsed + iniPhase);
        delta = ccp(x - radius * cos(positive*2*M_PI/cycle * (elapsed - dt) + iniPhase), y - intervalAmplitude * sin(positive*2*M_PI/cycle * (elapsed - dt) + iniPhase));
        
        delta.x+=(radius+distanceInterval)/(duration/numberSpring)*dt;
        
        //Tien hanh doi he truc toa do
        float newXPos = delta.x*cosAngle-delta.y*sinAngle;
        float newYPos = (delta.y+newXPos*sinAngle)/cosAngle;
        
        delta = ccp(newXPos, newYPos);
    }
    
//    [target setPosition:ccpAdd(ccp(target.body2d->GetPosition().x * PTM_RATIO, target.body2d->GetPosition().y * PTM_RATIO), delta)];
    
    [target setPosition:ccpAdd(ccp([target getPosition].x, [target getPosition].y), delta)];    
    
    [self makeTargetRotateWith:delta];
}

@end
