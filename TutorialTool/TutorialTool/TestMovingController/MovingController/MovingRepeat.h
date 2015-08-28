//
//  MovingRepeat.h
//  LibGame
//
//  Created by User on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingController.h"

@interface MovingRepeat : MovingController{
    int times;
    int total;
    MovingController * movingController;
    int positive;
    
}

+(id)repeatWithMoveController:(MovingController*)_movingController withTimes:(int)_times;
-(id)initMovingRepeatWith:(MovingController*)_movingController withTimes:(int)_times;

@end
