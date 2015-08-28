//
//  TutorialStoryboard.m
//  LibGame
//
//  Created by User on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialStoryboard.h"
#import "TutorialSpriteLib.h"

@implementation TutorialStoryboard

@synthesize tutorialSpriteLibHandler, isChoosedObject;

-(id)initTutorialStoryboardWith:(TutorialSpriteLib *)_handler storyDictData:(NSMutableDictionary *)_dictData {
    self = [super init];
    
    tutorialSpriteLibHandler = _handler;
    storyboardData = _dictData;
    
    [self createListObjects];
    [self createListActions];
    
    return self;
}

-(void)update:(ccTime)_dt {
    NSArray *arrayObjects = [listObjects allValues];
    
    for(TutorialObject *obj in arrayObjects) {        
        [obj update:_dt];
    }
}

-(TutorialObject *)createObjectFromObjectData:(NSMutableDictionary *)_objData {    
    TutorialObject *tutorialObj = nil;
    
    NSString *objectType = [_objData objectForKey:TUTORIAL_OBJECT_TYPE_KEY];
    
    if([objectType isEqualToString:TUTORIAL_OBJECT_TYPE_SPRITE]) {
        tutorialObj = [[TutorialSpriteObject alloc] initTutorialSpriteObjectWith:self withData:_objData];
    } else if([objectType isEqualToString:TUTORIAL_OBJECT_TYPE_TEXT]) {
        tutorialObj = [[TutorialTextObject alloc] initTutorialTextObjectWith:self withData:_objData];
    } else if([objectType isEqualToString:TUTORIAL_OBJECT_TYPE_BUTTON]) {
        tutorialObj = [[TutorialButtonObject alloc] initTutorialButtonObjectWith:self withData:_objData];
    } else if([objectType isEqualToString:TUTORIAL_OBJECT_TYPE_PARTICLE]) {
        tutorialObj = [[TutorialParticleObject alloc] initTutorialParticleObjectWith:self withData:_objData];
    }
    
    return tutorialObj;
}

-(BOOL)createListObjects {
    BOOL result = false;
    
    if(storyboardData != nil) {
        result = true;
        
        listObjects = [[NSMutableDictionary alloc] init];
        
        NSMutableDictionary *listObjectData = [storyboardData objectForKey:TUTORIAL_STORYBOARD_OBJECTS_KEY];
        NSArray *allStoryboardObjectKeyNames = [listObjectData allKeys];
        
        for(NSString *objKeyName in allStoryboardObjectKeyNames) {
            NSMutableDictionary *storyboardObj = [listObjectData objectForKey:objKeyName];
            
            //create object from object data
            TutorialObject *obj = [self createObjectFromObjectData:storyboardObj];
            
            //add to list
            [listObjects setObject:obj forKey:objKeyName];
            [obj release];
        }
        
    } else {
        result = false;
        
        NSLog(@"Storyboard dictionary data null");
    }
    
    return result;
}

-(void)resetAllObjectBackToFirstState {
    NSArray *allObjectsName = [listObjects allKeys];
    
    for(NSString *objName in allObjectsName) {        
        [(TutorialObject *)[listObjects objectForKey:objName] applyObjectBodyProperties];
    }
}

-(NSMutableDictionary *)getListObjects {
    return listObjects;
}

-(TutorialObject *)getObjectByName:(NSString *)_objectName {
    return [listObjects objectForKey:_objectName];
}

-(BOOL)createListActions {
    BOOL result = false;
    
    if(storyboardData != nil) {
        result = true;
        
        /*
         Get all list action data
         for each in that list to get data for one action
         */
        
        listActions = [[NSMutableArray alloc]init];
        
        NSMutableArray *listActionData = [storyboardData objectForKey:TUTORIAL_STORYBOARD_ACTIONS_KEY];
        
        for(int i = 0; i < listActionData.count; i++) {
            //TutorialAction *action = [[TutorialAction alloc]initTutorialActionWith:self dictionaryData:[listActionData objectAtIndex:i]];
            
            TutorialSequenceActionManager *sequenceManager = [[TutorialSequenceActionManager alloc] initWithStoryboard:self andSequenceData:[listActionData objectAtIndex:i]];
            
            [listActions addObject:sequenceManager];
            [sequenceManager release];
        }
        
    } else {
        result = false;
        
        NSLog(@"Storyboard dictionary data null");
    }
    
    return result;
}

-(void)stopAllStoryActions {
    NSArray *allObjects = [listObjects allValues];
    
    for(TutorialObject *obj in allObjects) {
        [obj stopAllMoving];
        [obj.spriteBody stopAllActions];
    }
    
    for(int i = (int)listActions.count - 1; i >= 0; i--) {
        //[[listActions objectAtIndex:i] runAction];
        [[listActions objectAtIndex:i] stopSequence];
    }
}

-(void)runStoryboard {    
    actionFinishedCount = 0;
    
    if((int)listActions.count > 0) {
        for(int i = (int)listActions.count - 1; i >= 0; i--) {
            //[[listActions objectAtIndex:i] runAction];
            [[listActions objectAtIndex:i] runSequence];
        }
    } else {
        [tutorialSpriteLibHandler tutorialFinishedStoryboard:self];
    }
}

-(void)objectButtonTypeClicked:(NSString *)_objectName {
    [tutorialSpriteLibHandler objectButtonTypeClicked:_objectName];
}

//  ==================================
//
//  Functions will called by action
//
//  ==================================

-(void)tutorialActionActiveObjectInGame:(NSString *)_objectName {
    [tutorialSpriteLibHandler tutorialStoryboardActiveObjectInGame:_objectName];
}

-(void)tutorialFinishedAction:(id)_action {
    actionFinishedCount++;
    
    //if finished all action
    if(actionFinishedCount == listActions.count) {
        [tutorialSpriteLibHandler tutorialFinishedStoryboard:self];
    }
}

-(void)dealloc {
    NSLog(@"Storyboard dealloc");
    
    [listObjects removeAllObjects];
    [listObjects release];
    
    [listActions removeAllObjects];
    [listActions release];
    
    [super dealloc];
}

@end
