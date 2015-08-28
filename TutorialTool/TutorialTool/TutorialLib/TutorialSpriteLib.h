//
//  TutorialSpriteLib.h
//  LibGame
//
//  Created by User on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "CCSprite.h"
#import "TutorialLibDefine.h"
#import "TutorialSpriteObject.h"
#import "TutorialTextObject.h"
#import "TutorialButtonObject.h"
#import "TutorialParticleObject.h"
#import "TutorialAction.h"
#import "TutorialStoryboard.h"
#import "TutorialResourceManager.h"

@protocol TutorialLibDelegate <NSObject>

@optional

-(void)tutorialLibFinishedStoryboard:(int)_storyIndex;
-(void)tutorialButtonObjectClicked:(NSString *)_buttonName;
-(void)tutorialLibActiveObjectInGame:(NSString *)_objectName;
-(void)tutorialLibObjectClicked:(TutorialObject *)_object atStory:(int)_storyIndex;
-(void)tutorialLibObjectMoving:(TutorialObject *)_object atStory:(int)_storyIndex;
-(void)tutorialLibObjectRotating:(TutorialObject *)_object atStory:(int)_storyIndex;

@end

enum {
    kRunStoryTypeNoRepeat = 0,
    kRunStoryTypeRepeat,
    kRunStoryTypeForever,
    kRunStoryTypeRepeatAndDelay,
    kRunStoryTypeForeverAndDelay,
};

extern NSString *tutorialResourcePath;

@interface TutorialSpriteLib : CCLayer {
    id<TutorialLibDelegate> delegate;
    
    NSMutableDictionary *mainDataDic;
    NSMutableArray *listStoryboard;
    
    int currentStoryboardRunning;
    
    int runStoryType;
    int runStoryRepeatTimes;
    int runStoryRepeatCounter;
    float runStoryDelayTime;
    
    BOOL isTutorialRunning;
}

@property (nonatomic, assign) id<TutorialLibDelegate> delegate;
@property (nonatomic, retain) NSMutableDictionary *listStandardObjectsData;
@property (nonatomic, retain) NSMutableArray *listStoryboard;
@property (nonatomic) BOOL isTutorialRunning;
@property (nonatomic) int currentStoryboardRunning;

-(id)initTutorialSpriteLibWithDataFileName:(NSString *)_dataFileName withResourcePath:(NSString *)_resourcePath;

-(id)initTutorialSpriteLibWithData:(NSMutableDictionary *)_data withResourcePath:(NSString *)_resourcePath;

-(void)update:(ccTime)_dt;

-(BOOL)readDataFromDataFileName:(NSString *)_dataFileName;
-(void)createListStoryboards;
-(void)loadAllTextureResource;
-(void)removeAllTextureResource;

-(void)drawGUIWithStoryboardIndex:(int)_index;

-(void)runStoryboard;
-(void)runStoryboardAtIndex:(int)_index;
-(void)runStoryboardAtIndex:(int)_index delayTime:(float)_delay;
-(void)runStoryboardAtIndex:(int)_index repeat:(int)_times;
-(void)runStoryboardAtIndex:(int)_index repeat:(int)_times delayTime:(float)_delay;
-(void)runStoryboardForeverAtIndex:(int)_index;
-(void)runStoryboardForeverAtIndex:(int)_index delayTime:(float)_delay;

-(void)pauseStoryboard;
-(void)resumeStoryboard;
-(void)stopTutorial;

-(int)getStoryboardsCount;
-(TutorialObject *)getObjectByName:(NSString *)_objName inStoryboardIndex:(int)_storyboardIndex;

-(void)tutorialObjectClicked:(TutorialObject *)_object;
-(void)tutorialObjectMoving:(TutorialObject *)_object;
-(void)tutorialObjectRotating:(TutorialObject *)_object;

// This function will be called by button object
-(void)objectButtonTypeClicked:(NSString *)_objectName;

// Functions called by storyboard
-(void)tutorialStoryboardActiveObjectInGame:(NSString *)_objectName;
-(void)tutorialFinishedStoryboard:(id)_storyboard;
@end
