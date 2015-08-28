//
//  TestMovingGameLayer.h
//  LibGame
//
//  Created by VienTran on 8/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "Bee.h"
#import "Ball.h"

#import "TutorialSpriteLib.h"

@interface TestMovingGameLayer : GameLayer <TutorialLibDelegate> {
    CCSpriteBatchNode * drawDebug;
    int currentExample;
    int numExample;
    TutorialSpriteLib *tutorial;
    CCLabelTTF * titleExample;
    Bee *bee1;
}

-(id)initTestMovingGameLayerWith:(iCoreGameController *)_mainGameController;

@end
