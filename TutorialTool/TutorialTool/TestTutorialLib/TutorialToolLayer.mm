//
//  TutorialToolLayer.m
//  TutorialTool
//
//  Created by k3 on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialToolLayer.h"
#import "TestTutorialController.h"
#import "TutorialData.h"
#import "TutorialToolDefine.h"
#import "MainWindow.h"

@implementation TutorialToolLayer
@synthesize selectedObject;

-(id)initTTutorialToolLayerWith:(iCoreGameController *)_mainGameController{
    self = [super initGameLayerWith:_mainGameController];
    
    self.isMouseEnabled = YES;
    self.isTouchEnabled = YES;
    
    [self createb2World];
    [self loadGameComponents];
    
    [self updateDevice];
    [self zoomEditorWithValue:((TestTutorialController *)mainGameController).currentZoomValue];
    
    isRunning = false;
    
    totalTimeRunning = 0;
    
    [self scheduleUpdate];
    return self;
}

-(void)update:(ccTime)dt {
    if(isRunning) {
        totalTimeRunning += dt;
        
        [((TestTutorialController *)mainGameController).mainWindow updateTimeRunning:totalTimeRunning];
    };
}

-(void)createb2World {
    CGSize s = CGSizeMake(480, 320);
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
	world->SetAllowSleeping(true);
	world->SetContinuousPhysics(true);
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	b2EdgeShape groundBox;
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	groundBox.Set(b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
}

-(void)loadGameComponents {
    // Border layer
    // Gray background
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    bgLayer = [CCSprite node];
    [bgLayer setContentSize:CGSizeMake(4096, 4096)];
    bgLayer.color = ccc3(128, 128, 128);
    bgLayer.anchorPoint = ccp(0.5, 0.5);
    bgLayer.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:bgLayer z:-1];
    
    // Rulers
    rulerLayer = [RulersLayer node];
    [self addChild:rulerLayer z:6];
    
    borderLayer = [CCLayer node];
    [bgLayer addChild:borderLayer z:1];
    
    ccColor4B borderColor = ccc4(220, 220, 220, 220); // default: 180
    
    borderBottom = [CCLayerColor layerWithColor:borderColor];
    borderTop = [CCLayerColor layerWithColor:borderColor];
    borderLeft = [CCLayerColor layerWithColor:borderColor];
    borderRight = [CCLayerColor layerWithColor:borderColor];
    
    [borderLayer addChild:borderBottom];
    [borderLayer addChild:borderTop];
    [borderLayer addChild:borderLeft];
    [borderLayer addChild:borderRight];
    
    borderDevice = [CCSprite node];
    [borderLayer addChild:borderDevice z:1];
    
    // Black content layer
    stageBgLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255) width:0 height:0];
    stageBgLayer.anchorPoint = ccp(0 , 0);
    stageBgLayer.ignoreAnchorPointForPosition = NO;
    [bgLayer addChild:stageBgLayer z:0];
    
    contentLayer = [CCLayer node];
    [stageBgLayer addChild:contentLayer];
    
    [borderBottom setOpacity:200]; //default 255
    [borderTop setOpacity:200];
    [borderLeft setOpacity:200];
    [borderRight setOpacity:200];
    
    NSString *backgroundFile = ((TestTutorialController *)mainGameController).mainWindow.backgroundUrl;
    
    if(backgroundFile && ![backgroundFile isEqualToString:@""]) {
        if([backgroundFile rangeOfString:@".tmx"].location == NSNotFound) {
            background = [[CCSprite alloc] initWithFile:backgroundFile];
        } else {
            background = (CCSprite *)[[CCTMXTiledMap alloc] initWithTMXFile:backgroundFile];
        }
    } else {
        //background = [[CCSprite alloc] init];
        background = [[CCSprite alloc] init];
    }
    
    background.position = ccp(0, 0);
    background.anchorPoint = ccp(0, 0);
    [contentLayer addChild:background];
    
    // Update mouse tracking
    CCGLView *mainGLView = ((TestTutorialController *)mainGameController).mainWindow.mainGLView;
    
    if (trackingArea)
    {        
        [mainGLView removeTrackingArea:trackingArea];
        [trackingArea release];
    }
    
    trackingArea = [[NSTrackingArea alloc] initWithRect:NSMakeRect(0, 0, winSize.width, winSize.height) options:NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingCursorUpdate | NSTrackingActiveInKeyWindow  owner:mainGLView userInfo:NULL];
    [mainGLView addTrackingArea:trackingArea];
}

