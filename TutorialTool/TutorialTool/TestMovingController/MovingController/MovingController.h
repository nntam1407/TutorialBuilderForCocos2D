//
//  MovingController.h
//  LibGame
//
//  Created by User on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@class MovingObject;

@interface MovingController : NSObject{
    ccTime duration;
    ccTime elapsed;
    int tag;
    MovingObject * target;
    BOOL firstTick;
    BOOL isRotate;
}

-(id)initMovingControllerWith:(ccTime)_duration andRotateTarget:(BOOL)_isRotate;
-(void)update:(ccTime)dt;
-(BOOL)isDone;
-(void)startMovingWithTarget:(MovingObject*)_target;
-(void)stop;
-(void)makeTargetRotateWith:(CGPoint)_delta;

@property (nonatomic, assign) ccTime duration;
@property (nonatomic, retain) MovingObject * target;
@property (nonatomic, assign) int tag;

@end
