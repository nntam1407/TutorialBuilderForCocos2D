//
//  WavySinMovingController.h
//  LibGame
//
//  Created by User on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingController.h"
#import "MovingObject.h"

@interface WavySinMovingController : MovingController{
    
    CGPoint startPos;
    CGPoint endPos;
    CGPoint endPosTemp;
    CGPoint delta;
    
    //Thong so can thiet 
    int numberLoop;//so buoc song
    float distance;//khoang cach den dich tinh tu vi tri hien tai
    float amplitude;//bien do cua buoc song
    float phase;//pha ban dau cua song
    double angle;//goc xeo
    double sinAngle;
    double cosAngle;
    
    double  epsilion;
    
}

+(id)wavySinMovingWithDuration:(ccTime)_duration andDestination:(CGPoint)_endPoint andAmplitude:(float)_amplitude andNumberLoop:(int)_numberLoop andPositive:(BOOL)_positive andRotateTarget:(BOOL)_isRotate;

-(id)initWavySinMovingControllerWithDuration:(ccTime)_duration andDestination:(CGPoint)_endPoint andAmplitude:(float)_amplitude andNumberLoop:(int)_numberLoop andPositive:(BOOL)_positive andRotateTarget:(BOOL)_isRotate;

@end
