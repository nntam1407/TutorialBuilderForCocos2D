//
//  MovingController.m
//  LibGame
//
//  Created by User on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingController.h"
#import "MovingObject.h"

@implementation MovingController

@synthesize duration, target, tag;

-(id)initMovingControllerWith:(ccTime)_duration andRotateTarget:(BOOL)_isRotate{
    self = [super init];
    elapsed = 0;
    duration = _duration;
    firstTick = YES;
    isRotate = _isRotate;
    return self;
}

-(void)startMovingWithTarget:(MovingObject*)_target{
    target = _target;
    elapsed = 0;
    firstTick = YES;
}

-(void)stop{
    
}

-(void)update:(ccTime)dt{
    elapsed += dt;
}

-(BOOL)isDone{
    return duration == -1 ? NO : fabsf(elapsed) >= duration;
}

-(void)makeTargetRotateWith:(CGPoint)_delta{
    
    if(isRotate && (_delta.x!=0 || _delta.y!=0)){
        
        float32 length = ccpLength(_delta);
        float32 angle = M_PI/2-coshf(_delta.x/length);//goc toa do hop voi ox
        
        if(_delta.y<0){
            angle*=-1;
        }
        
        if(_delta.x<0){
            [target.spriteBody setFlipX:YES];
        }else {
            [target.spriteBody setFlipX:NO];
        }
        
        if(target.body2d!=nil){
            
            target.body2d->SetTransform(target.body2d->GetPosition(),angle);
            
        }else {
            [target.spriteBody setRotation:angle];
        }
        
    }
    
}

@end
