//
//  MovingObject.h
//  LibGame
//
//  Created by VienTran on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObj.h"
@class MovingController;
@class MovingManager;

@interface MovingObject : GameObj{
    MovingManager * movingManager;
}

-(id)initMovingObjectWith:(GameLayer*)_handler;
-(void)moveWith:(MovingController*)_movingController;

-(CGPoint)getPosition;
-(void)stopAllMoving;

@end
