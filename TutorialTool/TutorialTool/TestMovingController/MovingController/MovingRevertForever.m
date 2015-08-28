//
//  MovingRevertForever.m
//  LibGame
//
//  Created by User on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingRevertForever.h"

@implementation MovingRevertForever

+(id)revertWithMoveController:(MovingController *)_movingController{
    return [[self alloc] initMovingRevertForeverWith:_movingController];
}

-(id)initMovingRevertForeverWith:(MovingController *)_movingController{
    
    self = [super initMovingRepeatForeverWith:_movingController];
    
    positive = 1;
    
    return self;
}

-(void)update:(ccTime)dt{
    positive = pow(-1,count);
    
    [super update:dt];
}

@end