-(void)updateDevice {
    
    CCTexture2D *deviceTexture = nil;
    
    int currentDeviceType = ((TestTutorialController *)mainGameController).currentDeviceType;
    int currentDeviceViewMode = ((TestTutorialController *)mainGameController).currentDeviceViewMode;
    CGSize currentSize = DEVICE_SIZE_IPHONE_4_LANDSCAPE;
    
    switch (currentDeviceType) {
        case DEVICE_TYPE_IPHONE_4:
            deviceTexture = [[CCTextureCache sharedTextureCache] addImage:@"frame-iphone.png"];
            
            if(currentDeviceViewMode == DEVICE_VIEW_MODE_LANDSCAPE)
                currentSize = DEVICE_SIZE_IPHONE_4_LANDSCAPE;
            else
                currentSize = DEVICE_SIZE_IPHONE_4_PORTRAIL;
            
            break;
        case DEVICE_TYPE_IPHONE_4_RETINA:
            deviceTexture = [[CCTextureCache sharedTextureCache] addImage:@"frame-iphone.png"];
            
            if(currentDeviceViewMode == DEVICE_VIEW_MODE_LANDSCAPE)
                currentSize = DEVICE_SIZE_IPHONE_4_LANDSCAPE;
            else
                currentSize = DEVICE_SIZE_IPHONE_4_PORTRAIL;
            
            break;
        case DEVICE_TYPE_IPHONE_5:
            deviceTexture = [[CCTextureCache sharedTextureCache] addImage:@"frame-iphone5.png"];
            
            if(currentDeviceViewMode == DEVICE_VIEW_MODE_LANDSCAPE)
                currentSize = DEVICE_SIZE_IPHONE_5_LANDSCAPE;
            else
                currentSize = DEVICE_SIZE_IPHONE_5_PORTRAIL;
            
            break;
        case DEVICE_TYPE_IPHONE_5_RETINA:
            deviceTexture = [[CCTextureCache sharedTextureCache] addImage:@"frame-iphone5.png"];
            
            if(currentDeviceViewMode == DEVICE_VIEW_MODE_LANDSCAPE)
                currentSize = DEVICE_SIZE_IPHONE_5_LANDSCAPE;
            else
                currentSize = DEVICE_SIZE_IPHONE_5_PORTRAIL;
            
            break;
        case DEVICE_TYPE_IPAD:
            deviceTexture = [[CCTextureCache sharedTextureCache] addImage:@"frame-ipad.png"];
            
            if(currentDeviceViewMode == DEVICE_VIEW_MODE_LANDSCAPE)
                currentSize = DEVICE_SIZE_IPAD_LANDSCAPE;
            else
                currentSize = DEVICE_SIZE_IPAD_PORTRAIL;
            
            break;
        case DEVICE_TYPE_IPAD_RETINA:
            deviceTexture = [[CCTextureCache sharedTextureCache] addImage:@"frame-ipad.png"];
            
            if(currentDeviceViewMode == DEVICE_VIEW_MODE_LANDSCAPE)
                currentSize = DEVICE_SIZE_IPAD_LANDSCAPE;
            else
                currentSize = DEVICE_SIZE_IPAD_PORTRAIL;
            
            break;
        case DEVICE_TYPE_CUSTOM_RESOLUTION:
            currentSize = ((TestTutorialController *)mainGameController).mainWindow.currentCustomDeviceSize;
            break;
    }
    
    if(deviceTexture != nil) {
        borderDevice.visible = YES;
        
        if (currentDeviceViewMode == DEVICE_VIEW_MODE_LANDSCAPE)
            borderDevice.rotation = -90;
        else
            borderDevice.rotation = 0;
        
        borderDevice.texture = deviceTexture;
        borderDevice.textureRect = CGRectMake(0, 0, deviceTexture.contentSize.width, deviceTexture.contentSize.height);
    } else {
        borderDevice.visible = NO;
    }
    
    CGSize winSize = bgLayer.contentSize;
    CGPoint stageCenter = ccp((int)(winSize.width/2) - currentSize.width/2 , (int)(winSize.height/2) - currentSize.height/2);
    stageBgLayer.position = stageCenter;
    stageBgLayer.contentSize = CGSizeMake(currentSize.width + 2, currentSize.height + 2);
    
    borderDevice.position = stageCenter;
    
    // Setup border layer
    CGRect bounds = [stageBgLayer boundingBox];
    
    borderBottom.position = ccp(0,0);
    [borderBottom setContentSize:CGSizeMake(winSize.width, bounds.origin.y)];
    
    borderTop.position = ccp(0, bounds.size.height + bounds.origin.y);
    [borderTop setContentSize:CGSizeMake(winSize.width, winSize.height - bounds.size.height - bounds.origin.y)];
    
    borderLeft.position = ccp(0,bounds.origin.y);
    [borderLeft setContentSize:CGSizeMake(bounds.origin.x, bounds.size.height)];
    
    borderRight.position = ccp(bounds.origin.x+bounds.size.width, bounds.origin.y);
    [borderRight setContentSize:CGSizeMake(winSize.width - bounds.origin.x - bounds.size.width, bounds.size.height)];
    
    CGPoint center = ccp(bounds.origin.x+bounds.size.width/2, bounds.origin.y+bounds.size.height/2);
    borderDevice.position = center;
    
    //update ruler
    [self updateRulerView];
}

