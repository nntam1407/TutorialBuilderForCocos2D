//
//  LinearMovingController.m
//  HeroBird
//
//  Created by VienTran on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LinearMovingController.h"
#import "MovingObject.h"

@implementation LinearMovingController

+(id)linearMovingWithDuration:(ccTime)_duration position:(CGPoint)_p andRotateTarget:(BOOL)_isRotate{
    return [[self alloc] initLinearMovingControllerWithDuration:_duration position:_p andRotateTarget:_isRotate];
}


-(id)initLinearMovingControllerWithDuration:(ccTime)_duration position:(CGPoint)_p andRotateTarget:(BOOL)_isRotate{
    self = [super initMovingControllerWith:_duration andRotateTarget:_isRotate];
    endPos = _p;
    startPos = ccp(-1, -1);
    return self;
}

-(void)update:(ccTime)dt{
    if (firstTick) {
        firstTick = NO;
        
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
        
//        startPos = target.spriteBody.position;
        delta = ccpSub(endPos, startPos);
        return;
    }
    
    [super update:dt];
    CGPoint de = ccp(delta.x / duration * dt, delta.y / duration * dt);
//    [target setPosition:ccpAdd(ccp(target.body2d->GetPosition().x * PTM_RATIO, target.body2d->GetPosition().y * PTM_RATIO), de)];
    
    [target setPosition:ccpAdd(ccp([target getPosition].x, [target getPosition].y), de)];
    
    [self makeTargetRotateWith:de];
}

@end
