//
//  TutorialStoryboard.h
//  LibGame
//
//  Created by User on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TutorialLibDefine.h"
#import "TutorialAction.h"
#import "TutorialSequenceActionManager.h"

@class TutorialSpriteLib;

@interface TutorialStoryboard : NSObject {
    TutorialSpriteLib *tutorialSpriteLibHandler;
    
    NSMutableDictionary *storyboardData;
    NSMutableDictionary *listObjects;
    NSMutableArray *listActions;
    
    int actionFinishedCount;
    
    BOOL isChoosedObject;
}

@property (nonatomic, retain) TutorialSpriteLib *tutorialSpriteLibHandler;
@property (nonatomic) BOOL isChoosedObject;

-(id)initTutorialStoryboardWith:(TutorialSpriteLib *)_handler storyDictData:(NSMutableDictionary *)_dictData;
-(void)update:(ccTime)_dt;

-(BOOL)createListObjects;
-(BOOL)createListActions;

-(void)resetAllObjectBackToFirstState;
-(NSMutableDictionary *)getListObjects;
-(TutorialObject *)getObjectByName:(NSString *)_objectName;

-(void)stopAllStoryActions;
-(void)runStoryboard;

// This function will be called by button object
-(void)objectButtonTypeClicked:(NSString *)_objectName;

//functions will be called by action object
-(void)tutorialActionActiveObjectInGame:(NSString *)_objectName;
-(void)tutorialFinishedAction:(id)_action;

@end
