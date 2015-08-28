//
//  TutorialData.h
//  TutorialTool
//
//  Created by k3 on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TutorialObject.h"
#import "TutorialSpriteObject.h"
#import "TutorialButtonObject.h"
#import "TutorialParticleObject.h"
#import "TutorialTextObject.h"

@interface TutorialData : NSObject

#pragma mark -
#pragma mark Game Objects Functions
//functions used to add, get, update and remove objects data in tutorial data
+(void)addObject:(NSDictionary*)_object intoLastStoryOfTutorialData:(NSMutableDictionary*)_tutorialData;

+(void)addObject:(NSDictionary*)_object intoStoryAtIndex:(int)_storyIndex ofTutorialData:(NSMutableDictionary*)_tutorialData;

+(void)addObjects:(NSMutableDictionary*)_objects intoLastStoryOfTutorialData:(NSMutableDictionary*)_tutorialData;

+(void)addObjects:(NSMutableDictionary*)_objects intoStoryAtIndex:(int)_storyIndex ofTutorialData:(NSMutableDictionary*)_tutorialData;

+(BOOL)updateObjectDataIn:(NSMutableDictionary *)_tutorialData byObjectData:(NSMutableDictionary *)_newObjectData atStoryIndex:(int)_storyIndex withObjectName:(NSString*)_objectName;

+(NSMutableDictionary *)getListObjectsWithStoryIndex:(int)_storyIndex ofData:(NSMutableDictionary *)_tutorialData;

+(NSMutableDictionary *)getObjectDataFrom:(NSMutableDictionary *)_tutorialData withStoryIndex:(int)_storyIndex withObjectName:(NSString *)_objectName;

+(void)removeObjectDataIn:(NSMutableDictionary *)_tutorialData atStoryIndex:(int)_storyIndex withObjectName:(NSString *)_objectName;

#pragma mark -
#pragma mark Resource Data Functions
//functions used to add, get, update and remove resources data in tutorial data
+(void)addResources:(NSDictionary*)_resources intoTutorialData:(NSMutableDictionary*)_tutorialData;

+(void)addListTexturePlist:(NSArray*)_listTexturePlist intoResourcesOfTutorialData:(NSMutableDictionary*)_tutorialData;

+(void)addTexturePath:(NSString*)_texturePath intoTextureListOfTutorialData:(NSMutableDictionary*)_tutorialData;

+(NSMutableArray *)getListTexturePlistFromTutorialData:(NSMutableDictionary*)_tutorialData;

+(NSString *)getTexturePlistFromTutorialData:(NSMutableDictionary*)_tutorialData atIndex:(int)_index;

+(void)removeTexturePlistatIndex:(int)_index fromTutorialData:(NSMutableDictionary*)_tutorialData;


#pragma mark -
#pragma mark Story Data Functions
//functions used to add, get, update and remove storyboard data in tutorial data

+(void)addStoryboard:(NSArray*)_storyboard intoTutorialData:(NSMutableDictionary*)_tutorialData;

+(void)addStory:(NSDictionary*)_story intoStoryboardOfTutorialData:(NSMutableDictionary*)_tutorialData;

+(void)removeStoryboardAtIndex:(int)_index intoTutorialData:(NSMutableDictionary*)_tutorialData;

+(NSMutableArray *)getListStoryboardFromData:(NSMutableDictionary *)_tutorialData;

#pragma mark -
#pragma mark Action Data Functions
//functions used to add, get, update and remove actions data in tutorial data
+(void)addActions:(NSMutableArray *)_actions intoLastStoryOfTutorialData:(NSMutableDictionary*)_tutorialData;

+(void)addActions:(NSMutableArray *)_actions intoStoryAtIndex:(int)_storyIndex ofTutorialData:(NSMutableDictionary*)_tutorialData;

+(void)addAction:(NSDictionary*)_action intoLastStoryOfTutorialData:(NSMutableDictionary*)_tutorialData;

+(void)addAction:(NSDictionary*)_action intoStoryAtIndex:(int)_storyIndex ofTutorialData:(NSMutableDictionary*)_tutorialData;

+(void)addActionSequence:(NSArray*)_actionSequence intoLastActionInStoryOfTutorialData:(NSMutableDictionary*)_tutorialData;

