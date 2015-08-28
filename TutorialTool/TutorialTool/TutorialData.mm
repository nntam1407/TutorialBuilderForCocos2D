//
//  TutorialData.m
//  TutorialTool
//
//  Created by k3 on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialData.h"

@implementation TutorialData


// add an object data into the last story in tutorial data

+(void)addObject:(NSDictionary*)_object intoLastStoryOfTutorialData:(NSMutableDictionary*)_tutorialData{
    
    [[[[_tutorialData objectForKey:@"Storyboard"] lastObject] objectForKey:@"Objects"] setObject:_object forKey:[_object valueForKey:@"Name"]];
    
}

// add an object data into the specific story in tutorial data

+(void)addObject:(NSDictionary*)_object intoStoryAtIndex:(int)_storyIndex ofTutorialData:(NSMutableDictionary*)_tutorialData{
    
    [[[[_tutorialData objectForKey:@"Storyboard"] objectAtIndex:_storyIndex] objectForKey:@"Objects"] setObject:_object forKey:[_object valueForKey:@"Name"]];
    
}

// add a list objects data into the last story in tutorial data

+(void)addObjects:(NSMutableDictionary*)_objects intoLastStoryOfTutorialData:(NSMutableDictionary*)_tutorialData{
    
    [[[_tutorialData objectForKey:@"Storyboard"] lastObject] setObject:_objects forKey:@"Objects"];
}

// add a list objects data into a specific story in tutorial data

+(void)addObjects:(NSMutableDictionary*)_objects intoStoryAtIndex:(int)_storyIndex ofTutorialData:(NSMutableDictionary*)_tutorialData{
    
    [[[_tutorialData objectForKey:@"Storyboard"] objectAtIndex:_storyIndex] setObject:_objects forKey:@"Objects"];
}

// add a resource data into tutorial data

+(void)addResources:(NSDictionary*)_resources intoTutorialData:(NSMutableDictionary*)_tutorialData{
    
    [_tutorialData setObject:_resources forKey:@"Resources"];
}

// add a list texture plist data into tutorial data

+(void)addListTexturePlist:(NSArray*)_listTexturePlist intoResourcesOfTutorialData:(NSMutableDictionary*)_tutorialData{
    
    [[_tutorialData objectForKey:@"Resources"] setObject:_listTexturePlist forKey:@"TexturePlist"];
}

// add a texture path into list texture plist data in tutorial data

+(void)addTexturePath:(NSString*)_texturePath intoTextureListOfTutorialData:(NSMutableDictionary*)_tutorialData{
    
    [[[_tutorialData objectForKey:@"Resources"] objectForKey:@"TexturePlist"] addObject:_texturePath];
}

// get list texture plist data in tutorial data

+(NSMutableArray *)getListTexturePlistFromTutorialData:(NSMutableDictionary*)_tutorialData {
    return [[_tutorialData objectForKey:@"Resources"] objectForKey:@"TexturePlist"];
}

// get a texture path in list texture plist data in tutorial data

+(NSString *)getTexturePlistFromTutorialData:(NSMutableDictionary*)_tutorialData atIndex:(int)_index {
    return [[[_tutorialData objectForKey:@"Resources"] objectForKey:@"TexturePlist"] objectAtIndex:_index];
}

// get a texture path in list texture plist data in tutorial data

+(void)removeTexturePlistatIndex:(int)_index fromTutorialData:(NSMutableDictionary*)_tutorialData {
    [[[_tutorialData objectForKey:@"Resources"] objectForKey:@"TexturePlist"] removeObjectAtIndex:_index];
}

// add a storyboard data into tutorial data

+(void)addStoryboard:(NSArray*)_storyboard intoTutorialData:(NSMutableDictionary*)_tutorialData{
    
    [_tutorialData setObject:_storyboard forKey:@"Storyboard"];
}

// remove storyboard data in tutorial data

