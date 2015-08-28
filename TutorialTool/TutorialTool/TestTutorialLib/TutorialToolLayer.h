//
//  TutorialToolLayer.h
//  TutorialTool
//
//  Created by k3 on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "TutorialSpriteLib.h"
#import "RulersLayer.h"

extern int editMouseMode;

@interface TutorialToolLayer : GameLayer <TutorialLibDelegate> {    
    TutorialSpriteLib *mainSpriteLib;
    
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
    CCSprite *selectedSprite;

    BOOL isDraggingObject;
    BOOL isRotatingObject;

    TutorialObject *selectedObject;
    
    CGPoint oldMousePosition;
    
    CCProgressTimer *timer;
    
    NSTrackingArea* trackingArea;
    
    BOOL isRunning;
    float totalTimeRunning;
    
    CCSprite *objectTargetOfCurrentActionSprite;
    CCSprite *spriteDestinationMouseHover;
}
@property (nonatomic,retain) TutorialObject *selectedObject;
-(id)initTTutorialToolLayerWith:(iCoreGameController *)_mainGameController;

-(void)drawStoryboardWithTutorialData:(NSMutableDictionary *)_data atIndex:(int)_index;

-(void)showObjectWithName:(NSString *)_objectName fromTutorialData:(NSMutableDictionary *)_data atIndex:(int)_index;

-(void)updateBackgound;

-(CGPoint)boundLayerPosWithNode:(CCNode *)_node inSize:(CGSize )_size;

-(void)updateDevice;
-(void)zoomEditorWithValue:(float)_zoomValue;

-(void) updateRulerView;

-(void)runStoryAtIndex:(int)_index withTutorialData:(NSMutableDictionary *)_data;

-(void)showDestinationSpriteWhenHover:(NSString *)_targetName desPoint:(CGPoint)_desPoint storyIndex:(int)_storyIndex;
-(void)hideDestinationSprite;

@end
