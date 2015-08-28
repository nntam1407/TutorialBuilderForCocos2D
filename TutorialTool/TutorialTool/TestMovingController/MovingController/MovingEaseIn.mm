//
//  MovingEaseIn.m
//  LibGame
//
//  Created by User on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingEaseIn.h"

@implementation MovingEaseIn

+(id)moveWithMoveController:(MovingController*)_movingController{
    return [[self alloc] initMovingEaseInWith:_movingController];
}

-(id)initMovingEaseInWith:(MovingController*)_movingController{
    self = [super initMovingControllerWith:_movingController.duration andRotateTarget:NO];
    movingController = _movingController;
    rate = 2;
    return self;
}

-(void)startMovingWithTarget:(MovingObject *)_target{
    [super startMovingWithTarget:_target];
    [movingController startMovingWithTarget:target];
}

-(void)update:(ccTime)dt{
    [super update:dt];
    float dt2 = dt * elapsed * 2 / duration;
    //float dt2 = (elapsed - duration/2) / (duration/2) * rate * dt;
    [movingController update:dt2];
}


@end
