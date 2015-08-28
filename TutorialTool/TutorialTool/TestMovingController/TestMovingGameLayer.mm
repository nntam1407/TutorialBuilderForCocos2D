//
//  TestMovingGameLayer.m
//  LibGame
//
//  Created by VienTran on 8/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestMovingGameLayer.h"
#import "LinearMovingController.h"
#import "MovingRepeat.h"
#import "MovingSequence.h"
#import "MovingRepeatForever.h"
#import "WavySinMovingController.h"
#import "FermatSpiralMovingController.h"
#import "RoundMovingController.h"
#import "ZiczacMovingController.h"
#import "SpringMovingController.h"
#import "ElipMovingController.h"
#import "CustomSpringMovingController.h"
#import "TutorialSpriteLib.h"
#import "MovingEaseIn.h"
#import "MovingEaseOut.h"
#import "MovingEaseInOut.h"
#import "movingeaseOutIn.h"
#import "MovingRevert.h"
#import "MovingRevertForever.h"
#import "MovingDelay.h"
#import "CallFunctionC.h"
#import "OnPointsMovingController.h"
#import "LagrangeInterpolationController.h"
#import "BezierInterpolationController.h"

@implementation TestMovingGameLayer

-(id)initTestMovingGameLayerWith:(iCoreGameController *)_mainGameController {
    self = [super initGameLayerWith:_mainGameController];
    self.isTouchEnabled = YES;
    [self createb2World];
    [self loadGameComponents];
    [self scheduleUpdate];
    currentExample = 1;
    numExample = 27;
    [self runCurrentExample];
    return self;
};