-(void)zoomEditorWithValue:(float)_zoomValue {
    bgLayer.scale = _zoomValue;
    
    bgLayer.position = [self boundLayerPosWithNode:bgLayer inSize:mainGameController.winSize];
    
    //update ruler
    [self updateRulerView];
}

-(void) updateRulerView {
    /*stageOrigin = ccp(stageOrigin.x + contentLayer.position.x, stageOrigin.y + contentLayer.position.y);
     
     stageOrigin = ccp(stageOrigin.x + stageBgLayer.position.x, stageOrigin.y + stageBgLayer.position.y);
     
     stageOrigin = ccp(stageOrigin.x + bgLayer.position.x - bgLayer.contentSize.width*bgLayer.anchorPoint.x, stageOrigin.y + bgLayer.position.y - bgLayer.contentSize.height*bgLayer.anchorPoint.y);
     
     stageOrigin = ccp(stageOrigin.x + self.position.x, stageOrigin.y + self.position.y);*/
    
    NSPoint stageOrigin = [contentLayer convertToWorldSpace:background.position];
    
    [rulerLayer updateWithSize:self.mainGameController.winSize stageOrigin:stageOrigin zoom:((TestTutorialController *)mainGameController).currentZoomValue];
}

/*
-(void)update:(ccTime)dt{
    timer.percentage += 1;
    if (timer.percentage == 100){
        timer.percentage = 0;
    }
}
 */

-(void)drawStoryboardWithTutorialData:(NSMutableDictionary *)_data atIndex:(int)_index {
    //stop tutorial running
    isRunning = false;
    totalTimeRunning = 0;
    [((TestTutorialController *)mainGameController).mainWindow updateTimeRunning:totalTimeRunning];
    
    if(mainSpriteLib) {
        [mainSpriteLib stopTutorial];
        [mainSpriteLib removeAllChildrenWithCleanup:YES];
        [mainSpriteLib removeFromParentAndCleanup:NO];
        [mainSpriteLib release];
        mainSpriteLib = nil;
    }
 
    if(_index >= 0) {
        
        NSString *resourcePath = [NSString stringWithFormat:@"%@/",[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent: RESOURCE_CACHE_DIR]];
        
        mainSpriteLib = [[TutorialSpriteLib alloc] initTutorialSpriteLibWithData:_data withResourcePath:resourcePath];
        mainSpriteLib.anchorPoint = ccp(0, 0);
        mainSpriteLib.position = ccp(0, 0);
        mainSpriteLib.delegate = self;
        
        [background addChild:mainSpriteLib];
        
        [mainSpriteLib drawGUIWithStoryboardIndex:_index];
        
        //Reselected object from last object
        if(selectedObject) {
            NSString *objectName = ((TestTutorialController *)mainGameController).mainWindow.txtObjName.stringValue;
            
            [self showObjectWithName:objectName fromTutorialData:nil atIndex:mainSpriteLib.currentStoryboardRunning];
        }
    }
    
    isDraggingObject = FALSE;
}