+(void)removeStoryboardAtIndex:(int)_index intoTutorialData:(NSMutableDictionary*)_tutorialData {
    [[_tutorialData objectForKey:@"Storyboard"] removeObjectAtIndex:_index];
}

// get list story in tutorial data

+(NSMutableArray *)getListStoryboardFromData:(NSMutableDictionary *)_tutorialData {
    return [_tutorialData objectForKey:@"Storyboard"];
}

// add a story data into tutorial data

+(void)addStory:(NSDictionary*)_story intoStoryboardOfTutorialData:(NSMutableDictionary*)_tutorialData{
    
    [[_tutorialData objectForKey:@"Storyboard"] addObject:_story];
}


// add a list actions data into the last story in tutorial data

+(void)addActions:(NSMutableArray *)_actions intoLastStoryOfTutorialData:(NSMutableDictionary*)_tutorialData{
    
    [[[_tutorialData objectForKey:@"Storyboard"] lastObject] setObject:_actions forKey:@"Actions"];
}

// add a list actions data into a specific story in tutorial data

+(void)addActions:(NSMutableArray *)_actions intoStoryAtIndex:(int)_storyIndex ofTutorialData:(NSMutableDictionary*)_tutorialData{
    
    [[[_tutorialData objectForKey:@"Storyboard"] objectAtIndex:_storyIndex] setObject:_actions forKey:@"Actions"];
}

// add an action data into the last story in tutorial data

+(void)addAction:(NSDictionary*)_action intoLastStoryOfTutorialData:(NSMutableDictionary*)_tutorialData{
    
    [[[[_tutorialData objectForKey:@"Storyboard"] lastObject] objectForKey:@"Actions"] addObject:_action];
}

// add an action data into a specific story in tutorial data

+(void)addAction:(NSDictionary*)_action intoStoryAtIndex:(int)_storyIndex ofTutorialData:(NSMutableDictionary*)_tutorialData{
    
    [[[[_tutorialData objectForKey:@"Storyboard"] objectAtIndex:_storyIndex] objectForKey:@"Actions"] addObject:_action];
}

// add an action sequence data into the last story in tutorial data

+(void)addActionSequence:(NSArray*)_actionSequence intoLastActionInStoryOfTutorialData:(NSMutableDictionary*)_tutorialData{
    
    [[[[[_tutorialData objectForKey:@"Storyboard"] lastObject] objectForKey:@"Actions"] lastObject] setObject:_actionSequence forKey:@"ActionSequence"];
}


// add an action sequence data into a specific story in tutorial data

+(void)addActionSequence:(NSArray*)_actionSequence intoActionAtIndex:(int)_actionIndex ofStoryAtIndex:(int)_storyIndex ofTutorialData:(NSMutableDictionary*)_tutorialData{
    
    [[[[[_tutorialData objectForKey:@"Storyboard"] objectAtIndex:_storyIndex] objectForKey:@"Actions"] objectAtIndex:_actionIndex] setObject:_actionSequence forKey:@"ActionSequence"];
}

+(void)addAction:(NSMutableDictionary *)_action intoSequenceData:(NSMutableDictionary *)_sequenceData {
    [[_sequenceData objectForKey:@"ActionSequence"] addObject:_action];
}

// add an action into an action sequence data in the last story in tutorial data

+(void)addAction:(NSDictionary*)_action intoSequenceInLastActionOfTutorialData:(NSMutableDictionary*)_tutorialData{
    
    [[[[[[_tutorialData objectForKey:@"Storyboard"] lastObject] objectForKey:@"Actions"] lastObject] objectForKey:@"ActionSequence"] addObject:_action];
}

// add an action into an action sequence data in a specific story in tutorial data

