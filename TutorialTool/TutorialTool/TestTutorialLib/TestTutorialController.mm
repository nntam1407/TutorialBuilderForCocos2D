//
//  TestTutorialController.m
//  LibGame
//
//  Created by User on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestTutorialController.h"
#import "TutorialToolLayer.h"
#import <objc/runtime.h>

@implementation TestTutorialController

@synthesize mainWindow;

@synthesize currentDeviceType, currentDeviceViewMode, currentZoomValue;

-(id)initTestTutorialControllerWith:(CCDirector *)_mainDirector {
    self = [super initCoreGameControllerWith:_mainDirector];
    
    resoucesManager = [[TestTutorialResourceManager alloc] initResourceManagerWith:self];
    [((TestTutorialResourceManager *)resoucesManager) loadAllResources];
    
    currentStyle = 0;
    
    currentZoomValue = 1;
    
    currentDeviceType = mainWindow.currentDeviceChoosed;
    currentDeviceViewMode = mainWindow.currentDeviceViewMode;
    
    return self;
}

-(void)startUp {
    [self runToolLayer];
}

-(void)runToolLayer {    
    if(toolDesignLayer) {
        [toolDesignLayer removeFromParentAndCleanup:YES];
        [toolDesignLayer release];
        toolDesignLayer = nil;
    }
    
    toolDesignLayer = [[TutorialToolLayer alloc] initTTutorialToolLayerWith:self];
    [self runWith:toolDesignLayer];
}

-(void)runToolLayerAndDrawCurrentStory {        
    [toolDesignLayer drawStoryboardWithTutorialData:mainWindow.tutorial atIndex:mainWindow.currentIndexOfStorySelected];
}

-(void)updateDesignViewWith:(NSMutableDictionary *)_tutorialData atStoryIndex:(int)_storyIndex {
    if(toolDesignLayer) {
        [toolDesignLayer drawStoryboardWithTutorialData:_tutorialData atIndex:_storyIndex];
    }
}

-(void)showSelectedTutorialObjectWithName:(NSString *)_objectName fromData:(NSMutableDictionary *)_tutorialData atStoryIndex:(int)_storyIndex{
    if(toolDesignLayer) {
        [toolDesignLayer showObjectWithName:_objectName fromTutorialData:_tutorialData atIndex:_storyIndex];
    }
}

-(void)deselectedObject{
    if(toolDesignLayer) {
        toolDesignLayer.selectedObject = nil;
    }
}

-(void)updateBackground {
    if(toolDesignLayer) {
        [toolDesignLayer updateBackgound];
    }
}

-(void)runStoryboardWithTutorialData:(NSMutableDictionary *)_tutorialData atIndex:(int)_index {
    if(toolDesignLayer) {
        [toolDesignLayer runStoryAtIndex:_index withTutorialData:_tutorialData];
    } else {
        [self runToolLayerAndDrawCurrentStory];
    }
}

-(void)stopStoryboardIsRuning {
    [self runToolLayerAndDrawCurrentStory];
}

-(void)updateDevideWithType:(int)_deviceType viewMode:(int)_deviceViewMode {
    currentDeviceType = _deviceType;
    currentDeviceViewMode = _deviceViewMode;
    
    if(toolDesignLayer) {
        [toolDesignLayer updateDevice];
    }
}

-(void)updateDevideViewMode:(int)_deviceViewMode {
    [self updateDevideWithType:currentDeviceType viewMode:_deviceViewMode];
}

-(void)updateDevideType:(int)_deviceType {
    [self updateDevideWithType:_deviceType viewMode:currentDeviceViewMode];
}

-(void)zoomEditorWithValue:(float)_zoomValue {
    currentZoomValue = _zoomValue;
    
    if(toolDesignLayer) {
        [toolDesignLayer zoomEditorWithValue:_zoomValue];
    }
}

-(void)showDestinationSpriteWhenHover:(NSString *)_targetName desPoint:(CGPoint)_desPoint storyIndex:(int)_storyIndex {
    if(toolDesignLayer) {
        [toolDesignLayer showDestinationSpriteWhenHover:_targetName desPoint:_desPoint storyIndex:_storyIndex];
    }
}

-(void)hideDestinationSprite {
    if(toolDesignLayer) {
        [toolDesignLayer hideDestinationSprite];
    }
}

@end
