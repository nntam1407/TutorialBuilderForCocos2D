//
//  MovingEaseOut.m
//  LibGame
//
//  Created by User on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingEaseOut.h"

@implementation MovingEaseOut

+(id)moveWithMoveController:(MovingController*)_movingController{
    return [[self alloc] initMovingEaseOutWith:_movingController];
}

-(id)initMovingEaseOutWith:(MovingController*)_movingController{
    self = [super initMovingControllerWith:_movingController.duration andRotateTarget:NO];
    movingController = _movingController;
    return self;
}

-(void)startMovingWithTarget:(MovingObject *)_target{
    [super startMovingWithTarget:_target];
    [movingController startMovingWithTarget:target];
}

-(void)update:(ccTime)dt{
    [super update:dt];
    float dt2 = dt * (2 - elapsed * 2 / duration);
    [movingController update:dt2];
}

@end
