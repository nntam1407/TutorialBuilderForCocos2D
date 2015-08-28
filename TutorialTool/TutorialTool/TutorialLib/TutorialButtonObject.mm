//
//  TutorialButtonObject.m
//  LibGame
//
//  Created by User on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialButtonObject.h"
#import "TutorialSpriteLib.h"

@implementation TutorialButtonObject 

-(id)initTutorialButtonObjectWith:(TutorialStoryboard *)_tutorialStorboardHandler withData:(NSMutableDictionary *)_objectData
{
    self = [super initTutorialObjectWith:_tutorialStorboardHandler withData:_objectData];
    
    [self loadButtonSprite];
    [self applyObjectBodyProperties];
    
    return self;
}

-(void)loadButtonSprite { 
    /*
     Cocos 1.0 support
     
     CCMenuItemImage *bodyButtonImage = [CCMenuItemImage itemFromNormalImage:spriteNormalFileName selectedImage:spriteActiveFileName target:self selector:@selector(selfClicked)];
     objectBody = [[CCMenu alloc] initWithItems:nil vaList:nil];
     [((CCMenu *)objectBody) addChild:bodyButtonImage];
     */
    
    if(spriteBody) {
        [spriteBody removeFromParentAndCleanup:YES];
        [spriteBody release];
        spriteBody = nil;
    }
    
    NSString *spriteNormalFileName = [objectData objectForKey:TUTORIAL_OBJECT_BUTTON_NORMAL_SPRITE_FILE_NAME];
    NSString *spriteActiveFileName = [objectData objectForKey:TUTORIAL_OBJECT_BUTTON_ACTIVE_SPRITE_FILE_NAME];
    
    NSString *spriteNormalFrameName = [objectData objectForKey:TUTORIAL_OBJECT_BUTTON_NORMAL_SPRITE_FRAME_NAME];
    NSString *spriteActiveFrameName = [objectData objectForKey:TUTORIAL_OBJECT_BUTTON_ACTIVE_SPRITE_FRAME_NAME];
    
    int isUseFrame = [[objectData objectForKey:TUTORIAL_OBJECT_IS_USE_SPRITE_FRAME] intValue];
    CCMenuItemImage *bodyButtonImage = nil;
    
    if(isUseFrame == 1 && spriteNormalFrameName != nil && ![spriteNormalFrameName isEqualToString:@""] && spriteActiveFrameName != nil && ![spriteActiveFrameName isEqualToString:@""]) {
        
        bodyButtonImage = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:spriteNormalFrameName] selectedSprite:[CCSprite spriteWithSpriteFrameName:spriteActiveFrameName] target:self selector:@selector(selfClicked)];
        
    } else {
        bodyButtonImage = [CCMenuItemImage itemWithNormalImage:[NSString stringWithFormat:@"%@%@", tutorialResourcePath, spriteNormalFileName] selectedImage:[NSString stringWithFormat:@"%@%@", tutorialResourcePath, spriteActiveFileName] target:self selector:@selector(selfClicked)];
    }
    
    spriteBody = (CCSprite *)[[CCMenu alloc] initWithArray:[NSArray arrayWithObject:bodyButtonImage]];
}

-(void)applyObjectBodyProperties {
    /*
     Cause we have problem with CCTouchDispatcher (touch delegate has been added, although we had used removeFromParentAndCleanup func) when we try adding this bodyObject (is CCMenu) on TutorialLib node one more time, in loadGUIWithStoryboardObjectsData function of TutorialSpriteLib class.
     So we try to alloc, init this CCMenu again before use it
     */
    
    [self loadButtonSprite];
    [super applyObjectBodyProperties];
    
    //get properties value from data for button type
    float scaleX = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_SCALE_X_KEY] floatValue];
    float scaleY = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_SCALE_Y_KEY] floatValue];
    float opacity = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_OPACITY] floatValue];
    float color_R = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_COLOR_R] floatValue];
    float color_G = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_COLOR_G] floatValue];
    float color_B = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_COLOR_B] floatValue];
    
    spriteBody.scaleX = scaleX;
    spriteBody.scaleY = scaleY;
    
    [((CCMenu *)spriteBody) setOpacity:opacity];
    [((CCMenu *)spriteBody) setColor:ccc3(color_R, color_G, color_B)];
    
    [((CCMenu *)spriteBody) setEnabled:NO];
    
    float rotation = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_ROTATION_KEY] floatValue];
    CCSprite *buttonItem = (CCSprite *)[[spriteBody children] objectAtIndex:0];
    buttonItem.rotation = rotation;

    
    /*
     After remove and cleanup, this menu lost target
     We have to reset target for this button
     Cause this CCMenu just contain only 1 CCMenuItemImage, so we get CCMenuItemImage at index 0
     */
    //[[[spriteBody children] objectAtIndex:0] setTarget:self selector:@selector(selfClicked)];
}