+(void)addActionSequence:(NSArray*)_actionSequence intoActionAtIndex:(int)_actionIndex ofStoryAtIndex:(int)_storyIndex ofTutorialData:(NSMutableDictionary*)_tutorialData;

+(void)addAction:(NSMutableDictionary *)_action intoSequenceData:(NSMutableDictionary *)_sequenceData;

+(void)addAction:(NSDictionary*)_action intoSequenceInLastActionOfTutorialData:(NSMutableDictionary*)_tutorialData;

+(void)addAction:(NSDictionary*)_action intoSequenceActionOfActionAtIndex:(int)_actionIndex ofStoryAtIndex:(int)_storyIndex ofTutorialData:(NSMutableDictionary*)_tutorialData;

+(NSMutableArray *)getListActionsWithStoryIndex:(int)_storyIndex ofData:(NSMutableDictionary *)_tutorialData;

+(NSMutableArray *)getListIndexOfActionsWithStoryIndex:(int)_storyIndex ofData:(NSMutableDictionary *)_tutorialData withTargetName:(NSString *)_targetName;

+(NSMutableArray *)getListActionInSequenceIndex:(int)_sequenceIndex atStoryIndex:(int)_storyIndex ofTutorialData:(NSMutableDictionary *)_tutorialData;

+(NSMutableDictionary *)getActionDataFrom:(NSMutableDictionary *)_tutorialData withStoryIndex:(int)_storyIndex withActionIndex:(int)_actionIndex;

+(NSMutableDictionary *)getActionDataAtIndex:(int)_actionIndex withActionSequenceIndex:(int)_actionSequenceIndex withStoryIndex:(int)_storyIndex fromTutorialData:(NSMutableDictionary *)_tutorialData;

+(BOOL)updateActionDataIn:(NSMutableDictionary *)_tutorialData byActionData:(NSMutableDictionary *)_newActionData atStoryIndex:(int)_storyIndex atActionIndex:(int)_actionIndex;

+(void)removeActionDataIn:(NSMutableDictionary *)_tutorialData atStoryIndex:(int)_storyIndex atActionIndex:(int)_actionIndex;

+(void)updateActionData:(NSMutableDictionary *)_actionData atIndex:(int)_index inActionSequenceIndex:(int)_actionSequenceIndex ofStoryIndex:(int)_storyIndex inTutorialData:(NSMutableDictionary *)_tutorialData;

+(void)removeActionDataAtIndex:(int)_index inActionSequenceIndex:(int)_actionSequenceIndex ofStoryIndex:(int)_storyIndex inTutorialData:(NSMutableDictionary *)_tutorialData;

+(void)swapActionDataBetweenIndexA:(int)_indexA andIndexB:(int)_indexB inSequenceIndex:(int)_sequenceIndex inStory:(int)_storyIndex inTutorialData:(NSMutableDictionary *)_tutorialData;

#pragma mark -
#pragma mark Action Moving Data Functions
//functions used to add list points of action moving in tutorial data
+(void)addPointList:(NSMutableArray *)_pointList toOnPointMovingAction:(NSMutableDictionary *)_actionData;

#pragma mark -
#pragma mark Animation Data Functions
//functions used to add animation frames in tutorial data
+(void)addListFrames:(NSMutableArray *)_listFrames toAnimationAction:(NSMutableDictionary *)_animationData;

+(void)addFrame:(NSString *)_frame toAnimationAction:(NSMutableDictionary *)_animationData;

+(void)removeFrameAtIndex:(int)_index fromAnimationAction:(NSMutableDictionary *)_animationData;

+(NSMutableArray *)getListFramesFromAnimationData:(NSMutableDictionary *)_animationData;

#pragma mark -
#pragma mark Other Data Functions
//function used to get total duration time of an action in tutorial data
+(float) getTotalDurationTimeOfActionInData:(NSMutableDictionary *)_tutorialData atStoryIndex:(int)_storyIndex atActionInSequenceIndex:(int)_actionIndex;

+(float) getTotalDurationTimeOfActionSequence:(NSMutableDictionary *)_actionData;

+(NSMutableDictionary *)copyActionSequenceData:(NSMutableDictionary *)_sequenceData;

+(NSMutableDictionary *)copyTutorialData:(NSMutableDictionary *)_tutorialData;

@end
