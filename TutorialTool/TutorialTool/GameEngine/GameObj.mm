//
//  GameObj.m
//  Cocos2dBox2dGameStructure
//
//  Created by Truong NAM on 8/29/12.
//
//

#import "GameObj.h"
#import "GameLayer.h"

@implementation GameObj

@synthesize handler, body2d, spriteBody;

-(id)initGameObj:(GameLayer*)_handler {
    self = [super init];
    handler = _handler;
    return self;
}

-(void)create2dBody {
    
}

-(void)createSpriteBody {
    
}

-(void)update:(ccTime)dt {
    if(body2d) {
        spriteBody.position = ccp(body2d->GetPosition().x*PTM_RATIO, body2d->GetPosition().y*PTM_RATIO);
        spriteBody.rotation = -1 * CC_RADIANS_TO_DEGREES(body2d->GetAngle());
    }
}

-(void)setPosition:(CGPoint)p {
    if(body2d != nil) {
        // Box2d game
        body2d->SetTransform(b2Vec2(p.x/PTM_RATIO, p.y/PTM_RATIO), body2d->GetAngle());
    } else {
        //Cocos2d game
        spriteBody.position = p;
    }
}

@end
