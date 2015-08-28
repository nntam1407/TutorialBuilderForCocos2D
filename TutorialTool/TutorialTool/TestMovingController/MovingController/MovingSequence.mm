//
//  MovingSequence.m
//  LibGame
//
//  Created by User on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingSequence.h"

@implementation MovingSequence

+(id)movingControllers:(MovingController *)_movingController, ...{
    NSMutableArray * arrMovingController_ = [[NSMutableArray alloc] init];
    
    va_list params;
	va_start(params,_movingController);
	
    [arrMovingController_ addObject:_movingController];
    
	MovingController *now;
	while( _movingController ) {
		now = va_arg(params,MovingController*);
		if ( now )
			[arrMovingController_ addObject:now];
		else
			break;
	}
    
	va_end(params);
    
    return [[self alloc] initMovingSequenceWithArray:arrMovingController_];
}

+(id)movingControllersWithArray:(NSMutableArray *)_listMovingController {
    return [[self alloc] initMovingSequenceWithArray:_listMovingController];
}

-(id)initMovingSequenceWith:(MovingController*)_movingController, ...{
    NSMutableArray * arrMovingController_ = [[NSMutableArray alloc] init];
    
    va_list params;
	va_start(params,_movingController);
	
    [arrMovingController_ addObject:_movingController];
    
	MovingController *now;
	while( _movingController ) {
		now = va_arg(params,MovingController*);
		if ( now )
			[arrMovingController_ addObject:now];
		else
			break;
	}
    
	va_end(params);
    
    return [self initMovingSequenceWithArray:arrMovingController_];
}

-(id)initMovingSequenceWithArray:(NSMutableArray*)_arrMovingController{
    ccTime duration_ = 0;
    for (MovingController * controller in _arrMovingController) {
        duration_ += controller.duration;
    }
    
    self = [super initMovingControllerWith:duration_ andRotateTarget:NO];
    positive = 1;
    arrMovingController = _arrMovingController;
    
    currentController = 0;
    return self;
}


-(void)startMovingWithTarget:(MovingObject *)_target{
    [super startMovingWithTarget:_target];
    firstTick = YES;
    currentController = 0;
}

-(void)update:(ccTime)dt{
    
    if (firstTick) {
        if(dt>=0){
            currentController = 0;
            positive = 1;
        }else if(dt<0){
            positive = -1;
            currentController = (int)arrMovingController.count-1;
        }
        [[arrMovingController objectAtIndex:currentController] startMovingWithTarget:target];
        firstTick = NO;
        
        return;
    }
    if (![self isDone]) {
        [[arrMovingController objectAtIndex:currentController] update:dt];
        
        if(dt>0){
            if ([[arrMovingController objectAtIndex:currentController] isDone]) {
                if (arrMovingController.count > currentController + 1) {
                    currentController++;
                    [[arrMovingController objectAtIndex:currentController] startMovingWithTarget:target];
                }
            }
        }else if(dt<0){
            
            if ([[arrMovingController objectAtIndex:currentController] isDone]) {
                if (currentController - 1>=0) {
                    currentController--;
                    [[arrMovingController objectAtIndex:currentController] startMovingWithTarget:target];
                }
            }
        }
    }
}

-(BOOL)isDone{
    
    return (positive==1?arrMovingController.count == currentController+1 : currentController==0)&& [[arrMovingController objectAtIndex:currentController] isDone];
    
//    return arrMovingController.count == currentController+1 && [[arrMovingController objectAtIndex:currentController] isDone];
}

@end
