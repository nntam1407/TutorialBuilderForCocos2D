//
//  ActionSequencePropertiesViewController.h
//  TutorialTool
//
//  Created by User on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@class GameLayer;

@interface RulersLayer : CCLayer {    
    CCSprite* bgHorizontal;
    CCSprite* bgVertical;
    
    CCNode* marksVertical;
    CCNode* marksHorizontal;
    
    CCSprite* mouseMarkHorizontal;
    CCSprite* mouseMarkVertical;
    
    CGSize winSize;
    CGPoint stageOrigin;
    float zoom;
    
    CCLabelAtlas* lblX;
    CCLabelAtlas* lblY;
}

- (void) updateWithSize:(CGSize)winSize stageOrigin:(CGPoint)stageOrigin zoom:(float)zoom;

- (void)mouseEntered:(NSEvent *)event;

- (void)mouseExited:(NSEvent *)event;

- (void)updateMousePos:(CGPoint)pos withOriginPointInBackgroundSpace:(CGPoint)posInBgSpace;

@end
