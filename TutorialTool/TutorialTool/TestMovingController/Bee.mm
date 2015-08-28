//
//  Bee.m
//  HeroBird
//
//  Created by VienTran on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Bee.h"
#import "iCoreGameController.h"

@implementation Bee

-(id)initBeeWith:(GameLayer*)_handler{
    self = [super initMovingObjectWith:_handler];
    [self createSpriteBody];
    [self create2dBody];
    return self;
}

-(void)createSpriteBody{
    spriteBody = [CCSprite spriteWithSpriteFrameName:@"Bee_01.png"];
    
    CCAnimation * flyingAnimation = [[CCAnimation alloc] init];
    flyingAnimation.delayPerUnit = 0.1f;
    for (int i=1; i < 4; i++) {
        NSString *frameName = [NSString stringWithFormat:@"Bee_%02i.png",i];
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [flyingAnimation addSpriteFrame:frame];
    }
    [spriteBody runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:flyingAnimation]]];
}

-(void)create2dBody{
    b2BodyDef bodyDef;
    bodyDef.type = b2_kinematicBody;
	bodyDef.userData = self;
    b2PolygonShape * polygonShape = new b2PolygonShape();
    
    int num = 5;
    b2Vec2 verts[] = {
        b2Vec2(-13.6f / PTM_RATIO, 13.9f / PTM_RATIO),
        b2Vec2(-12.6f / PTM_RATIO, -2.3f / PTM_RATIO),
        b2Vec2(3.8f / PTM_RATIO, -13.6f / PTM_RATIO),
        b2Vec2(12.9f / PTM_RATIO, -13.9f / PTM_RATIO),
        b2Vec2(13.0f / PTM_RATIO, 3.4f / PTM_RATIO)
    };
    
    polygonShape->Set(verts, num);
    b2FixtureDef fixtureDef;
	fixtureDef.shape = polygonShape;
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
    fixtureDef.restitution = 0.3f;
    
    body2d = handler.world->CreateBody(&bodyDef);
	body2d->CreateFixture(&fixtureDef);
}

@end