-(void)updateBackgound {
    NSString *backgroundFile = ((TestTutorialController *)mainGameController).mainWindow.backgroundUrl;
   
    if(backgroundFile)
    {
        [background removeFromParentAndCleanup:NO];
        [background removeAllChildrenWithCleanup:NO];
        [background release];
        
        if([backgroundFile rangeOfString:@".tmx"].location == NSNotFound) {
            background = [[CCSprite alloc] initWithFile:backgroundFile];
        } else {
            background = (CCSprite *)[[CCTMXTiledMap alloc] initWithTMXFile:backgroundFile];
        }
        
        background.position = ccp(0, 0);
        background.anchorPoint = ccp(0, 0);
        
        if(mainSpriteLib)
            [background addChild:mainSpriteLib];
        
        [contentLayer addChild:background];
    }
    else
    {
        [background removeFromParentAndCleanup:NO];
        [background removeAllChildrenWithCleanup:NO];
        [background release];
        
        background = [[CCSprite alloc] init];
        background.position = ccp(0, 0);
        background.anchorPoint = ccp(0, 0);
        
        if(mainSpriteLib)
            [background addChild:mainSpriteLib];
        
        [contentLayer addChild:background];
    }
}

-(void)showObjectWithName:(NSString *)_objectName fromTutorialData:(NSMutableDictionary *)_data atIndex:(int)_index {
    TutorialObject *object = [mainSpriteLib getObjectByName:_objectName inStoryboardIndex:_index];
    
    if(object)
    {
        if (selectedSprite)
        {
            [selectedSprite removeFromParentAndCleanup:YES];
        }
        
        selectedSprite = [[CCSprite alloc]initWithFile:@"fire.png"];
        selectedSprite.color = ccc3(255, 0, 0);
        
        if(selectedObject){
            [selectedObject hideEffectWhenDeselected];
        }
        
        selectedObject = object;
        [selectedObject showEffectWhenSelected];
        
        if([object isKindOfClass:[TutorialButtonObject class]]) {
            CCSprite *buttonImage = [[object.spriteBody children] objectAtIndex:0];
            [buttonImage addChild:selectedSprite z: 0];
            
            selectedSprite.position = ccp(buttonImage.contentSize.width/2, buttonImage.contentSize.height/2);
        } else {
            [object.spriteBody addChild:selectedSprite z:0];
            selectedSprite.position = ccp(object.spriteBody.contentSize.width/2, object.spriteBody.contentSize.height/2);
        }
    }
    else
    {
        //deselect object
        if (selectedSprite)
        {
            [selectedSprite removeFromParentAndCleanup:YES];
            selectedSprite = nil;
        }
        
        if(selectedObject){
            [selectedObject hideEffectWhenDeselected];
            selectedObject = nil;
        }
    }
}

-(BOOL)ccScrollWheel:(NSEvent *)theEvent {
    float deltaY = -[theEvent deltaY] * 4;
    
    bgLayer.position = ccp(bgLayer.position.x, bgLayer.position.y + deltaY);
    
    bgLayer.position = [self boundLayerPosWithNode:bgLayer inSize:mainGameController.winSize];
    
    //update ruler
    [self updateRulerView];
    
    return false;
}

-(BOOL)ccMouseDown:(NSEvent *)event{
    //MainWindow *mainWindow = ((TestTutorialController *)mainGameController).mainWindow;
    
    CGPoint touchPoint = [[CCDirector sharedDirector] convertEventToGL: event];
    oldMousePosition = touchPoint;
    
    CGPoint touchPointOriginInBackground = [background convertToNodeSpace:touchPoint];
    [self proccessChooseDesPointWhenMouseClicked:touchPointOriginInBackground];
    
    return NO;
}

-(BOOL)ccMouseUp:(NSEvent *)event {    
    if(isDraggingObject) {
        isDraggingObject = FALSE;
    }else if (isRotatingObject) {
        isRotatingObject = FALSE;
    }
    return NO;
}

-(BOOL)ccMouseMoved:(NSEvent *)event {
    CGPoint touchPoint = [[CCDirector sharedDirector] convertEventToGL: event];
    CGPoint touchPointOriginInBackground = [background convertToNodeSpace:touchPoint];
    
    //update ruler mouse point
    [rulerLayer updateMousePos:touchPoint withOriginPointInBackgroundSpace:touchPointOriginInBackground];
    
    //Show object if button choose point is selected
    [self showObjectWhenChooseDesPoint:touchPointOriginInBackground];
    
    return NO;
}

