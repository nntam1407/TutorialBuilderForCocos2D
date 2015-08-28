//
//  MovingEaseOut.h
//  LibGame
//
//  Created by User on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingController.h"

@interface MovingEaseOut : MovingController{
    MovingController * movingController;
}

+(id)moveWithMoveController:(MovingController*)_movingController;
-(id)initMovingEaseOutWith:(MovingController*)_movingController;

@end
