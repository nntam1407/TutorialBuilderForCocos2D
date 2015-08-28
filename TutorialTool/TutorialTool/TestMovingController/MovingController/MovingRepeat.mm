//
//  MovingRepeat.m
//  LibGame
//
//  Created by User on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingRepeat.h"

@implementation MovingRepeat

+(id)repeatWithMoveController:(MovingController*)_movingController withTimes:(int)_times{
    return [[self alloc ]initMovingRepeatWith:_movingController withTimes:_times];
}

-(id)initMovingRepeatWith:(MovingController*)_movingController withTimes:(int)_times{
    self = [super initMovingControllerWith:_movingController.duration * _times andRotateTarget:NO];
    movingController = _movingController;
    times = _times;
    total = 0;
    positive = 1;
    return self;
}

-(BOOL)isDone
{
	return total == times;
}

-(void)startMovingWithTarget:(MovingObject *)_target{
    [super startMovingWithTarget:_target];
}

-(void)update:(ccTime)dt{
    
    if (firstTick) {
        [movingController startMovingWithTarget:target];
        firstTick = NO;
    }
    if (total < times) {
        dt*=positive;
        [movingController update:dt];
        if ([movingController isDone]) {
            total++;
            [movingController startMovingWithTarget:target];
        }
    }
}


@end
