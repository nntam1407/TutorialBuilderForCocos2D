//
//  CallFunctionC.h
//  LibGame
//
//  Created by User on 9/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingController.h"

@interface CallFunctionC : MovingController{
    id targetCallback;
    SEL selector;
    
    void* data_;
}

+(id) actionWithTarget: (id) t selector:(SEL) s;
-(id) initWithTarget: (id) t selector:(SEL) s;

+(id) actionWithTarget: (id) t selector:(SEL) s data:(void *)d;
-(id) initWithTarget: (id) t selector:(SEL) s data:(void *)d;

@end