+(void)addAction:(NSDictionary*)_action intoSequenceActionOfActionAtIndex:(int)_actionIndex ofStoryAtIndex:(int)_storyIndex ofTutorialData:(NSMutableDictionary*)_tutorialData{
    
    [[[[[[_tutorialData objectForKey:@"Storyboard"] objectAtIndex:_storyIndex] objectForKey:@"Actions"] objectAtIndex:_actionIndex] objectForKey:@"ActionSequence"] addObject:_action];
}


// get list actions data in a specific story in tutorial data

+(NSMutableArray *)getListActionsWithStoryIndex:(int)_storyIndex ofData:(NSMutableDictionary *)_tutorialData {
    
    int countListStory = (int)[[_tutorialData objectForKey:@"Storyboard"] count];
    
    if(_storyIndex < countListStory && _storyIndex >= 0) {    
        return [[[_tutorialData objectForKey:@"Storyboard"] objectAtIndex:_storyIndex] objectForKey:@"Actions"];
    } else {
        return nil;
    }
}

//get list index of actions with the same target
+(NSMutableArray *)getListIndexOfActionsWithStoryIndex:(int)_storyIndex ofData:(NSMutableDictionary *)_tutorialData withTargetName:(NSString *)_targetName{
    
    NSMutableArray *listActions = [self getListActionsWithStoryIndex:_storyIndex ofData:_tutorialData];
    NSMutableArray *actionsWithSameTarget = [NSMutableArray array];
    for (int i = 0; i < listActions.count; i++){
        NSMutableDictionary *action = [listActions objectAtIndex:i];
        NSString *targetName = [action objectForKey:TUTORIAL_ACTION_DATA_KEY_OBJECT_NAME];
        if ([targetName isEqualToString:_targetName]){
            [actionsWithSameTarget addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    return actionsWithSameTarget;
}

// get list actions data in an action sequence in a specific story in tutorial data

+(NSMutableArray *)getListActionInSequenceIndex:(int)_sequenceIndex atStoryIndex:(int)_storyIndex ofTutorialData:(NSMutableDictionary *)_tutorialData {
    
    int countListStory = (int)[[_tutorialData objectForKey:@"Storyboard"] count];
    
    if(_storyIndex < countListStory && _storyIndex >= 0 && _sequenceIndex >= 0) {    
        return [[[[[_tutorialData objectForKey:@"Storyboard"] objectAtIndex:_storyIndex] objectForKey:@"Actions"] objectAtIndex:_sequenceIndex] objectForKey:@"ActionSequence"];
    } else {
        return nil;
    }
}

+(NSMutableDictionary *)getActionDataFrom:(NSMutableDictionary *)_tutorialData withStoryIndex:(int)_storyIndex withActionIndex:(int)_actionIndex {
    
    return [[[[_tutorialData objectForKey:@"Storyboard"] objectAtIndex:_storyIndex] objectForKey:@"Actions"] objectAtIndex:_actionIndex];
    
}

+(NSMutableDictionary *)getActionDataAtIndex:(int)_actionIndex withActionSequenceIndex:(int)_actionSequenceIndex withStoryIndex:(int)_storyIndex fromTutorialData:(NSMutableDictionary *)_tutorialData {
    
    NSMutableDictionary *result = [[[[[[_tutorialData objectForKey:@"Storyboard"] objectAtIndex:_storyIndex] objectForKey:@"Actions"] objectAtIndex:_actionSequenceIndex] objectForKey:@"ActionSequence"] objectAtIndex:_actionIndex];
    
    return result;
    
}

+(BOOL)updateActionDataIn:(NSMutableDictionary *)_tutorialData byActionData:(NSMutableDictionary *)_newActionData atStoryIndex:(int)_storyIndex atActionIndex:(int)_actionIndex {
    
    [[[[_tutorialData objectForKey:@"Storyboard"] objectAtIndex:_storyIndex] objectForKey:@"Actions"] replaceObjectAtIndex:_actionIndex withObject:_newActionData];
    
    return true;
    
}

+(void)removeActionDataIn:(NSMutableDictionary *)_tutorialData atStoryIndex:(int)_storyIndex atActionIndex:(int)_actionIndex {
    
    [[[[_tutorialData objectForKey:@"Storyboard"] objectAtIndex:_storyIndex] objectForKey:@"Actions"] removeObjectAtIndex:_actionIndex];
    
}

+(void)updateActionData:(NSMutableDictionary *)_actionData atIndex:(int)_index inActionSequenceIndex:(int)_actionSequenceIndex ofStoryIndex:(int)_storyIndex inTutorialData:(NSMutableDictionary *)_tutorialData {
    
    [[[[[[_tutorialData objectForKey:@"Storyboard"] objectAtIndex:_storyIndex] objectForKey:@"Actions"] objectAtIndex:_actionSequenceIndex] objectForKey:@"ActionSequence"] replaceObjectAtIndex:_index withObject:_actionData];
    
}

+(void)removeActionDataAtIndex:(int)_index inActionSequenceIndex:(int)_actionSequenceIndex ofStoryIndex:(int)_storyIndex inTutorialData:(NSMutableDictionary *)_tutorialData {
    
    [[[[[[_tutorialData objectForKey:@"Storyboard"] objectAtIndex:_storyIndex] objectForKey:@"Actions"] objectAtIndex:_actionSequenceIndex] objectForKey:@"ActionSequence"] removeObjectAtIndex:_index];
    
}

+(void)swapActionDataBetweenIndexA:(int)_indexA andIndexB:(int)_indexB inSequenceIndex:(int)_sequenceIndex inStory:(int)_storyIndex inTutorialData:(NSMutableDictionary *)_tutorialData {
    
    NSMutableDictionary *actionDataA = [NSMutableDictionary dictionaryWithDictionary:[self getActionDataAtIndex:_indexA withActionSequenceIndex:_sequenceIndex withStoryIndex:_storyIndex fromTutorialData:_tutorialData]];
    
    NSMutableDictionary *actionDataB = [NSMutableDictionary dictionaryWithDictionary:[self getActionDataAtIndex:_indexB withActionSequenceIndex:_sequenceIndex withStoryIndex:_storyIndex fromTutorialData:_tutorialData]];
    
    [self updateActionData:actionDataA atIndex:_indexB inActionSequenceIndex:_sequenceIndex ofStoryIndex:_storyIndex inTutorialData:_tutorialData];
    
    [self updateActionData:actionDataB atIndex:_indexA inActionSequenceIndex:_sequenceIndex ofStoryIndex:_storyIndex inTutorialData:_tutorialData];
}

+(BOOL)updateObjectDataIn:(NSMutableDictionary *)_tutorialData byObjectData:(NSMutableDictionary *)_newObjectData atStoryIndex:(int)_storyIndex withObjectName:(NSString*)_objectName {
        
    [[[[_tutorialData objectForKey:@"Storyboard"] objectAtIndex:_storyIndex] objectForKey:@"Objects"] setValue:_newObjectData forKey:_objectName];
    
    return true;
    
}

+(NSMutableDictionary *)getListObjectsWithStoryIndex:(int)_storyIndex ofData:(NSMutableDictionary *)_tutorialData {
    
    int countListStory = (int)[[_tutorialData objectForKey:@"Storyboard"] count];
    
    if(_storyIndex < countListStory && _storyIndex >= 0) {    
          return [[[_tutorialData objectForKey:@"Storyboard"] objectAtIndex:_storyIndex] objectForKey:@"Objects"];
    } else {
        return nil;
    }
    
}

+(NSMutableDictionary *)getObjectDataFrom:(NSMutableDictionary *)_tutorialData withStoryIndex:(int)_storyIndex withObjectName:(NSString *)_objectName{
    
    return [[[[_tutorialData objectForKey:@"Storyboard"] objectAtIndex:_storyIndex] objectForKey:@"Objects"] objectForKey:_objectName];
}

+(void)removeObjectDataIn:(NSMutableDictionary *)_tutorialData atStoryIndex:(int)_storyIndex withObjectName:(NSString *)_objectName {
    
    [[[[_tutorialData objectForKey:@"Storyboard"] objectAtIndex:_storyIndex] objectForKey:@"Objects"] removeObjectForKey:_objectName];
}


+(void)addPointList:(NSMutableArray *)_pointList toOnPointMovingAction:(NSMutableDictionary *)_actionData {
    
    NSMutableArray *listOnPoint = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < _pointList.count; i++) {
        CGPoint point = [[_pointList objectAtIndex:i] pointValue];
        
        NSMutableDictionary *pointData = [[NSMutableDictionary alloc] init];
        [pointData setObject:[NSNumber numberWithFloat:point.x] forKey:@"PosX"];
        [pointData setObject:[NSNumber numberWithFloat:point.y] forKey:@"PosY"];
        
        [listOnPoint addObject:pointData];
    }
    
    [_actionData setObject:listOnPoint forKey:@"ListOnPoint"];
}

+(void)addListFrames:(NSMutableArray *)_listFrames toAnimationAction:(NSMutableDictionary *)_animationData {
    
    [_animationData setObject:_listFrames forKey:@"Frames"];
}

+(void)addFrame:(NSString *)_frame toAnimationAction:(NSMutableDictionary *)_animationData {
    [[_animationData objectForKey:@"Frames"] addObject:_frame];
}

+(void)removeFrameAtIndex:(int)_index fromAnimationAction:(NSMutableDictionary *)_animationData {
    [[_animationData objectForKey:@"Frames"] removeObjectAtIndex:_index];
}

+(NSMutableArray *)getListFramesFromAnimationData:(NSMutableDictionary *)_animationData {
    return [_animationData objectForKey:@"Frames"];
}

+(float) getTotalDurationTimeOfActionInData:(NSMutableDictionary *)_tutorialData atStoryIndex:(int)_storyIndex atActionInSequenceIndex:(int)_actionIndex{
    
    float totalDuration = 0;
    
    NSMutableArray *actionsInSequence = [self getListActionInSequenceIndex:_actionIndex atStoryIndex:_storyIndex ofTutorialData:_tutorialData];
    
    for (NSMutableDictionary *actionData in actionsInSequence){
        
        float duration = 0;
        NSString *actionType = [actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ACTION_TYPE];
        
        if (![actionType isEqualToString:TUTORIAL_ACTION_RUN_ANIMATION]){
            
            duration = [[actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
        } else {
            
            NSMutableArray *animationFrames = [self getListFramesFromAnimationData:actionData];
            
            float frameDelay = [[actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_FRAME_DELAY] floatValue];
            duration = frameDelay * animationFrames.count;
        }
        
        totalDuration += duration;
        
    }
    return totalDuration;
}

+(float) getTotalDurationTimeOfActionSequence:(NSMutableDictionary *)_actionData {
    float totalDuration = 0;
    
    NSMutableArray *actionsInSequence = [_actionData objectForKey:@"ActionSequence"];
    
    for (NSMutableDictionary *actionData in actionsInSequence){
        
        float duration = 0;
        NSString *actionType = [actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ACTION_TYPE];
        
        if (![actionType isEqualToString:TUTORIAL_ACTION_RUN_ANIMATION]){
            
            duration = [[actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
        } else {
            
            NSMutableArray *animationFrames = [self getListFramesFromAnimationData:actionData];
            
            float frameDelay = [[actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_FRAME_DELAY] floatValue];
            duration = frameDelay * animationFrames.count;
        }
        
        totalDuration += duration;
        
    }
    return totalDuration;
}

+(NSMutableDictionary *)copyActionSequenceData:(NSMutableDictionary *)_sequenceData {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    NSArray *allKeyName = [_sequenceData allKeys];
    
    for(NSString *keyName in allKeyName) {
        id value = [_sequenceData objectForKey:keyName];
        
        //if it is a sequence action item
        if([value isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray *listActionSequenceItem = [[NSMutableArray alloc] init];
            
            for(int i = 0; i < (int)[value count]; i++) {
                NSMutableDictionary *action = [[NSMutableDictionary alloc] initWithDictionary:[value objectAtIndex:i]];
                
                //Check it has list point or list frame
                NSMutableArray *listPoint = [[value objectAtIndex:i] objectForKey:TUTORIAL_ACTION_ON_POINT_MOVING_LIST_POINT];
                if(listPoint) {
                    [action setObject:[[NSMutableArray alloc] initWithArray:listPoint] forKey:TUTORIAL_ACTION_ON_POINT_MOVING_LIST_POINT];
                }
                
                NSMutableArray *listFrames = [[value objectAtIndex:i] objectForKey:TUTORIAL_ACTION_LIST_ANIMATION_FRAMES];
                if(listFrames) {                    
                    [action setObject:[[NSMutableArray alloc] initWithArray:listFrames] forKey:TUTORIAL_ACTION_LIST_ANIMATION_FRAMES];
                }
                
                [listActionSequenceItem addObject:action];
            }
            
            [result setObject:listActionSequenceItem forKey:keyName];
            
        } else {
            [result setObject:[_sequenceData objectForKey:keyName] forKey:keyName];
        }
    }
    
    return result;
}

+(NSMutableDictionary *)copyTutorialData:(NSMutableDictionary *)_tutorialData {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithDictionary:_tutorialData];
    
    /**
    * We have to copy each data type array or dictionary
    * If none: we will be lost data
    **/
    
    //Create new array to contain list story boad
    NSMutableArray *newListStoryArray = [[NSMutableArray alloc] init];
    
    //get old list story data in old data
    NSMutableArray *oldListStory = [_tutorialData objectForKey:TUTORIAL_STORYBOARD];
    for(int i = 0; i < oldListStory.count; i++) {
        
        //Create new dictionary story to contain new data copy from old data
        NSMutableDictionary *newStory = [[NSMutableDictionary alloc] init];
        
        //Get all object in list
        NSMutableDictionary *newListObjectInStory = [[NSMutableDictionary alloc] init];
        
        NSMutableDictionary *oldListObject = [[oldListStory objectAtIndex:i] objectForKey:TUTORIAL_STORYBOARD_OBJECTS_KEY];
        NSArray *allKeyValue = [oldListObject allKeys];
        for(NSString *keyName in allKeyValue) {
            [newListObjectInStory setObject:[[NSMutableDictionary alloc] initWithDictionary:[oldListObject objectForKey:keyName]] forKey:keyName];
        }
        
        //set to new story
        [newStory setObject:newListObjectInStory forKey:TUTORIAL_STORYBOARD_OBJECTS_KEY];
        
        //Get all action sequence in list
        //Create new array action sequence to contain new data copy from old data
        NSMutableArray *newListActionSequence = [[NSMutableArray alloc] init];
        
        NSMutableArray *oldListActionSequence = [[oldListStory objectAtIndex:i] objectForKey:TUTORIAL_STORYBOARD_ACTIONS_KEY];
        for(int sequenceIndex = 0; sequenceIndex < oldListActionSequence.count; sequenceIndex++) {
            NSMutableDictionary *singleActionSequence = [oldListActionSequence objectAtIndex:sequenceIndex];
            
            [newListActionSequence addObject:[self copyActionSequenceData:singleActionSequence]];
        }
        
        //Set to new story
        [newStory setObject:newListActionSequence forKey:TUTORIAL_STORYBOARD_ACTIONS_KEY];
        
        //add new story to new listStoryArray
        [newListStoryArray addObject:newStory];
    }
    
    [result setObject:newListStoryArray forKey:TUTORIAL_STORYBOARD];
    
    return result;
}

@end
