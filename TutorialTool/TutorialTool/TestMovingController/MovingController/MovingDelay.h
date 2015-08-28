//
//  MovingDelay.h
//  LibGame
//
//  Created by User on 9/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingController.h"

@interface MovingDelay : MovingController

+(id)delayWithDuration:(ccTime)_duration;
-(id)initMovingDelayWithDuration:(ccTime)_duration;

@end