-(BOOL)ccMouseDragged:(NSEvent *)event{
    //MainWindow *mainWindow = ((TestTutorialController *)mainGameController).mainWindow;
    CGPoint touchPoint = [[CCDirector sharedDirector] convertEventToGL: event];
    
    if (editMouseMode == EDIT_MODE_MOVE_DEVICE){
        
        bgLayer.position = ccp(bgLayer.position.x + (touchPoint.x - oldMousePosition.x), bgLayer.position.y + (touchPoint.y - oldMousePosition.y));
        
        bgLayer.position = [self boundLayerPosWithNode:bgLayer inSize:mainGameController.winSize];
        
        oldMousePosition = touchPoint;
        
        //update ruler
        [self updateRulerView];
        
    } else if(editMouseMode == EDIT_MODE_MOVE_BACKGROUND) {
        
        background.position = ccp(background.position.x + (touchPoint.x - oldMousePosition.x), background.position.y + (touchPoint.y - oldMousePosition.y));
        
        //bound backgound inside device frame
        background.position = [self boundLayerPosWithNode:background inSize:CGSizeMake(stageBgLayer.contentSize.width, stageBgLayer.contentSize.height)];
        
        oldMousePosition = touchPoint;
        
        //update ruler
        [self updateRulerView];
    }
    
    CGPoint touchPointOriginInBackground = [background convertToNodeSpace:touchPoint];
    //update ruler mouse point
    [rulerLayer updateMousePos:touchPoint withOriginPointInBackgroundSpace:touchPointOriginInBackground];
    
    return NO;
}

-(void)ccMouseEntered:(NSEvent *)theEvent {
    [rulerLayer mouseEntered:theEvent];
}

-(void)ccMouseExited:(NSEvent *)theEvent {
    [rulerLayer mouseExited:theEvent];
}

-(void)tutorialLibObjectMoving:(TutorialObject *)_object atStory:(int)_storyIndex{
    isDraggingObject = TRUE;
    
    MainWindow *window = ((TestTutorialController *)mainGameController).mainWindow;
    
    NSMutableDictionary *data = window.tutorial;
    
    NSString *objectName = [_object.objectData objectForKey:TUTORIAL_OBJECT_NAME_KEY];
    
    NSMutableDictionary *objectData = [TutorialData getObjectDataFrom:data withStoryIndex:_storyIndex withObjectName:objectName];
    
    [objectData setValue:[NSString stringWithFormat:@"%f",_object.spriteBody.position.x] forKey:TUTORIAL_OBJECT_PARAMETER_POS_X_KEY];
    
    [objectData setValue:[NSString stringWithFormat:@"%f",_object.spriteBody.position.y] forKey:TUTORIAL_OBJECT_PARAMETER_POS_Y_KEY];
    
    window.txtObjName.stringValue = objectName; 
    
    [window updateObjectTextFieldsValueWithData:objectData];
    
    [window selectObjectWithName:objectName];
    
    //call function object is moving of mainWindows class, it will be used in record list point mode
    [window objectWithName:objectName isMovingToPoint:[_object getPosition]];
}

-(void)tutorialLibObjectRotating:(TutorialObject *)_object atStory:(int)_storyIndex{
    
    isRotatingObject = YES;
    
    MainWindow *window = ((TestTutorialController *)mainGameController).mainWindow;
    
    NSMutableDictionary *data = window.tutorial;
    
    NSString *objectName = [_object.objectData objectForKey:TUTORIAL_OBJECT_NAME_KEY];
    
    NSMutableDictionary *objectData = [TutorialData getObjectDataFrom:data withStoryIndex:_storyIndex withObjectName:objectName];
    
    if ([_object isKindOfClass:[TutorialButtonObject class]]){
        CCSprite *buttonItem = (CCSprite *)[[_object.spriteBody children] objectAtIndex:0];
        
        [objectData setValue:[NSString stringWithFormat:@"%f",buttonItem.rotation] forKey:TUTORIAL_OBJECT_PARAMETER_ROTATION_KEY];
    }else{

        [objectData setValue:[NSString stringWithFormat:@"%f",_object.spriteBody.rotation] forKey:TUTORIAL_OBJECT_PARAMETER_ROTATION_KEY];
    }
    
    window.txtObjName.stringValue = objectName; 
    
    [window updateObjectTextFieldsValueWithData:objectData];
    
}


