//
//  MovingRevert.h
//  LibGame
//
//  Created by User on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingRepeat.h"

@interface MovingRevert : MovingRepeat{
    
}

+(id)revertWithWith:(MovingController*)_movingController withTimes:(int)_times;

-(id)initMovingRevertWith:(MovingController*)_movingController withTimes:(int)_times;

@end
