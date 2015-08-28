//
//  AppDelegate.mm
//  TutorialTool
//
//  Created by User on 9/27/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import "AppDelegate.h"
#import "HelloWorldLayer.h"
#import "TestTutorialController.h"

@implementation TutorialToolAppDelegate
@synthesize window = window_, glView = glView_;
@synthesize mainWindow = mainWindow_;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	
}

-(void)applicationWillFinishLaunching:(NSNotification *)notification {
    CCDirectorMac *director = (CCDirectorMac*) [CCDirector sharedDirector];
    
	// enable FPS and SPF
	[director setDisplayStats:NO];
	
	// connect the OpenGL view with the director
	[director setView:glView_];
    
	// EXPERIMENTAL stuff.
	// 'Effects' don't work correctly when autoscale is turned on.
	// Use kCCDirectorResize_NoScale if you don't want auto-scaling.
	//[director setResizeMode:kCCDirectorResize_AutoScale];
    [director setResizeMode:kCCDirectorResize_NoScale];
    
	// Enable "moving" mouse event. Default no.
	[window_ setAcceptsMouseMovedEvents:YES];
    
	// Center main window
	[window_ center];
    
	/*CCScene *scene = [CCScene node];
     [scene addChild:[HelloWorldLayer node]];
     
     [director runWithScene:scene];*/
    
    TestTutorialController *testTutorialGameController = [[TestTutorialController alloc] initTestTutorialControllerWith:[CCDirector sharedDirector]];
    testTutorialGameController.mainWindow = mainWindow_;
    mainWindow_.tutorialCocosViewController = testTutorialGameController;
    
    [testTutorialGameController startUp];
    
    //Set default iphone type edit is iphone 4 landscape
    [testTutorialGameController updateDevideWithType:DEVICE_TYPE_IPHONE_4 viewMode:DEVICE_VIEW_MODE_LANDSCAPE];
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed: (NSApplication *) theApplication
{
	return YES;
}

-(void)application:(NSApplication *)sender openFiles:(NSArray *)filenames {
    [self openFiles:filenames];
}

-(void)openFiles:(NSArray *)_fileNames {
    for( NSString* filename in _fileNames )
	{
		if( [filename hasSuffix:@".tpproject"] )
		{
			[mainWindow_ openProjectFileWithFileName:filename];
            
            [window_ makeKeyAndOrderFront:self]; 
		} 
        else {
            [mainWindow_ showAlertMessageWith:window_ title:@"Error!" message:@"Can not open file!"];
        }
	}
}

- (void)dealloc
{
	[[CCDirector sharedDirector] end];
	[window_ release];
	[super dealloc];
}

#pragma mark AppDelegate - IBActions

- (IBAction)toggleFullScreen: (id)sender
{
	CCDirectorMac *director = (CCDirectorMac*) [CCDirector sharedDirector];
	[director setFullScreen: ! [director isFullScreen] ];
}

@end