-(void)tutorialLibObjectClicked:(TutorialObject *)_object atStory:(int)_storyIndex {        
    if(selectedObject){
        [selectedObject hideEffectWhenDeselected];
    }
    
    selectedObject = _object;
    
    [selectedObject showEffectWhenSelected];
    
    MainWindow *window = ((TestTutorialController *)mainGameController).mainWindow;
    
    NSMutableDictionary *data = window.tutorial;
    
    NSString *objectName = [_object.objectData objectForKey:TUTORIAL_OBJECT_NAME_KEY];

    NSMutableDictionary *objectData = [TutorialData getObjectDataFrom:data withStoryIndex:_storyIndex withObjectName:objectName];
    
    window.txtObjName.stringValue = objectName; 
    
    [window updateObjectTextFieldsValueWithData:objectData];
    
    [window selectObjectWithName:objectName];
    
    
    //call function object is moving of mainWindows class, it will be used in record list point mode
    //we save this first point
    [window objectWithName:objectName isMovingToPoint:[_object getPosition]];
}

-(void)step:(ccTime)delta{
    NSLog(@"hahaha");
}

-(CGPoint)boundLayerPosWithNode:(CCNode *)_node inSize:(CGSize )_size {
    CGPoint retval = _node.position;

    retval.x = MAX(retval.x, -_node.contentSize.width * _node.scale + _size.width + _node.contentSize.width * _node.scale * _node.anchorPoint.x);
    retval.x = MIN(retval.x, _node.contentSize.width * _node.scale * _node.anchorPoint.x);


    retval.y = MAX(-_node.contentSize.height * _node.scale + _size.height + _node.contentSize.height * _node.scale * _node.anchorPoint.x, retval.y);
    retval.y = MIN(_node.contentSize.height * _node.scale * _node.anchorPoint.y, retval.y);

    return retval;
}

-(void)runStoryAtIndex:(int)_index withTutorialData:(NSMutableDictionary *)_data {
    isRunning = true;
    
    if(mainSpriteLib) {
        [mainSpriteLib stopTutorial];
        [mainSpriteLib removeAllChildrenWithCleanup:YES];
        [mainSpriteLib removeFromParentAndCleanup:NO];
        [mainSpriteLib release];
        mainSpriteLib = nil;
    }
    
    if(_index >= 0) {
        
        NSString *resourcePath = [NSString stringWithFormat:@"%@/",[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent: RESOURCE_CACHE_DIR]];
        
        mainSpriteLib = [[TutorialSpriteLib alloc] initTutorialSpriteLibWithData:_data withResourcePath:resourcePath];
        mainSpriteLib.anchorPoint = ccp(0, 0);
        mainSpriteLib.position = ccp(0, 0);
        mainSpriteLib.delegate = self;
        
        [background addChild:mainSpriteLib];
        
        [mainSpriteLib runStoryboardAtIndex:_index];
    }
}

-(void)tutorialLibFinishedStoryboard:(int)_storyIndex {
    [mainSpriteLib stopTutorial];
    
    //send message to main windows stop
    [((TestTutorialController *)mainGameController).mainWindow runCurrentStoryboard];
    
    isRunning = false;
}

// Function show object target of action with special transparent
// This fucntion only run when click on button Find point when edit action properties
-(void)showObjectWhenChooseDesPoint:(NSPoint)_mousePoint {
    MainWindow *mainWindow = ((TestTutorialController *)mainGameController).mainWindow;
    
    ActionEditPropertiesViewController *actionEditViewController = mainWindow.viewEditActionData;
    
    ActionSequencePropertiesViewController *sequenceEditViewController = mainWindow.viewEditActionSequence;
    
    if(sequenceEditViewController.currentStoryIndex >= 0 && sequenceEditViewController.currentSequenceIndex >= 0 && actionEditViewController.isChoosePoint) {
    
        NSString *targetName = sequenceEditViewController.popupButtonObjTarget.titleOfSelectedItem;
        
        TutorialObject *targetObject = [mainSpriteLib getObjectByName:targetName inStoryboardIndex:mainSpriteLib.currentStoryboardRunning];
        
        if(targetObject) {
            if(objectTargetOfCurrentActionSprite) {
                [objectTargetOfCurrentActionSprite removeFromParentAndCleanup:YES];
                objectTargetOfCurrentActionSprite = nil;
            }
            
            if([targetObject isKindOfClass:[TutorialParticleObject class]])
            {
                objectTargetOfCurrentActionSprite = [CCSprite spriteWithTexture:targetObject.spriteBody.texture];
            }
            else
            {
                if([targetObject isKindOfClass:[TutorialButtonObject class]])
                {
                    CCSprite *buttonSprite = (CCSprite *)[(CCMenuItemImage *)[[targetObject.spriteBody children] objectAtIndex:0] normalImage];
                
                    objectTargetOfCurrentActionSprite = [CCSprite spriteWithTexture:buttonSprite.texture rect:buttonSprite.textureRect];
                    objectTargetOfCurrentActionSprite.opacity = targetObject.spriteBody.opacity / 2;
                }
                else
                {
                    objectTargetOfCurrentActionSprite = [CCSprite spriteWithTexture:targetObject.spriteBody.texture rect:targetObject.spriteBody.textureRect];
                    objectTargetOfCurrentActionSprite.opacity = targetObject.spriteBody.opacity / 2;
                }
            }
            
            objectTargetOfCurrentActionSprite.position = _mousePoint;
            objectTargetOfCurrentActionSprite.anchorPoint = targetObject.spriteBody.anchorPoint;
            [background addChild:objectTargetOfCurrentActionSprite];
        }
    }
}

