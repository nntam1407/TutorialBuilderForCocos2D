//
//  MovingSequence.h
//  LibGame
//
//  Created by User on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingController.h"

@interface MovingSequence : MovingController{
    NSMutableArray * arrMovingController;
    int currentController;
    int positive;
}

+(id)movingControllers:(MovingController*)_movingController, ... NS_REQUIRES_NIL_TERMINATION;
+(id)movingControllersWithArray:(NSMutableArray *)_listMovingController;
-(id)initMovingSequenceWith:(MovingController*)_movingController, ... NS_REQUIRES_NIL_TERMINATION;
-(id)initMovingSequenceWithArray:(NSMutableArray*)_arrMovingController;

@end