-(void)selfClicked {
    NSString *objectName = [objectData objectForKey:TUTORIAL_OBJECT_NAME_KEY];
    NSLog(@"tutorial button object name %@ clicked", objectName); 
    
    [tutorialStoryboardHandler objectButtonTypeClicked:objectName];
}


-(BOOL)ccMouseUp:(NSEvent *)event{
    [super ccMouseUp:event];
    
    [[[spriteBody children] objectAtIndex:0] unselected];
    
    return NO;
}

-(BOOL)ccMouseDown:(NSEvent *)event{
    [super ccMouseDown:event];
    
    CGPoint touchPoint = [[CCDirector sharedDirector] convertEventToGL: event];
    if ([self isPointInSpriteRectWithPoint:touchPoint]){
        [[[spriteBody children] objectAtIndex:0] selected];
    }
    
    return NO;
}

-(BOOL)isPointInSpriteRectWithPoint:(CGPoint)_point{
    CCSprite *buttonItem = (CCSprite *)[[spriteBody children] objectAtIndex:0];
    
    CCNode *tempNode = [CCNode node];
    tempNode.contentSize = buttonItem.contentSize;
    tempNode.position = spriteBody.position;
    tempNode.anchorPoint = ccp(0.5, 0.5);
    tempNode.rotation = spriteBody.rotation;
    tempNode.scale = spriteBody.scale;

    return [Helpers isPoint:_point insideNode:tempNode];
}


-(void)createRotateIcon{
    CCSprite *buttonItem = (CCSprite *)[[spriteBody children] objectAtIndex:0];
    
    rotateIcon = [[CCSprite alloc]initWithFile:@"rotate_cw.png"];
    
    //rotateIcon.color = ccc3(0, 255, 0);
    
    [buttonItem addChild:rotateIcon z:0];
    
    rotateIcon.position = ccp(buttonItem.contentSize.width/2, buttonItem.contentSize.height+30);
    
    rotateIcon.visible = NO;
    
    rotateCenter = [[CCSprite alloc]initWithFile:@"move-background.png"];
    
    rotateCenter.color = ccc3(0, 255, 255);
    
    [buttonItem addChild:rotateCenter z:1];
    
    rotateCenter.position = ccp(buttonItem.contentSize.width/2, buttonItem.contentSize.height/2);
    
    rotateCenter.visible = NO;
    
}

-(void)turnOnRotateModeIfTouchAtPoint:(CGPoint)_point{
    CCSprite *parentSprite = (CCSprite *)tutorialStoryboardHandler.tutorialSpriteLibHandler.parent;
    
    CGPoint newPoint = [parentSprite convertToWorldSpace:_point];
    
    CCSprite *buttonItem = (CCSprite *)[[spriteBody children] objectAtIndex:0];
    newPoint = [buttonItem convertToNodeSpace:newPoint];
    if ([Helpers isPoint:newPoint inSpriteRect:rotateIcon] && rotateIcon.visible){
        
        isRotating = YES;
        
    }
}

-(void)showRotateIconOnObject{
    CCSprite *buttonItem = (CCSprite *)[[spriteBody children] objectAtIndex:0];

    rotateIcon.visible = YES;
    rotateCenter.visible = YES;
    rotateCenter.position = [spriteBody convertToNodeSpace:buttonItem.position];
}

-(void)changeObjectRotationWithPointDrag:(CGPoint)_point{
    if (isRotating){
        CCSprite *buttonItem = (CCSprite *)[[spriteBody children] objectAtIndex:0];
        
        buttonItem.rotation = [Helpers findRadiansBetweenPoint:spriteBody.position andPoint:_point];
        
        [tutorialStoryboardHandler.tutorialSpriteLibHandler tutorialObjectRotating:self];
    }
}


@end
