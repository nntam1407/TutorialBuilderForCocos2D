//
//  RunTutorialLayer.m
//  TutorialTool
//
//  Created by User on 10/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RunTutorialLayer.h"
#import "TestTutorialController.h"
#import "MainWindow.h"
#import "TutorialToolDefine.h"

@implementation RunTutorialLayer

-(id)initRunTutorialLayerWith:(iCoreGameController *)_mainGameController andTutorialData:(NSMutableDictionary *)_tutorialData {
    self = [super initGameLayerWith:_mainGameController];
    
    tutorialData = _tutorialData;
    
    self.isMouseEnabled = YES;
    self.isTouchEnabled = YES;
    
    [self createb2World];
    [self loadGameComponents];
    
    [self updateDevice];
    [self zoomEditorWithValue:((TestTutorialController *)mainGameController).currentZoomValue];
    
    return self;
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
    
    ccColor4B borderColor = ccc4(128, 128, 128, 180);
    
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
    stageBgLayer.anchorPoint = ccp(0, 0);
    stageBgLayer.ignoreAnchorPointForPosition = NO;
    [bgLayer addChild:stageBgLayer z:0];
    
    contentLayer = [CCLayer node];
    [stageBgLayer addChild:contentLayer];
    
    [borderBottom setOpacity:255];
    [borderTop setOpacity:255];
    [borderLeft setOpacity:255];
    [borderRight setOpacity:255];
    
    NSString *backgroundFile = ((TestTutorialController *)mainGameController).mainWindow.backgroundUrl;
    
    if(backgroundFile && ![backgroundFile isEqualToString:@""]) {
        if([backgroundFile rangeOfString:@".tmx"].location == NSNotFound) {
            background = [CCSprite spriteWithFile:backgroundFile];
        } else {
            background = (CCSprite *)[CCTMXTiledMap tiledMapWithTMXFile:backgroundFile];
        }
    } else {
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
    
    /*CCLabelTTF *textGuide = [CCLabelTTF labelWithString:@"Tutorial testing!" fontName:@"Marker Felt" fontSize:14];
    textGuide.position = ccp(240, 300);
    [self addChild:textGuide];*/
    
    NSString *resourcePath = [NSString stringWithFormat:@"%@/",[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent: RESOURCE_CACHE_DIR]];
    
    mainTutorial = [[TutorialSpriteLib alloc] initTutorialSpriteLibWithData:tutorialData withResourcePath:resourcePath];
    mainTutorial.delegate = self;
    mainTutorial.anchorPoint = ccp(0, 0);
    mainTutorial.position = ccp(0, 0);
    //mainTutorial.color = ccc3(255, 255, 255);
    [background addChild:mainTutorial];
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

-(void)runStoryAtIndex:(int)_index {
    [mainTutorial runStoryboardAtIndex:_index];
}

-(void)tutorialLibFinishedStoryboard:(int)_storyIndex {
    [mainTutorial stopTutorial];
    [mainTutorial removeAllChildrenWithCleanup:YES];
    [mainTutorial removeFromParentAndCleanup:YES];
    [mainTutorial release];
    mainTutorial = nil;
    
    //send message to main windows stop
    [((TestTutorialController *)mainGameController).mainWindow runCurrentStoryboard];
}

-(BOOL)ccScrollWheel:(NSEvent *)theEvent {
    float deltaY = -[theEvent deltaY] * 4;
    
    bgLayer.position = ccp(bgLayer.position.x, bgLayer.position.y + deltaY);
    
    bgLayer.position = [self boundLayerPosWithNode:bgLayer inSize:mainGameController.winSize];
    
    return false;
}

-(BOOL)ccMouseDown:(NSEvent *)event{
    //MainWindow *mainWindow = ((TestTutorialController *)mainGameController).mainWindow;
    
    CGPoint touchPoint = [[CCDirector sharedDirector] convertEventToGL: event];
    oldMousePosition = touchPoint;
    
    //update ruler
    [self updateRulerView];
    
    return false;
}


-(BOOL)ccMouseMoved:(NSEvent *)event {
    CGPoint touchPoint = [[CCDirector sharedDirector] convertEventToGL: event];
    CGPoint touchPointOriginInBackground = [background convertToNodeSpace:touchPoint];
    
    //update ruler mouse point
    [rulerLayer updateMousePos:touchPoint withOriginPointInBackgroundSpace:touchPointOriginInBackground];
    
    return NO;
}

-(BOOL)ccMouseDragged:(NSEvent *)event{
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

-(CGPoint)boundLayerPosWithNode:(CCNode *)_node inSize:(CGSize )_size {
    CGPoint retval = _node.position;
    
    retval.x = MAX(retval.x, -_node.contentSize.width * _node.scale + _size.width + _node.contentSize.width * _node.scale * _node.anchorPoint.x);
    retval.x = MIN(retval.x, _node.contentSize.width * _node.scale * _node.anchorPoint.x);
    
    retval.y = MAX(-_node.contentSize.height * _node.scale + _size.height + _node.contentSize.height * _node.scale * _node.anchorPoint.x, retval.y);
    retval.y = MIN(_node.contentSize.height * _node.scale * _node.anchorPoint.y, retval.y);
    
    return retval;
}

-(void) updateRulerView {    
    NSPoint stageOrigin = [contentLayer convertToWorldSpace:background.position];
    
    [rulerLayer updateWithSize:self.mainGameController.winSize stageOrigin:stageOrigin zoom:((TestTutorialController *)mainGameController).currentZoomValue];
}

-(void)dealloc {
    NSLog(@"Main tutorial dealloc");
    
    [mainTutorial stopTutorial];
    [mainTutorial removeAllChildrenWithCleanup:YES];
    [mainTutorial removeFromParentAndCleanup:YES];
    [mainTutorial release];
    mainTutorial = nil;
    
    [super dealloc];
}

@end
