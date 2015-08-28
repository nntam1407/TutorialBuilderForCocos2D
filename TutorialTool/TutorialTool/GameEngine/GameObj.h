//
//  GameObj.h
//  Cocos2dBox2dGameStructure
//
//  Created by Truong NAM on 8/29/12.
//
//

#import "cocos2d.h"
#import "Box2D.h"
#import "Helpers.h"

@class GameLayer;

@interface GameObj : NSObject {
    b2Body *body2d;
    CCSprite *spriteBody;
    GameLayer *handler;
}

-(id)initGameObj:(GameLayer*)_handler;
-(void)create2dBody;
-(void)createSpriteBody;
-(void)update:(ccTime)dt;
-(void)setPosition:(CGPoint)p;

@property (nonatomic, retain) GameLayer *handler;
@property (nonatomic, readonly) b2Body *body2d;
@property (nonatomic, retain) CCSprite *spriteBody;



@end
