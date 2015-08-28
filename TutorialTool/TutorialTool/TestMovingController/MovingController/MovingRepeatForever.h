//
//  MovingRepeatForever.h
//  LibGame
//
//  Created by User on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingController.h"

@interface MovingRepeatForever : MovingController{
    MovingController * movingController;
    int positive;
    int count;
}

+(id)repeatWithMoveController:(MovingController*)_movingController;
-(id)initMovingRepeatForeverWith:(MovingController*)_movingController;
@end
