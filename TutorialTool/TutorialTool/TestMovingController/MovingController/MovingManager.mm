//
//  MovingManager.m
//  LibGame
//
//  Created by User on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingManager.h"
#import "MovingController.h"

@implementation MovingManager

-(id)initMovingManager{
    self = [super init];
    movingController = [[NSMutableArray alloc] init];
//    epsilon = 
    return self;
}

-(void)update:(ccTime)dt{

    for (int i = 0; i < movingController.count ; i++) {
        MovingController *moving = [movingController objectAtIndex:i];
        [moving update:dt];
        if ([moving isDone]) {
            [movingController removeObject:moving];
            i--;
        }
    }
}

-(void)addMovingController:(MovingController *)_movingController{
    [movingController addObject:_movingController];
}

-(void)removeAllMovingController{
    [movingController removeAllObjects];
}

@end