-(void)proccessChooseDesPointWhenMouseClicked:(CGPoint)_mousePoint {
    MainWindow *mainWindow = ((TestTutorialController *)mainGameController).mainWindow;
    
    ActionEditPropertiesViewController *actionEditViewController = mainWindow.viewEditActionData;
    
    ActionSequencePropertiesViewController *sequenceEditViewController = mainWindow.viewEditActionSequence;
    
    if(sequenceEditViewController.currentStoryIndex >= 0 && sequenceEditViewController.currentSequenceIndex >= 0 && actionEditViewController.isChoosePoint) {
        
        if(objectTargetOfCurrentActionSprite) {
            [objectTargetOfCurrentActionSprite removeFromParentAndCleanup:YES];
            objectTargetOfCurrentActionSprite = nil;
        }
        
        [actionEditViewController setPointOfMouseClickedOnCocosView:_mousePoint];
    }
}

-(void)showDestinationSpriteWhenHover:(NSString *)_targetName desPoint:(CGPoint)_desPoint storyIndex:(int)_storyIndex {
    if(spriteDestinationMouseHover) {
        [spriteDestinationMouseHover removeFromParentAndCleanup:YES];
        spriteDestinationMouseHover = nil;
    }
    
    if(![_targetName isEqualToString:@""] && _targetName != nil && _storyIndex >= 0)
    {
        TutorialObject *targetObject = [mainSpriteLib getObjectByName:_targetName inStoryboardIndex:mainSpriteLib.currentStoryboardRunning];
        
        if(targetObject) {            
            if([targetObject isKindOfClass:[TutorialParticleObject class]])
            {
                spriteDestinationMouseHover = [CCSprite spriteWithTexture:targetObject.spriteBody.texture];
            }
            else
            {
                if([targetObject isKindOfClass:[TutorialButtonObject class]])
                {
                    CCSprite *buttonSprite = (CCSprite *)[(CCMenuItemImage *)[[targetObject.spriteBody children] objectAtIndex:0] normalImage];
                    
                    spriteDestinationMouseHover = [CCSprite spriteWithTexture:buttonSprite.texture rect:buttonSprite.textureRect];
                    spriteDestinationMouseHover.opacity = targetObject.spriteBody.opacity / 2;
                }
                else
                {
                    spriteDestinationMouseHover = [CCSprite spriteWithTexture:targetObject.spriteBody.texture rect:targetObject.spriteBody.textureRect];
                    spriteDestinationMouseHover.opacity = targetObject.spriteBody.opacity / 2;
                }
            }
            
            spriteDestinationMouseHover.position = _desPoint;
            spriteDestinationMouseHover.anchorPoint = targetObject.spriteBody.anchorPoint;
            [background addChild:spriteDestinationMouseHover];
        }
    }
}

-(void)hideDestinationSprite {
    if(spriteDestinationMouseHover) {
        [spriteDestinationMouseHover removeFromParentAndCleanup:YES];
        spriteDestinationMouseHover = nil;
    }
}

-(void)dealloc {
    NSLog(@"Game screen dealloc");
    
    [mainSpriteLib stopTutorial];
    [mainSpriteLib removeAllChildrenWithCleanup:YES];
    [mainSpriteLib removeFromParentAndCleanup:YES];
    [mainSpriteLib release];
    mainSpriteLib = nil;
    
    [super dealloc];
}

@end
