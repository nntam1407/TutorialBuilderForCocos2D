//
//  TutorialSpriteLib.m
//  LibGame
//
//  Created by User on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//
//  TutorialSpriteLib.m
//  LibGame
//
//  Created by User on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialSpriteLib.h"
#import "TutorialStoryboard.h"
#import "MovingObject.h"
#import "TutorialXMLDataParse.h"

//config resource path for this tutorial
NSString *tutorialResourcePath = @"";

@implementation TutorialSpriteLib

@synthesize delegate;
@synthesize listStandardObjectsData;
@synthesize listStoryboard;
@synthesize currentStoryboardRunning;
@synthesize isTutorialRunning;

-(id)initTutorialSpriteLibWithDataFileName:(NSString *)_dataFileName withResourcePath:(NSString *)_resourcePath {
    self = [super init];
    
    tutorialResourcePath = _resourcePath;
    
    [self readDataFromDataFileName:_dataFileName];
    [self loadAllTextureResource];
    [self createListStoryboards];
    
    currentStoryboardRunning = 0;
    isTutorialRunning = NO;
    
    [self scheduleUpdate];
    
    return self;
}

-(id)initTutorialSpriteLibWithData:(NSMutableDictionary *)_data withResourcePath:(NSString *)_resourcePath {
    self = [super init];
    
    tutorialResourcePath = _resourcePath;
    
    mainDataDic = [[NSMutableDictionary alloc]initWithDictionary:_data];
    
    [self loadAllTextureResource];
    [self createListStoryboards];
    
    currentStoryboardRunning = 0;
    isTutorialRunning = NO;
    
    [self scheduleUpdate];
    
    return self;
}

-(void)update:(ccTime)_dt {
    TutorialStoryboard *storyboard = [listStoryboard objectAtIndex:currentStoryboardRunning];
    
    if(storyboard) {
        [storyboard update:_dt];
    }
}

-(BOOL)readDataFromDataFileName:(NSString *)_dataFileName {
    BOOL readResult = false;
    
    TutorialXMLDataParse *parse = [[TutorialXMLDataParse alloc] initTutorialXMLDataParse];
    mainDataDic = [parse getTutorialLibDataWithXmlFile:_dataFileName];
    [parse release];
    
    if(mainDataDic != nil) {        
        readResult = true;
    } else {
        readResult = false;
        NSLog(@"Load data from file: Data is null!");
    }
    
    return readResult;
}

-(void)createListStoryboards {
    /*
     Get all data of story board tag
     for each in it to get story data
     */
    
    listStoryboard = [[NSMutableArray alloc] init];
    
    NSMutableArray *listStoryData = [mainDataDic objectForKey:TUTORIAL_STORYBOARD];
    
    for(int i = 0; i < listStoryData.count; i++) {
        NSMutableDictionary *storyData = [listStoryData objectAtIndex:i];
        TutorialStoryboard *storyboard = [[TutorialStoryboard alloc] initTutorialStoryboardWith:self storyDictData:storyData];
        
        [listStoryboard addObject:storyboard];
        [storyboard release];
    }
}

-(void)loadAllTextureResource {
    NSMutableArray *listTextturePlistFileName = [[mainDataDic objectForKey:TUTORIAL_RESOURCES] objectForKey:TUTORIAL_RESOURCES_LIST_TEXTURE_PLIST];
    
    [TutorialResourceManager loadTextureFromArrayFile:listTextturePlistFileName];
}

-(void)removeAllTextureResource {
    NSMutableArray *listTextturePlistFileName = [[mainDataDic objectForKey:TUTORIAL_RESOURCES] objectForKey:TUTORIAL_RESOURCES_LIST_TEXTURE_PLIST];
    
    [TutorialResourceManager removeTextureFromArrayFile:listTextturePlistFileName];
}

