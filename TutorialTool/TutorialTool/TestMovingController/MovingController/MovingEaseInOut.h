//
//  MovingEaseInOut.h
//  LibGame
//
//  Created by User on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingController.h"

@interface MovingEaseInOut : MovingController{
    MovingController * movingController;
}

+(id)moveWithMoveController:(MovingController*)_movingController;
-(id)initMovingEaseInOutWith:(MovingController*)_movingController;

@end