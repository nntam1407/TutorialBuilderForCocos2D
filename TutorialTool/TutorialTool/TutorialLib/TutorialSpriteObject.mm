//
//  TutorialSpriteObject.m
//  LibGame
//
//  Created by User on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialSpriteObject.h"
#import "TutorialSpriteLib.h"

@implementation TutorialSpriteObject

-(id)initTutorialSpriteObjectWith:(TutorialStoryboard *)_tutorialStorboardHandler withData:(NSMutableDictionary *)_objectData {
    self = [super initTutorialObjectWith:_tutorialStorboardHandler withData:_objectData];
    
    //[self loadSprite];
    [self applyObjectBodyProperties];
    
    return self;
}

-(void)loadSprite {
    if(spriteBody) {
        [spriteBody stopAllActions];
        [spriteBody removeAllChildrenWithCleanup:YES];
        [spriteBody release];
        spriteBody = nil;
    }
    
    NSString *spriteFileName = [objectData objectForKey:TUTORIAL_OBJECT_SPRITE_FILE_NAME];
    NSString *spriteFrameName = [objectData objectForKey:TUTORIAL_OBJECT_SPRITE_FRAME_NAME];
    
    int isUseFrame = [[objectData objectForKey:TUTORIAL_OBJECT_IS_USE_SPRITE_FRAME] intValue];
    
    //if sprite frame name = nil, we init sprite with spriteFileName and else
    
    if(isUseFrame == 1 && spriteFrameName != nil && ![spriteFrameName isEqualToString:@""]) {
        spriteBody = [[CCSprite alloc] initWithSpriteFrameName:spriteFrameName];
    } else {
        spriteBody = [[CCSprite alloc]initWithFile:[NSString stringWithFormat:@"%@%@", tutorialResourcePath, spriteFileName]];
    }
}

-(void)applyObjectBodyProperties {
    [self loadSprite];
    [super applyObjectBodyProperties];
    
    //get properties value from data for sprite type
    
    float scaleX = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_SCALE_X_KEY] floatValue];
    float scaleY = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_SCALE_Y_KEY] floatValue];
    
    float opacity = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_OPACITY] floatValue];
    
    float color_R = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_COLOR_R] floatValue];
    float color_G = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_COLOR_G] floatValue];
    float color_B = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_COLOR_B] floatValue];
    
    [spriteBody runAction:[CCScaleTo actionWithDuration:0 scaleX:scaleX scaleY:scaleY]];
    
    ((CCSprite *)spriteBody).opacity = opacity;
    ((CCSprite *)spriteBody).color = ccc3(color_R, color_G, color_B);
    
    float rotation = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_ROTATION_KEY] floatValue];
    spriteBody.rotation = rotation;
}

-(void)dealloc {
    NSLog(@"Tutorial sprite object dealloc");
    
    [super dealloc];
}


@end
