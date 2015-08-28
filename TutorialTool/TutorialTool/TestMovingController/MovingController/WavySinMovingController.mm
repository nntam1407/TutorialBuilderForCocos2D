//
//  WavySinMovingController.m
//  LibGame
//
//  Created by User on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WavySinMovingController.h"

@implementation WavySinMovingController

+(id)wavySinMovingWithDuration:(ccTime)_duration andDestination:(CGPoint)_endPoint andAmplitude:(float)_amplitude andNumberLoop:(int)_numberLoop andPositive:(BOOL)_positive andRotateTarget:(BOOL)_isRotate{
    
    return [[self alloc] initWavySinMovingControllerWithDuration:_duration andDestination:_endPoint andAmplitude:_amplitude andNumberLoop:_numberLoop andPositive:_positive andRotateTarget:_isRotate];
}

-(id)initWavySinMovingControllerWithDuration:(ccTime)_duration andDestination:(CGPoint)_endPoint andAmplitude:(float)_amplitude andNumberLoop:(int)_numberLoop andPositive:(BOOL)_positive andRotateTarget:(BOOL)_isRotate{
    
    self = [super initMovingControllerWith:_duration andRotateTarget:_isRotate];
    startPos = ccp(-1, -1);
    endPos = _endPoint;
    amplitude = _amplitude;
    numberLoop = _numberLoop;
    sinAngle = 0.0;
    cosAngle = 0.0;
    if(_positive){
        phase = M_PI/2;
    }else {
        phase = 3*M_PI/2;
    }

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
        
        //Tinh Detal
        delta = ccpSub(endPos, startPos);
        
        if(startPos.x!=endPos.x&&startPos.y!=endPos.y){
            //Tinh goc lech khi di chuyen
            distance = ccpDistance(startPos, endPos);
            if(startPos.x>endPos.x){
                distance*=-1;
            }
            endPosTemp = ccp(startPos.x+distance, startPos.y);
            delta = ccpSub(endPosTemp, startPos);
            
            float mirrorEdge = fabsf(startPos.y-endPos.y);
            sinAngle = mirrorEdge/distance;
            cosAngle = sqrt(1-pow(sinAngle, 2));
        } 
        
        return;
    }
    
    [super update:dt];
    
    //Kiem tra xu ly cho tung truong hop
    if (startPos.y==endPos.y) {
        //Truong hop cho X
        
        CGPoint newPosition = ccp(delta.x/duration*dt, amplitude*sin(2*M_PI/(duration/numberLoop)*elapsed+phase));
        
        CGPoint de = ccp(newPosition.x, newPosition.y-amplitude*sin(2*M_PI/(duration/numberLoop)*(elapsed-dt)+phase));
        
        [target setPosition:ccp([target getPosition].x + de.x,[target getPosition].y + de.y)];
        
        [self makeTargetRotateWith:de];
        
    }else if(startPos.x==endPos.x){
        //Truong hop cho Y
        
        CGPoint newPosition = ccp(amplitude*sin(2*M_PI/(duration/numberLoop)*elapsed+M_PI/2)+phase,delta.y/duration*dt);
        
        CGPoint de = ccp(newPosition.x-amplitude*sin(2*M_PI/(duration/numberLoop)*(elapsed-dt)+phase),newPosition.y);
        
        [target setPosition:ccp([target getPosition].x + de.x, [target getPosition].y + de.y)];
        
        [self makeTargetRotateWith:de];
        
    }else {
        //Truong hop ket hop X & Y
        CGPoint newPosition = ccp(delta.x/duration*dt, amplitude*sin(2*M_PI/(duration/numberLoop)*elapsed+phase));
        
        CGPoint de = ccp(newPosition.x, newPosition.y-amplitude*sin(2*M_PI/(duration/numberLoop)*(elapsed-dt)+phase));
        
        float newXPos = de.x*cosAngle-de.y*sinAngle;
        float newYPos = (de.y+newXPos*sinAngle)/cosAngle;
        
        CGPoint changeCoordinatePos = ccp(newXPos, newYPos);
        
        
        [target setPosition:ccp([target getPosition].x + changeCoordinatePos.x, [target getPosition].y + changeCoordinatePos.y)];
        
        [self makeTargetRotateWith:changeCoordinatePos];
    }

}


@end
