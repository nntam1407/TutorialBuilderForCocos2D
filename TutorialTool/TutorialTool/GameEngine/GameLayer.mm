//
//  GameLayer.m
//  Cocos2dBox2dGameStructure
//
//  Created by Truong NAM on 8/29/12.
//
//

#import "GameLayer.h"

@implementation GameLayer

@synthesize mainGameController, gameComponents, world;

-(id)initGameLayerWith:(iCoreGameController*)_mainGameController {
    self = [super init];
    mainGameController = _mainGameController;
    gameComponents = [[NSMutableArray alloc]init];
    return self;
}

-(void)createb2World {
    
}

-(void)loadGameComponents {
    
}

-(void)addGameObj:(GameObj*)_gameObj {
    [gameComponents addObject:_gameObj];
    [self addChild:_gameObj.spriteBody];
}

-(void)update:(ccTime)dt {
    int32 velocityIterations = 8;
    int32 positionIterations = 1;
    world->Step(dt, velocityIterations, positionIterations);
    for (GameObj *gameobj in gameComponents) {
        [gameobj update:dt];
    }
}

@end
