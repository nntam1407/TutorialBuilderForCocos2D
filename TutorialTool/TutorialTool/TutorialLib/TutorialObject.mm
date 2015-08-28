//
//  TutorialObject.m
//  LibGame
//
//  Created by User on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialObject.h"
#import "MovingManager.h"
#import "TutorialStoryboard.h"
#import "TutorialSpriteLib.h"
#import "TestTutorialController.h"
#import "TutorialData.h"
#import "Helpers.h"

@implementation TutorialObject
@synthesize objectData;

-(id)initTutorialObjectWith:(TutorialStoryboard *)_tutorialStorboardHandler withData:(NSMutableDictionary *)_objectData {
    self = [super initMovingObjectWith:nil];
    
    tutorialStoryboardHandler = _tutorialStorboardHandler;
    objectData = _objectData;
    
    holding = NO;
    CCDirector *director = [CCDirector sharedDirector];
	[[director eventDispatcher] addMouseDelegate:self priority:spriteBody.zOrder];

    [self release];
    
    return self;
}



-(void)applyObjectBodyProperties { 
    float anchorPointX = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_ANCHOR_POINT_X] floatValue];
    float anchorPointY = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_ANCHOR_POINT_Y] floatValue];
    
    float posX = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_POS_X_KEY] floatValue];
    float posY = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_POS_Y_KEY] floatValue];
    
    BOOL isVisible = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_VISIBLE] boolValue];
    
    int z_index = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_Z_INDEX] intValue];
    
    spriteBody.anchorPoint = ccp(anchorPointX, anchorPointY);
    spriteBody.position = ccp(posX, posY);
    spriteBody.visible = isVisible;
    [spriteBody setZOrder:z_index];
    
    [self createRotateIcon];
    //[self createFrameBorder];
    
    CCDirector *director = [CCDirector sharedDirector];
    [[director eventDispatcher] addMouseDelegate:self priority:-z_index];
}

-(BOOL)ccMouseUp:(NSEvent *)event{
    tutorialStoryboardHandler.isChoosedObject = NO;
    
    if (holding){
        holding = NO;
    }
    
    if (isRotating){
        isRotating = NO;
    }
    return NO;
}

-(BOOL)ccMouseDown:(NSEvent *)event{
    
    if(!tutorialStoryboardHandler.isChoosedObject) {
        CGPoint touchPoint = [[CCDirector sharedDirector] convertEventToGL: event];
        
        //check object had added on tutorialSprite
        CCSprite *tutorialSprite = (CCSprite *)spriteBody.parent;
        
        if(tutorialSprite) {
            CCSprite *parentSprite = (CCSprite *)tutorialStoryboardHandler.tutorialSpriteLibHandler.parent;
            
            touchPoint =[parentSprite convertToNodeSpace:touchPoint];
            
            if ([self isPointInSpriteRectWithPoint:touchPoint]){
                tutorialStoryboardHandler.isChoosedObject = YES;
                
                holding = YES;
                oldMousePosition = touchPoint;
                
                [tutorialStoryboardHandler.tutorialSpriteLibHandler tutorialObjectClicked:self];
            }
            [self turnOnRotateModeIfTouchAtPoint:(touchPoint)];
        }
    }
    
    return NO;
}

-(BOOL)ccMouseDragged:(NSEvent *)event{
    if (editMouseMode == EDIT_MODE_MOVE_OBJECT){
        CGPoint touchPoint = [[CCDirector sharedDirector] convertEventToGL: event];
        
        CCSprite *parentSprite = (CCSprite *)tutorialStoryboardHandler.tutorialSpriteLibHandler.parent;
        
        touchPoint =[parentSprite convertToNodeSpace:touchPoint];
        
        //func used when user drags TutorialObject
        if (holding){
            
            spriteBody.position = ccp(spriteBody.position.x + (touchPoint.x - oldMousePosition.x), spriteBody.position.y + (touchPoint.y - oldMousePosition.y));
            //call a delegate to gamelayer
            [tutorialStoryboardHandler.tutorialSpriteLibHandler tutorialObjectMoving:self];
            
            oldMousePosition = touchPoint;
        }
        
        //func used when user rotates TutorialObject
        [self changeObjectRotationWithPointDrag:touchPoint];
    }
    
    
    return NO;
}

