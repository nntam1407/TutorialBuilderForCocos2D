//
//  MovingEaseOutIn.h
//  LibGame
//
//  Created by User on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingController.h"

@interface MovingEaseOutIn : MovingController{
    MovingController * movingController;
}

+(id)moveWithMoveController:(MovingController*)_movingController;
-(id)initMovingEaseOutInWith:(MovingController*)_movingController;

@end
