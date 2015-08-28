//
//  MovingRepeatForever.m
//  LibGame
//
//  Created by User on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingRepeatForever.h"

@implementation MovingRepeatForever

+(id)repeatWithMoveController:(MovingController*)_movingController{
    return [[self alloc] initMovingRepeatForeverWith:_movingController];
}
-(id)initMovingRepeatForeverWith:(MovingController*)_movingController{
    self = [super initMovingControllerWith:-1 andRotateTarget:NO];
    movingController = _movingController;
    positive = 1;
    count = 0;
    return self;
}

-(BOOL)isDone{
    return NO;
}

-(void)startMovingWithTarget:(MovingObject *)_target{
    [super startMovingWithTarget:_target];
    [movingController startMovingWithTarget:target];
}

-(void)update:(ccTime)dt{
    dt*=positive;
    [movingController update:dt];
    if ([movingController isDone]) {
        count++;
        [movingController startMovingWithTarget:target];
    }
}
@end