-(void)update:(ccTime)dt {
    [super update:dt];
    
    
    //DebugDraw
    //if (arc4random()%5 == 0)
    for (GameObj * obj in gameComponents) {
        CCSprite *crumb = [CCSprite spriteWithTexture:drawDebug.texture];
        crumb.textureRect = CGRectMake(0, 0, 1, 1);
        crumb.color = ccc3(255, 255, 0);
        crumb.position = ccp(obj.spriteBody.position.x, obj.spriteBody.position.y);
        [drawDebug addChild:crumb];
    }
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

-(void)nextExample{
    currentExample ++;
    if (currentExample > numExample) {
        currentExample = 1;
    }
    [self runCurrentExample];
}

-(void)preExample{
    currentExample --;
    if (currentExample < 1) {
        currentExample = numExample;
    }
    [self runCurrentExample];
}

-(void)runCurrentExample{
    [bee1 stopAllMoving];
    //[drawDebug removeAllChildrenWithCleanup:YES];
    switch (currentExample) {
        case 1:
        {
            [titleExample setString:@"Linear moving controller"];
//            [bee1 setPosition:ccp(50, 160)];
//            [bee1 moveWith:[LinearMovingController linearMovingWithDuration:2.f position:ccp(400, 300)]];
            [bee1 setPosition:ccp(50, 160)];
            [bee1 moveWith:[OnPointsMovingController onPointsMovingWithDuration:2.f andPointsList:[NSValue valueWithCGPoint:ccp(100, 200)], [NSValue valueWithCGPoint:ccp(200, 180)], [NSValue valueWithCGPoint:ccp(400, 160)],nil]];
//            [bee1 setPosition:ccp(50, 160)];
//            [bee1 moveWith:[MovingEaseOutIn moveWithMoveController:[LinearMovingController linearMovingWithDuration:2.f position:ccp(400, 160)]]];
            
            //Create dem Array Point
//            NSMutableArray *points = [[NSMutableArray alloc] init];
//            [points addObject:[NSValue valueWithCGPoint:ccp(0, 100)]];
//            [points addObject:[NSValue valueWithCGPoint:ccp(100, 100)]];
//            [points addObject:[NSValue valueWithCGPoint:ccp(200, 150)]];
//            [points addObject:[NSValue valueWithCGPoint:ccp(300, 250)]];
            
//            NSMutableArray *points = [[NSMutableArray alloc] init];
//            [points addObject:[NSValue valueWithCGPoint:ccp(0, 200)]];
//            [points addObject:[NSValue valueWithCGPoint:ccp(200, 200)]];
//            [points addObject:[NSValue valueWithCGPoint:ccp(200, 0)]];
//            [points addObject:[NSValue valueWithCGPoint:ccp(400, 0)]];
//            [points addObject:[NSValue valueWithCGPoint:ccp(400, 200)]];
//            [points addObject:[NSValue valueWithCGPoint:ccp(0, 200)]];

            
            
//            LagrangeInterpolationController *lagrangeInterpolation = [[LagrangeInterpolationController alloc]initLagrangeInterpolationControllerWith:points];
//            NSMutableArray *outputPoints = [[NSMutableArray alloc]initWithArray:[lagrangeInterpolation runMovingInterpolationWithEpsilion:5]];
            
//            BezierInterpolationController *bezierInterpolation = [[BezierInterpolationController alloc] initMovingInterpolationWith:points];
//            NSMutableArray *outputPoints = [[NSMutableArray alloc]initWithArray:[bezierInterpolation runMovingInterpolationWithEpsilion:5]];
//            
//            for(int i=0;i<[outputPoints count];i++){
//                CCSprite *crumb = [CCSprite spriteWithTexture:drawDebug.texture];
//                crumb.textureRect = CGRectMake(0, 0, 1, 1);
//                crumb.color = ccc3(255, 255, 0);
//                crumb.position = [[outputPoints objectAtIndex:i] CGPointValue];
//                [drawDebug addChild:crumb];
//                
//                NSLog(@"x= %f, y=%f",crumb.position.x,crumb.position.y);
//            }
        }
            break;
        case 2:
//            [bee1 setPosition:ccp(50, 160)];
//            [bee1 moveWith:[MovingEaseOutIn moveWithMoveController:[LinearMovingController linearMovingWithDuration:2.f position:ccp(400, 160)]]];
            [titleExample setString:@"Rounding moving controller"];
            [bee1 setPosition:ccp(50, 160)];
            [bee1 moveWith:[RoundMovingController roundMovingWithDuration:1.f position:ccp(150, 160) clockwise:YES]];
            break;
        case 3:
            [titleExample setString:@"WavySin moving controller"];
            [bee1 setPosition:ccp(50, 160)];
            [bee1 moveWith:[WavySinMovingController wavySinMovingWithDuration:4.f andDestination:ccp(300, 200) andAmplitude:30 andNumberLoop:4 andPositive:YES]];
            break;
        case 4:
            [titleExample setString:@"Spring moving controller"];
            [bee1 setPosition:ccp(50, 160)];
            [bee1 moveWith:[SpringMovingController springMovingControllerWithDuration:4.f andDestination:ccp(300, 200) andAmplitude:30 andNumberLoop:4 andPositive:YES andDistance:20]];
            break;
        case 5:
            [titleExample setString:@"FermatSpiral moving controller"];
            [bee1 setPosition:ccp(240, 150)];
            [bee1 moveWith:[FermatSpiralMovingController runFermatSpiralMovingControllerWithDuration:8.f andDestination:ccp(240, 200)]];
            break;
        case 6:
            [titleExample setString:@"Elip moving controller"];
            [bee1 setPosition:ccp(240, 150)];
            [bee1 moveWith:[ElipMovingController runElipMovingControllerWithDuration:4.f position:ccp(300, 200) andAmplitude:30 clockwise:YES]];
            break;
        
        case 7:
            [titleExample setString:@"Ziczac moving controller"];
            [bee1 setPosition:ccp(50, 160)];
            [bee1 moveWith:[ZiczacMovingController ziczacMovingWithDuration:4.f position:ccp(400, 160) amplitude:40 loopNumber:5 positive:YES]];
            break;
            
        case 8:
            [titleExample setString:@"Ziczac moving controller - descrease Amplitude"];
            [bee1 setPosition:ccp(50, 160)];
            [bee1 moveWith:[ZiczacMovingController ziczacMovingWithDuration:4.f position:ccp(400, 160) startAmplitude:40 endAmplitude:10 loopNumber:5 positive:YES]];
            break;
        
        case 9:
            [titleExample setString:@"Ziczac moving controller - increase Amplitude"];
            [bee1 setPosition:ccp(50, 160)];
            [bee1 moveWith:[ZiczacMovingController ziczacMovingWithDuration:4.f position:ccp(400, 160) startAmplitude:10 endAmplitude:40 loopNumber:5 positive:YES]];
            break;
        
        case 10:
            [titleExample setString:@"CustomSpring moving controller - Increase Amplitude"];
            [bee1 setPosition:ccp(50, 160)];
            [bee1 moveWith:[MovingEaseIn moveWithMoveController:[CustomSpringMovingController runCustomSpringMovingControllerWithDuration:4.f andAmplitudeMax:40 andAmplitudeMin:10 andEndPosition:ccp(250, 160) andNumberSpring:5 andDistanceBetween:20 andIsPositive:YES andIsInscrease:YES]]];
            break;
        
        case 11:
            [titleExample setString:@"CustomSpring moving controller - Descrease Amplitude"];
            [bee1 setPosition:ccp(50, 160)];
            [bee1 moveWith:[MovingEaseOut moveWithMoveController:[CustomSpringMovingController runCustomSpringMovingControllerWithDuration:4.f andAmplitudeMax:40 andAmplitudeMin:10 andEndPosition:ccp(250, 160) andNumberSpring:5 andDistanceBetween:20 andIsPositive:YES andIsInscrease:NO]]];
            break;
        
        case 12:
            [titleExample setString:@"Linear moving controller - increase speed"];
            [bee1 setPosition:ccp(50, 160)];
            [bee1 moveWith:[MovingEaseIn moveWithMoveController:[LinearMovingController linearMovingWithDuration:2.f position:ccp(400, 300)]]];
            break;
        case 13:
            [titleExample setString:@"Rounding moving controller - descrease speed"];
            [bee1 setPosition:ccp(50, 160)];
            [bee1 moveWith:[MovingEaseOut moveWithMoveController:[RoundMovingController roundMovingWithDuration:1.f position:ccp(150, 160) clockwise:YES]]];
            break;
        case 14:
            [titleExample setString:@"WavySin moving controller - increase speed"];
            [bee1 setPosition:ccp(50, 160)];
            [bee1 moveWith:[MovingEaseIn moveWithMoveController:[MovingEaseIn moveWithMoveController:[WavySinMovingController wavySinMovingWithDuration:4.f andDestination:ccp(300, 200) andAmplitude:30 andNumberLoop:4 andPositive:YES]]]];
            break;
        case 15:
            [titleExample setString:@"Spring moving controller - descrease speed"];
            [bee1 setPosition:ccp(50, 160)];
            [bee1 moveWith:[MovingEaseOut moveWithMoveController:[SpringMovingController springMovingControllerWithDuration:4.f andDestination:ccp(300, 200) andAmplitude:30 andNumberLoop:4 andPositive:YES andDistance:20]]];
            break;
        case 16:
            [titleExample setString:@"FermatSpiral moving controller - increase speed"];
            [bee1 setPosition:ccp(240, 150)];
            [bee1 moveWith:[MovingEaseIn moveWithMoveController:[FermatSpiralMovingController runFermatSpiralMovingControllerWithDuration:8.f andDestination:ccp(240, 200)]]];
            break;
        case 17:
            [titleExample setString:@"Elip moving controller  - descrease speed"];
            [bee1 setPosition:ccp(240, 150)];
            [bee1 moveWith:[MovingEaseOut moveWithMoveController:[ElipMovingController runElipMovingControllerWithDuration:4.f position:ccp(300, 200) andAmplitude:30 clockwise:YES]]];
            break;
            
        case 18:
            [titleExample setString:@"Ziczac moving controller - increase speed"];
            [bee1 setPosition:ccp(50, 160)];
            [bee1 moveWith:[MovingEaseOut moveWithMoveController:[ZiczacMovingController ziczacMovingWithDuration:4.f position:ccp(400, 160) amplitude:40 loopNumber:5 positive:YES]]];
            break;
        case 19:
            [titleExample setString:@"Sequence liner + round + ziczac"];
            [bee1 setPosition:ccp(50, 160)];
            [bee1 moveWith:[MovingSequence movingControllers:[LinearMovingController linearMovingWithDuration:2.f position:ccp(150, 100)],[MovingDelay delayWithDuration:2.f] ,[RoundMovingController roundMovingWithDuration:2.f position:ccp(250, 100) clockwise:YES], [CallFunctionC actionWithTarget:self selector:@selector(goichovui)],[ZiczacMovingController ziczacMovingWithDuration:4.f position:ccp(400, 300) amplitude:30.f loopNumber:5 positive:NO], nil]];
            break;
        case 20:
            [titleExample setString:@"Wavy + linear + round - repeat"];
            [bee1 setPosition:ccp(50, 160)];
            [bee1 moveWith:[MovingSequence movingControllers:[MovingDelay delayWithDuration:2.0f], [MovingRepeat repeatWithMoveController:[MovingSequence movingControllers:[WavySinMovingController wavySinMovingWithDuration:2.f andDestination:ccp(150, 160) andAmplitude:30 andNumberLoop:3 andPositive:YES],[LinearMovingController linearMovingWithDuration:1.f position:ccp(250, 160)],[RoundMovingController roundMovingWithDuration:2.f position:ccp(350, 160) clockwise:YES], nil] withTimes:2], nil]];
            break;
        case 21:
            [titleExample setString:@"Wavy + linear + round - repeat forever"];
            [bee1 setPosition:ccp(50, 160)];
            [bee1 moveWith:[MovingRepeatForever repeatWithMoveController:[MovingSequence movingControllers:[WavySinMovingController wavySinMovingWithDuration:2.f andDestination:ccp(150, 160) andAmplitude:30 andNumberLoop:3 andPositive:YES],[LinearMovingController linearMovingWithDuration:1.f position:ccp(250, 160)],[RoundMovingController roundMovingWithDuration:2.f position:ccp(350, 160) clockwise:YES], nil]]];
            break;
        case 22:
            [titleExample setString:@"Parallel moving:  Wavy + linear + round"];
            [bee1 setPosition:ccp(50, 160)];
            //[bee1 moveWith:[WavySinMovingController wavySinMovingWithDuration:2.f andDestination:ccp(150, 160) andAmplitude:30 andNumberLoop:3 andPositive:YES]];
            //[bee1 moveWith:[LinearMovingController linearMovingWithDuration:2.f position:ccp(80, 260)]];
            [bee1 moveWith:[RoundMovingController roundMovingWithDuration:5.f position:ccp(250, 160) clockwise:YES]];
            [bee1 moveWith:[ZiczacMovingController ziczacMovingWithDuration:4.f position:ccp(150, 160) amplitude:30.f loopNumber:5 positive:NO]];
            break;
        case 23:
            [titleExample setString:@"Revert WavyMovingController"];
            [bee1 setPosition:ccp(50, 160)];
            [bee1 moveWith:[MovingRevert revertWithWith:[WavySinMovingController wavySinMovingWithDuration:2.f andDestination:ccp(150, 160) andAmplitude:30 andNumberLoop:3 andPositive:YES] withTimes:4]];
            break;
        case 24:
            [titleExample setString:@"RevertForever WavyMovingController"];
            [bee1 setPosition:ccp(50, 160)];
            [bee1 moveWith:[MovingRevertForever revertWithMoveController:[WavySinMovingController wavySinMovingWithDuration:2.f andDestination:ccp(150, 160) andAmplitude:30 andNumberLoop:3 andPositive:YES]]];
            break;
        case 25:
            [titleExample setString:@"Revert Sequence: Wavy + linear + round"];
            [bee1 setPosition:ccp(50, 160)];
            [bee1 moveWith:[MovingRevert revertWithWith:[MovingSequence movingControllers:[WavySinMovingController wavySinMovingWithDuration:2.f andDestination:ccp(150, 160) andAmplitude:30 andNumberLoop:3 andPositive:YES],[LinearMovingController linearMovingWithDuration:1.f position:ccp(250, 160)],[RoundMovingController roundMovingWithDuration:2.f position:ccp(350, 160) clockwise:YES], nil] withTimes:4]];
            break;
        case 26:
            [titleExample setString:@"RevertForever Sequence: Wavy + linear + round"];
            [bee1 setPosition:ccp(50, 160)];
            [bee1 moveWith:[MovingRevertForever revertWithMoveController:[MovingSequence movingControllers:[WavySinMovingController wavySinMovingWithDuration:2.f andDestination:ccp(150, 160) andAmplitude:30 andNumberLoop:3 andPositive:YES],[LinearMovingController linearMovingWithDuration:1.f position:ccp(250, 160)],[RoundMovingController roundMovingWithDuration:2.f position:ccp(350, 160) clockwise:YES], nil]]];
            break;
        case 27:
            [titleExample setString:@"Ziczac moving controller - revert"];
            [bee1 setPosition:ccp(50, 160)];
            [bee1 moveWith:[MovingRevert revertWithWith:[ZiczacMovingController ziczacMovingWithDuration:4.f position:ccp(400, 160) amplitude:40 loopNumber:5 positive:YES] withTimes:2]];
            break;
            
        default:
            break;
    }
}


-(void)goichovui{
    [titleExample setString:@"Goi Cho vui"];
}

-(void)loadGameComponents{
    drawDebug = [[CCSpriteBatchNode alloc] initWithFile:@"TestMovingControllerResources/Images/blank.png" capacity:10000];
    [self addChild:drawDebug]; 
    
    titleExample = [[CCLabelTTF alloc] initWithString:@"ABC" fontName:@"Marker Felt" fontSize:20];
    titleExample.color=ccc3(255,255,255);
    [titleExample setPosition:ccp(240, 300)];
    [self addChild:titleExample];
    
    CCMenuItemImage *backButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithFile:@"TestMovingControllerResources/Images/b1.png"] selectedSprite:[CCSprite spriteWithFile:@"TestMovingControllerResources/Images/b1.png"] target:self selector:@selector(preExample)]; 
    //backButton.position = ccp(30,0);
    CCMenuItemImage *replayButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithFile:@"TestMovingControllerResources/Images/r1.png"] selectedSprite:[CCSprite spriteWithFile:@"TestMovingControllerResources/Images/r1.png"] target:self selector:@selector(runCurrentExample)];
    
    CCMenuItemImage *nextButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithFile:@"TestMovingControllerResources/Images/f1.png"] selectedSprite:[CCSprite spriteWithFile:@"TestMovingControllerResources/Images/f1.png"] target:self selector:@selector(nextExample)];
    
    
    CCMenu *  menuButtons;
    menuButtons = [CCMenu menuWithItems:backButton, replayButton, nextButton, nil];
    [menuButtons alignItemsHorizontally];
    menuButtons.position = ccp(240, 30);
    
    [self addChild:menuButtons z:999 tag:1111];

    
    bee1 = [[Bee alloc] initBeeWith:self];
    [bee1 setPosition:ccp(100,200)];
    [self addGameObj:bee1];
}

-(void)tutorialLibFinishedStoryboard:(int)_storyIndex {
    [tutorial runNextStoryboard];
    //[tutorial removeFromParentAndCleanup:YES];
    //[tutorial release];
    //tutorial = nil;
}

-(void)tutorialButtonObjectClicked:(NSString *)_buttonName {
    NSLog(@"button name: %@", _buttonName);
    
    if([_buttonName isEqualToString:@"NextStoryButton"]) {
        [tutorial runStoryboardAtIndex:2];
    }
}

@end