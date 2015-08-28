//
//  TutorialButtonObject.h
//  LibGame
//
//  Created by User on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialObject.h"

@interface TutorialButtonObject : TutorialObject {
    
}

-(id)initTutorialButtonObjectWith:(TutorialStoryboard *)_tutorialStorboardHandler withData:(NSMutableDictionary *)_objectData;
-(void)loadButtonSprite;
-(void)selfClicked;

@end
