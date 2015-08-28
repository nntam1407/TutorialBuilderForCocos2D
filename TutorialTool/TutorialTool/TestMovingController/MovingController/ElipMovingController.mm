//
//  ElipMovingController.m
//  LibGame
//
//  Created by User on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ElipMovingController.h"

@implementation ElipMovingController

+(id)runElipMovingControllerWithDuration:(ccTime)_duration position:(CGPoint)_p andAmplitude:(float)_amplitude clockwise:(BOOL)_clockwise andRotateTarget:(BOOL)_isRotate{
    
    return [[self alloc] initElipMovingControllerWithDuration:_duration position:_p
                                                 andAmplitude:_amplitude clockwise:_clockwise andRotateTarget:_isRotate] ;
}

-(id)initElipMovingControllerWithDuration:(ccTime)_duration position:(CGPoint)_p andAmplitude:(float)_amplitude clockwise:(BOOL)_clockwise andRotateTarget:(BOOL)_isRotate{
    
    self = [super initMovingControllerWith:_duration andRotateTarget:_isRotate];
    
    amplitude = _amplitude;
    clockwise = _clockwise;
    endPos = _p;
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
                startPos = target.spriteBody.position;
            }
        }
        
        radius = ccpLength(ccpSub(startPos, endPos));
        center = ccp((startPos.x + endPos.x)/2, (startPos.y + endPos.y)/2);
        
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
        
        totalTime = duration;
        
        firstTick = NO;
    }
    
    [super update:dt];
    
    CGPoint de;
    float x;
    float y;
    if(clockwise){
        positive = -1;
    }
    else {
        positive = 1;
    }
    

    //Kiem tra tung loai the hien cua xoan oc
    if(startPos.y==endPos.y){
        
        x = radius * cos(positive*2*M_PI/duration * elapsed + iniPhase);
        y = amplitude * sin(positive*2*M_PI/duration * elapsed + iniPhase);
        de = ccp(x - radius * cos(positive*2*M_PI/duration * (elapsed - dt) + iniPhase), y - amplitude * sin(positive*2*M_PI/duration * (elapsed - dt) + iniPhase));
        
    }else if(startPos.x==endPos.x){
        
        x = amplitude * cos(positive*2*M_PI/totalTime * elapsed + iniPhase);
        y = radius * sin(positive*2*M_PI/totalTime * elapsed + iniPhase);
        de = ccp(x - amplitude * cos(positive*2*M_PI/totalTime * (elapsed - dt) + iniPhase), y - radius * sin(positive*2*M_PI/totalTime * (elapsed - dt) + iniPhase));
        
    }else {
        
        x = radius * cos(positive*2*M_PI/duration * elapsed + iniPhase);
        y = amplitude * sin(positive*2*M_PI/duration * elapsed + iniPhase);
        de = ccp(x - radius * cos(positive*2*M_PI/duration * (elapsed - dt) + iniPhase), y - amplitude * sin(positive*2*M_PI/duration * (elapsed - dt) + iniPhase));
        
        //Tien hanh doi he truc toa do
        float newXPos = de.x*cosAngle-de.y*sinAngle;
        float newYPos = (de.y+newXPos*sinAngle)/cosAngle;
        
        de = ccp(newXPos, newYPos);
        
    }
    
//    [target setPosition:ccpAdd(ccp(target.body2d->GetPosition().x*PTM_RATIO, target.body2d->GetPosition().y*PTM_RATIO), de)];
    
    [target setPosition:ccpAdd(ccp([target getPosition].x, [target getPosition].y), de)];
    [self makeTargetRotateWith:de];
}
@end
