//
//  TestMovingGameController.m
//  LibGame
//
//  Created by VienTran on 8/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestMovingGameController.h"

@implementation TestMovingGameController

-(id)initTestMovingGameControllerWith:(CCDirector*)_director {
    self = [super initCoreGameControllerWith:_director];
    resoucesManager = [[TestMovingResourceManager alloc]initResourceManagerWith:self];
    [(TestMovingResourceManager*)resoucesManager loadAllResources];
    return self;
}

-(void)startUp {
    TestMovingGameLayer *testGameLayer = [[TestMovingGameLayer alloc]initTestMovingGameLayerWith:self];
    [self runWith:testGameLayer];
}

@end
