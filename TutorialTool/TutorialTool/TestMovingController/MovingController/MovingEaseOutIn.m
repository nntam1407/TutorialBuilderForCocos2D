//
//  MovingEaseOutIn.m
//  LibGame
//
//  Created by User on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingEaseOutIn.h"

@implementation MovingEaseOutIn

+(id)moveWithMoveController:(MovingController*)_movingController{
    return [[self alloc] initMovingEaseOutInWith:_movingController];
}

-(id)initMovingEaseOutInWith:(MovingController*)_movingController{
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
    float dt2;
    if (elapsed < duration / 2) {
        dt2 = dt * elapsed * 4 / duration;
    }else {
        dt2 = dt * (2 - (elapsed - duration / 2) * 4 / duration);
    }
    
//    if (elapsed * 2 < duration) {
//        dt2 = dt * elapsed * 4 / duration;
//    }else {
//        dt2 = dt * (4 - elapsed * 4/ duration);
//    }
    
    [movingController update:dt2];
}

@end
