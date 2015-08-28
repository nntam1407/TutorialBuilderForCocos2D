//
//  TestTutorialController.h
//  LibGame
//
//  Created by User on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iCoreGameController.h"

#import "MainWindow.h"
#import "TestTutorialResourceManager.h"
#import "TutorialToolLayer.h"

@class MainWindow;

@interface TestTutorialController : iCoreGameController {
    int currentStyle;
    MainWindow  *mainWindow;
    
    int currentDeviceType;
    int currentDeviceViewMode;
    float currentZoomValue;
    
    TutorialToolLayer *toolDesignLayer;
}

@property (nonatomic,retain) MainWindow  *mainWindow;
@property (nonatomic) int currentDeviceType;
@property (nonatomic) int currentDeviceViewMode;
@property (nonatomic) float currentZoomValue;

-(id)initTestTutorialControllerWith:(CCDirector *)_mainDirector;

-(void)runStyle;
-(void)runPreviousStyle;
-(void)runNextStyle;

-(void)runToolLayer;
-(void)runToolLayerAndDrawCurrentStory;

-(void)updateDesignViewWith:(NSMutableDictionary *)_tutorialData atStoryIndex:(int)_storyIndex;

-(void)showSelectedTutorialObjectWithName:(NSString *)_objectName fromData:(NSMutableDictionary *)_tutorialData atStoryIndex:(int)_storyIndex;

-(void)deselectedObject;

-(void)updateBackground;

-(void)runStoryboardWithTutorialData:(NSMutableDictionary *)_tutorialData atIndex:(int)_index;

-(void)stopStoryboardIsRuning;

-(void)updateDevideWithType:(int)_deviceType viewMode:(int)_deviceViewMode;
-(void)updateDevideViewMode:(int)_deviceViewMode;
-(void)updateDevideType:(int)_deviceType;
-(void)zoomEditorWithValue:(float)_zoomValue;

-(void)showDestinationSpriteWhenHover:(NSString *)_targetName desPoint:(CGPoint)_desPoint storyIndex:(int)_storyIndex;
-(void)hideDestinationSprite;

@end
