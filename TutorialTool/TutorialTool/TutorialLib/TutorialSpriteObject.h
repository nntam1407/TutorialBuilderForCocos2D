//
//  TutorialSpriteObject.h
//  LibGame
//
//  Created by User on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "TutorialLibDefine.h"
#import "TutorialObject.h"

@interface TutorialSpriteObject : TutorialObject {        
    
}

-(id)initTutorialSpriteObjectWith:(TutorialStoryboard *)_tutorialStorboardHandler withData:(NSMutableDictionary *)_objectData;
-(void)loadSprite;

@end