-(void)drawGUIWithStoryboardIndex:(int)_index {
    if(_index < listStoryboard.count && _index >= 0) {
        currentStoryboardRunning = _index;
        
        // remove all child of previous story board running  
        [self removeAllChildrenWithCleanup:YES];
        
        /* 
         Cause we just init list storyboards object only one time,
         So after ran previous storyboard, all properties of all object in that story had changed.
         We have to set all object of that story come back first state before add them to Tutorial sprite
         */
        
        TutorialStoryboard *storyboard = [listStoryboard objectAtIndex:_index];
        [storyboard resetAllObjectBackToFirstState];
        
        //Get list object of this storyboard
        //then add spriteBody of each object in list object on tutorial
        NSArray *allObject = [[storyboard getListObjects] allValues];
        
        for(TutorialObject *tutorialObj in allObject) {  
            NSLog(@"z-index: %ld", tutorialObj.spriteBody.zOrder);
            [self addChild:tutorialObj.spriteBody z:tutorialObj.spriteBody.zOrder];
        }
    }
}

-(TutorialObject *)getObjectByName:(NSString *)_objName inStoryboardIndex:(int)_storyboardIndex {
    TutorialStoryboard *storyboard = [listStoryboard objectAtIndex:_storyboardIndex];
    
    if(storyboard) {
        return [storyboard getObjectByName:_objName];
    } else {
        return nil;
    }
}

-(void)runStoryboard {
    //if has storyboard run with delay before, we unschedule it
    [self unschedule:@selector(runStoryboard)];
    
    if(currentStoryboardRunning >= 0 && currentStoryboardRunning < listStoryboard.count) {
        [self stopTutorial];
        
        //First draw GUI of this storyboard
        [self drawGUIWithStoryboardIndex:currentStoryboardRunning];
        
        //Then run it
        TutorialStoryboard *storyboard = [listStoryboard objectAtIndex:currentStoryboardRunning];
        [storyboard runStoryboard];
        
        isTutorialRunning = YES;
    } else {
        isTutorialRunning = NO;
    }
}

-(void)runStoryboardAtIndex:(int)_index {
    //if has storyboard run with delay before, we unschedule it
    [self unschedule:@selector(runStoryboard)];
    
    currentStoryboardRunning = _index;  
    runStoryType = kRunStoryTypeNoRepeat;
    
    [self runStoryboard];
}

-(void)runStoryboardAtIndex:(int)_index delayTime:(float)_delay {
    [self unschedule:@selector(runStoryboard)];
    currentStoryboardRunning = _index;
    runStoryDelayTime = _delay;
    runStoryType = kRunStoryTypeNoRepeat;
    
    isTutorialRunning = YES;
    [self schedule:@selector(runStoryboard) interval:runStoryDelayTime];
}

-(void)runStoryboardAtIndex:(int)_index repeat:(int)_times {
    [self unschedule:@selector(runStoryboard)];
    [self runStoryboardAtIndex:_index];
    
    runStoryType = kRunStoryTypeRepeat;
    runStoryRepeatTimes = _times;
    runStoryRepeatCounter = 0;
}

-(void)runStoryboardAtIndex:(int)_index repeat:(int)_times delayTime:(float)_delay {
    [self unschedule:@selector(runStoryboard)];
    [self runStoryboardAtIndex:_index delayTime:_delay];
    
    runStoryType = kRunStoryTypeRepeatAndDelay;
    runStoryRepeatCounter = 0;
    runStoryRepeatTimes = _times;
}

-(void)runStoryboardForeverAtIndex:(int)_index {
    [self unschedule:@selector(runStoryboard)];
    [self runStoryboardAtIndex:_index];
    
    runStoryType = kRunStoryTypeForever;
}

-(void)runStoryboardForeverAtIndex:(int)_index delayTime:(float)_delay {
    [self unschedule:@selector(runStoryboard)];
    [self runStoryboardAtIndex:_index delayTime:_delay];
    
    runStoryType = kRunStoryTypeForeverAndDelay;
}

-(void)pauseStoryboard {
    [self pauseSchedulerAndActions];
}

-(void)resumeStoryboard {
    [self resumeSchedulerAndActions];
}

-(void)stopTutorial {
    
    if(currentStoryboardRunning < listStoryboard.count) {
        [((TutorialStoryboard *)[listStoryboard objectAtIndex:currentStoryboardRunning]) stopAllStoryActions];
    }
    
    isTutorialRunning = NO;
    
    [self unschedule:@selector(runStoryboard)];
    [self removeAllChildrenWithCleanup:YES];
}

