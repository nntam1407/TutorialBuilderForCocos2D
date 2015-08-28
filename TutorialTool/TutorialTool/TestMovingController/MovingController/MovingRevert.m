//
//  MovingRevert.m
//  LibGame
//
//  Created by User on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingRevert.h"

@implementation MovingRevert

+(id)revertWithWith:(MovingController *)_movingController withTimes:(int)_times{
    return [[self alloc] initMovingRevertWith:_movingController withTimes:_times];
}

-(id)initMovingRevertWith:(MovingController *)_movingController withTimes:(int)_times{
    
    self = [super initMovingRepeatWith:_movingController withTimes:_times];
    
    positive = 1;
    
    return self;
}

-(void)update:(ccTime)dt{
    
    positive = pow(-1, total);
    [super update:dt];
}

@end
