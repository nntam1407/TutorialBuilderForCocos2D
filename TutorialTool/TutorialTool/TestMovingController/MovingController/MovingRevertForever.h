//
//  MovingRevertForever.h
//  LibGame
//
//  Created by User on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingRepeatForever.h"

@interface MovingRevertForever : MovingRepeatForever

+(id)revertWithMoveController:(MovingController*)_movingController;
-(id)initMovingRevertForeverWith:(MovingController*)_movingController;

@end