-(int)getStoryboardsCount {
    return (int)listStoryboard.count;
}

-(void)objectButtonTypeClicked:(NSString *)_objectName {
    if([delegate respondsToSelector:@selector(tutorialButtonObjectClicked:)]) {
        [delegate tutorialButtonObjectClicked:_objectName];
    }
}

///////////////////////////////////////////////////////
// Implement tutorial storyboard delegate

-(void)tutorialStoryboardActiveObjectInGame:(NSString *)_objectName {
    if([delegate respondsToSelector:@selector(tutorialLibActiveObjectInGame:)]) {
        [delegate tutorialLibActiveObjectInGame:_objectName];
        //[delegate performSelector:NSSelectorFromString(_objectName)];
    }
}

-(void)tutorialObjectClicked:(TutorialObject *)_object {
    if([delegate respondsToSelector:@selector(tutorialLibObjectClicked:atStory:)]) {
        [delegate tutorialLibObjectClicked:_object atStory:currentStoryboardRunning];
    }
}

-(void)tutorialObjectMoving:(TutorialObject *)_object {
    if([delegate respondsToSelector:@selector(tutorialLibObjectMoving:atStory:)]) {
        [delegate tutorialLibObjectMoving:_object atStory:currentStoryboardRunning];
    }
}

-(void)tutorialObjectRotating:(TutorialObject *)_object{
    if([delegate respondsToSelector:@selector(tutorialLibObjectRotating:atStory:)]) {
        [delegate tutorialLibObjectRotating:_object atStory:currentStoryboardRunning];
    }
}

-(void)tutorialFinishedStoryboard:(id)_storyboard {
    isTutorialRunning = NO;
    
    switch (runStoryType) {
        case kRunStoryTypeNoRepeat: {
            if([delegate respondsToSelector:@selector(tutorialLibFinishedStoryboard:)]) {
                [delegate tutorialLibFinishedStoryboard:currentStoryboardRunning];
            }
            
            break;
        }
        case kRunStoryTypeRepeat: {
            runStoryRepeatCounter++;
            
            if(runStoryRepeatCounter < runStoryRepeatTimes) {
                runStoryRepeatTimes--;
                [self runStoryboardAtIndex:currentStoryboardRunning repeat:runStoryRepeatTimes];
            } else {
                if([delegate respondsToSelector:@selector(tutorialLibFinishedStoryboard:)]) {
                    [delegate tutorialLibFinishedStoryboard:currentStoryboardRunning];
                }
            }
            
            break;
        }
        case kRunStoryTypeForever: {
            [self runStoryboardForeverAtIndex:currentStoryboardRunning];
            break;
        }
        case kRunStoryTypeRepeatAndDelay: {
            runStoryRepeatCounter++;
            
            if(runStoryRepeatCounter < runStoryRepeatTimes) {
                runStoryRepeatTimes--;
                [self runStoryboardAtIndex:currentStoryboardRunning repeat:runStoryRepeatTimes delayTime:runStoryDelayTime];
            } else {
                if([delegate respondsToSelector:@selector(tutorialLibFinishedStoryboard:)]) {
                    [delegate tutorialLibFinishedStoryboard:currentStoryboardRunning];
                }
            }
            
            break;
        }
        case kRunStoryTypeForeverAndDelay: {
            [self runStoryboardForeverAtIndex:currentStoryboardRunning delayTime:runStoryDelayTime];
            break;
        }
    }
}

-(void)dealloc {    
    NSLog(@"Tutorial sprite lib dealloc");
    
    [self stopAllActions];
    
    delegate = nil;
    
    //[listStandardObjectsData removeAllObjects];
    //[listStandardObjectsData release];
    
    //[mainDataDic removeAllObjects];
    //[mainDataDic release];
    
    [self removeAllChildrenWithCleanup:YES];
    [self removeFromParentAndCleanup:YES];
    
    [listStoryboard removeAllObjects];
    [listStoryboard release];
    
    //[listTextturePlistFileName removeAllObjects];
    //[listTextturePlistFileName release];
    
    [super dealloc];
}

@end
