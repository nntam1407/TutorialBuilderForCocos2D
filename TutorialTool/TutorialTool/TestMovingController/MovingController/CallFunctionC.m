//
//  CallFunctionC.m
//  LibGame
//
//  Created by User on 9/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CallFunctionC.h"

@implementation CallFunctionC

+(id) actionWithTarget: (id) t selector:(SEL) s
{
	return [[self alloc] initWithTarget: t selector: s];
}

-(id) initWithTarget: (id) t selector:(SEL) s
{
	if( (self=[super init]) ) {
		targetCallback = t;
		selector = s;
	}
	return self;
}

+(id) actionWithTarget:(id)t selector:(SEL)s data:(void *)d {
    return [[self alloc] initWithTarget:t selector:s data:d];
}

-(id) initWithTarget:(id)t selector:(SEL)s data:(void *)d {
    data_ = d;
    
    return [self initWithTarget:t selector:s];
}

-(void)update:(ccTime)dt{
    if (firstTick) {
        
        if(data_ == nil) {
            [targetCallback performSelector:selector];
        } else {
            [targetCallback performSelector:selector withObject:data_];
        }
        
        firstTick = NO;
    }
}

-(BOOL)isDone{
    return !firstTick;
}

@end
