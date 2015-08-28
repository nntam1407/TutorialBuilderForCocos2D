//
//  MovingObject.m
//  LibGame
//
//  Created by VienTran on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingObject.h"
#import "MovingManager.h"
#import "MovingController.h"

@implementation MovingObject

-(id)initMovingObjectWith:(GameLayer*)_handler{
    self = [super initGameObj:_handler];
    movingManager = [[MovingManager alloc] initMovingManager];
    return self;
}

-(void)moveWith:(MovingController*)_movingController{
    [movingManager addMovingController:_movingController];
    [_movingController startMovingWithTarget:self];
}

-(void)stopAllMoving{
    [movingManager removeAllMovingController];
}

-(CGPoint)getPosition {
    if(body2d == nil){
        return spriteBody.position;
    }else {
        return CGPointMake(body2d->GetPosition().x * PTM_RATIO, body2d->GetPosition().y * PTM_RATIO);
    }
}

-(void)update:(ccTime)dt{
    [super update:dt];
    if (movingManager) {
        [movingManager update:dt];
    }
    
//    if (body2d->GetLinearVelocity().x > 0) {
//        spriteBody.flipX = YES;
//    } else {
//        spriteBody.flipX = NO;
//    }
}

@end
