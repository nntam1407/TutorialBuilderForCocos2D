//
//  iCoreGameController.m
//  Cocos2dBox2dGameStructure
//
//  Created by Truong NAM on 8/29/12.
//
//

#import "iCoreGameController.h"

@implementation iCoreGameController

@synthesize resoucesManager, winSize;

-(id)initCoreGameControllerWith:(CCDirector*)_director {
    self = [super init];
    director = _director;
    winSize =  [director winSize];
    return self;
}

-(void)startUp {
    NSLog(@"Game Start Up");
}

-(void)runWith:(GameLayer*)_gameLayer {    
    CCScene *tempScence = [CCScene node];
    [tempScence addChild:_gameLayer];
    [director runWithScene:tempScence];
}


@end
