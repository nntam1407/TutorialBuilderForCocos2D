//
//  MovingDelay.m
//  LibGame
//
//  Created by User on 9/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingDelay.h"

@implementation MovingDelay

+(id)delayWithDuration:(ccTime)_duration{
    return [[self alloc] initMovingDelayWithDuration:_duration];
}


-(id)initMovingDelayWithDuration:(ccTime)_duration{
    self = [super initMovingControllerWith:_duration andRotateTarget:NO];
    return self;
}


@end