-(BOOL)isPointInSpriteRectWithPoint:(CGPoint)_point{
    return [Helpers isPoint:_point insideNode:spriteBody];
}

-(void)createFrameBorder {
    frameBorder = [CCSprite spriteWithFile:@"sel-frame.png"];
    frameBorder.anchorPoint = ccp(0, 0);
    
    frameBorder.scaleX = spriteBody.contentSize.width / frameBorder.contentSize.width;
    frameBorder.scaleY = spriteBody.contentSize.height / frameBorder.contentSize.height;
    
    [spriteBody addChild:frameBorder];
}

//create a rotateIcon at start
-(void)createRotateIcon{
    rotateIcon = [[CCSprite alloc]initWithFile:@"rotate_cw.png"];
    
    //rotateIcon.color = ccc3(0, 255, 0);
    
    //rotateIcon.scale = 0.5;
    
    [spriteBody addChild:rotateIcon z:0];
        
    rotateIcon.position = ccp(spriteBody.contentSize.width * spriteBody.anchorPoint.x, spriteBody.contentSize.height + 30);
    
    rotateIcon.visible = NO;
    
    rotateCenter = [[CCSprite alloc]initWithFile:@"move-background.png"];
    
    //rotateCenter.color = ccc3(0, 255, 255);
    
    //rotateCenter.scale = 0.5;
    
    [spriteBody addChild:rotateCenter z:1];
    
    rotateCenter.position = ccp(spriteBody.contentSize.width * spriteBody.anchorPoint.x, spriteBody.contentSize.height * spriteBody.anchorPoint.y);
    
    rotateCenter.visible = NO;

}

//show rotateIcon
-(void)showEffectWhenSelected {
    rotateIcon.visible = YES;
    rotateCenter.visible = YES;

}

//hide rotateIcon
-(void)hideEffectWhenDeselected {
    rotateIcon.visible = NO;
    rotateCenter.visible = NO;
    //rotateCenter.position = ccp(rotateCenter.position.x * spriteBody.anchorPoint.x, rotateCenter.position.y * spriteBody.anchorPoint.y);
}

//turn rotate mode on if the touch point is inside rotateIcon's rect
-(void)turnOnRotateModeIfTouchAtPoint:(CGPoint)_point{
    
    CCSprite *parentSprite = (CCSprite *)tutorialStoryboardHandler.tutorialSpriteLibHandler.parent;
    
    CGPoint newPoint = [parentSprite convertToWorldSpace:_point];
    
    newPoint = [spriteBody convertToNodeSpace:newPoint];
    
    if ([Helpers isPoint:newPoint inSpriteRect:rotateIcon] && rotateIcon.visible){
        
        isRotating = YES;
        
    }
}

-(void)changeObjectRotationWithPointDrag:(CGPoint)_point{
    if (isRotating){
        spriteBody.rotation = [Helpers findRadiansBetweenPoint:spriteBody.position andPoint:_point];
        
        [tutorialStoryboardHandler.tutorialSpriteLibHandler tutorialObjectRotating:self];
    }
}

-(void)dealloc {
    NSLog(@"Tutorial Object dealloc");
    
    [spriteBody stopAllActions];
    [spriteBody removeFromParentAndCleanup:YES];
    [spriteBody release];
    spriteBody = nil;
    
    CCDirector *director = [CCDirector sharedDirector];
	[[director eventDispatcher] removeMouseDelegate:self];
    
    //[spriteBody removeFromParentAndCleanup:YES];
    //[spriteBody release];
    
    //[super dealloc];
}

@end
