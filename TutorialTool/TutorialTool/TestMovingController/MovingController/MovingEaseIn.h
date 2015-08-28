//
//  MovingEaseIn.h
//  LibGame
//
//  Created by User on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingController.h"

@interface MovingEaseIn : MovingController{
    MovingController * movingController;
    float rate;
}

+(id)moveWithMoveController:(MovingController*)_movingController;
-(id)initMovingEaseInWith:(MovingController*)_movingController;

@end
