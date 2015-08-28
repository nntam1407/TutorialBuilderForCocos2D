//
//  MovingInterpolationController.h
//  LibGame
//
//  Created by User on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MovingInterpolationController : NSObject{
    
    NSMutableArray *points;
}

-(id)initMovingInterpolationWith:(NSMutableArray*)_points;

-(NSMutableArray*)runMovingInterpolationWithEpsilion:(float)_smoothValue;

+(NSMutableArray *)pointCurveWith:(NSMutableArray*)_roughPoints andEpsilon:(float)_smoothValue;

@end
