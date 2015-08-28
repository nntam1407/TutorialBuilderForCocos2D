//
//  TestTutorialGameLayer.h
//  LibGame
//
//  Created by User on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameLayer.h"
#import "MainWindow.h"
#import "TutorialSpriteLib.h"

@interface TestTutorialGameLayer : GameLayer <TutorialLibDelegate> {
    TutorialSpriteLib *mainTutorial;
}

-(id)initTestTutorialGameLayerWith:(iCoreGameController *)_mainGameController;
-(void)runTutorial;

@end
