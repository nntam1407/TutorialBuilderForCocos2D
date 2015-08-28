//
//  GameLayer.h
//  Cocos2dBox2dGameStructure
//
//  Created by Truong NAM on 8/29/12.
//
//

#import "cocos2d.h"
#import "Box2D.h"
#import "GameObj.h"
#import "GLES-Render.h"
#import "Helpers.h"

@class iCoreGameController;

@interface GameLayer : CCLayer {
    iCoreGameController *mainGameController;
    NSMutableArray *gameComponents;
    b2World *world;
    GLESDebugDraw *m_debugDraw;
}

-(id)initGameLayerWith:(iCoreGameController*)_mainGameController;
-(void)createb2World;
-(void)addGameObj:(GameObj*)_gameObj;
-(void)update:(ccTime)dt;
-(void)loadGameComponents;


@property (nonatomic, retain) iCoreGameController *mainGameController;
@property (nonatomic, retain) NSMutableArray *gameComponents;
@property (nonatomic, readonly) b2World *world;

@end
