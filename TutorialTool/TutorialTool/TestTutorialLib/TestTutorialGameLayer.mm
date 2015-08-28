//
//  TestTutorialGameLayer.m
//  LibGame
//
//  Created by User on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestTutorialGameLayer.h"
#import "TestTutorialController.h"
#import "MainWindow.h"

@implementation TestTutorialGameLayer

-(id)initTestTutorialGameLayerWith:(iCoreGameController *)_mainGameController {
    self = [super initGameLayerWith:_mainGameController];
    
    self.isMouseEnabled = YES;
    [self createb2World];
    [self loadGameComponents];

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
    CCSprite *background = [CCSprite spriteWithFile:@"TestTutorialLib/Images/Background1.jpeg"];
    background.position = ccp(240, 320);
    [self addChild:background];
    
    CCLabelTTF *textGuide = [CCLabelTTF labelWithString:@"Tutorial screen!" fontName:@"Marker Felt" fontSize:14];
    textGuide.position = ccp(240, 300);
    [self addChild:textGuide];
    
    NSString *dataFileName = [[NSBundle mainBundle] pathForResource:@"TestTutorialLib/FruitWarTutorial/Tutorial" ofType:@"plist"];
    
    mainTutorial = [[TutorialSpriteLib alloc]initTutorialSpriteLibWithDataFileName:dataFileName withResourcePath:@""];
    
    mainTutorial.position = ccp(40, 60.5);
    mainTutorial.delegate = self;    
    [self addChild:mainTutorial z:1000];
    
    CCMenuItemLabel *menuItem_1 = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Previous Tutorial" fontName:@"Marker Felt" fontSize:20] target:self selector:@selector(runTutorialStyle1)];
    
    CCMenuItemLabel *menuItem_2 = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Run" fontName:@"Marker Felt" fontSize:20] target:self selector:@selector(runTutorial)];
    
    CCMenuItemLabel *menuItem_3 = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Next Tutorial" fontName:@"Marker Felt" fontSize:20] target:self selector:@selector(runTutorialStyle2)];
    
    CCMenu *menu = [[CCMenu alloc] initWithArray:[NSArray arrayWithObjects:menuItem_1, menuItem_2, menuItem_3, nil]];
    [menu alignItemsHorizontallyWithPadding:80];
    menu.position = ccp(240, 40);
    [self addChild:menu z:10000];
}

-(void)runTutorial {
    [mainTutorial runStoryboardAtIndex:0];
}

-(void)runTutorialStyle1 {
    [((TestTutorialController *)mainGameController) runPreviousStyle];
}

-(void)runTutorialStyle2 {
     [((TestTutorialController *)mainGameController) runNextStyle];
}

-(void)tutorialButtonObjectClicked:(NSString *)_buttonName {
    NSLog(@"Tutorial button clicked delegate");
    
    if([_buttonName isEqualToString:@"NextButton"]) {
        if(mainTutorial.currentStoryboardRunning + 1 >= [mainTutorial getStoryboardsCount]) {
            [mainTutorial stopTutorial];
        } else {
            [mainTutorial runNextStoryboard];
        }
    } else if([_buttonName isEqualToString:@"BackButton"]) {
        if(mainTutorial.currentStoryboardRunning == 0) {
            [mainTutorial stopTutorial];
        } else {
            [mainTutorial runPreviousStoryboard];
        }
    }
}

-(void)tutorialLibFinishedStoryboard:(int)_storyIndex {
    NSLog(@"Tutorial index %d finished", _storyIndex);
}

-(void)dealloc {
    NSLog(@"Game screen dealloc");
    
    [super dealloc];
}

@end
