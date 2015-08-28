//
//  MovingManager.h
//  LibGame
//
//  Created by User on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@class MovingController;

@interface MovingManager : NSObject{
    NSMutableArray * movingController;
    float epsilon;
}

-(id)initMovingManager;
-(void)update:(ccTime)dt;
-(void)addMovingController:(MovingController*)_movingController;
-(void)removeAllMovingController;
@end
