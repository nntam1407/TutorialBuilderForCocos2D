//
//  RunTutorialLayer.h
//  TutorialTool
//
//  Created by User on 10/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TutorialSpriteLib.h"
#import "GameLayer.h"
#import "RulersLayer.h"

@interface RunTutorialLayer : GameLayer <TutorialLibDelegate> {
    NSMutableDictionary *tutorialData;
    TutorialSpriteLib *mainTutorial;
    
    CGPoint oldMousePosition;
    
    CCSprite *bgLayer;
    CCLayer *borderLayer;
    CCLayerColor *borderBottom;
    CCLayerColor *borderTop;
    CCLayerColor *borderLeft;
    CCLayerColor *borderRight;
    CCSprite *borderDevice;
    CCLayerColor *stageBgLayer;
    CCLayer *contentLayer;
    
    RulersLayer *rulerLayer;
    
    CCSprite *background;
    
    NSTrackingArea* trackingArea;
}

-(id)initRunTutorialLayerWith:(iCoreGameController *)_mainGameController andTutorialData:(NSMutableDictionary *)_tutorialData;

-(void)runStoryAtIndex:(int)_index;

-(CGPoint)boundLayerPosWithNode:(CCNode *)_node inSize:(CGSize )_size;

-(void)updateDevice;
-(void)zoomEditorWithValue:(float)_zoomValue;

-(void) updateRulerView;

@end
